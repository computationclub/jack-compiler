require_relative 'symbol_table'
require_relative 'vm_writer'
require_relative 'expression_parser'
require_relative 'labeller'

class CompilationEngine
  attr_reader :input, :vm_writer
  attr_accessor :current_class, :current_method

  JackClass = Struct.new(:name, :field_count)

  JackMethod = Struct.new(:klass, :name, :method_type, :return_type, :argument_count, :local_var_count) do
    def emit(vm_writer)
      vm_writer.write_function("#{klass.name}.#{name}", local_var_count)
      emit_memory_allocation(vm_writer) if constructor?
      emit_setup_this_segment(vm_writer) if instance_method?
    end
    private
    def constructor?
      method_type == 'constructor'
    end
    def instance_method?
      method_type == 'method'
    end
    def emit_memory_allocation(vm_writer)
      vm_writer.write_push('constant', klass.field_count)
      vm_writer.write_call('Memory.alloc', 1)
      vm_writer.write_pop('pointer', 0)
    end
    def emit_setup_this_segment(vm_writer)
      vm_writer.write_push('argument', 0)
      vm_writer.write_pop('pointer', 0)
    end
  end

  def initialize(input, output)
    @input = input
    @vm_writer = VMWriter.new(output)
    @symbols = SymbolTable.new
  end

  def compile_class
    # Get the ball moving!
    input.advance

    consume(Tokenizer::KEYWORD, 'class')

    self.current_class = JackClass.new(current_token)
    consume(Tokenizer::IDENTIFIER)

    consume_wrapped('{') do
      class_field_count = 0
      while %w[field static].include? current_token
        field_type = current_token
        class_var_count = compile_class_var_dec
        class_field_count += class_var_count if field_type == 'field'
      end

      current_class.field_count = class_field_count

      while %w[constructor function method].include? current_token
        compile_subroutine
      end
    end
  end

  def compile_class_var_dec
    kind = current_token # field, static, etc.
    consume(Tokenizer::KEYWORD)

    type = current_token # int, char, etc.
    consume_type

    fields_in_declaration_count = 0
    consume_separated(',') do
      name = current_token
      @symbols.define(name, type, kind)
      consume_identifier
      fields_in_declaration_count += 1
    end

    consume(Tokenizer::SYMBOL, ';')
    fields_in_declaration_count
  end

  def compile_subroutine
    @symbols.start_subroutine
    reset_labels

    method_type = current_token
    consume(Tokenizer::KEYWORD)

    return_type = current_token
    try_consume(Tokenizer::KEYWORD, 'void') || consume_type

    method_name = current_token
    consume(Tokenizer::IDENTIFIER)

    n = 0
    consume_wrapped('(') do
      n = compile_parameter_list
    end

    self.current_method = JackMethod.new(current_class, method_name, method_type, return_type, n)

    compile_subroutine_body
  end

  def compile_parameter_list
    return 0 if current_token == ')'

    n = 0
    consume_separated(',') do
      kind = :arg

      type = current_token # int, char, etc.
      consume_type

      name = current_token
      @symbols.define(name, type, kind)
      consume_identifier

      n += 1
    end

    n
  end

  def compile_subroutine_body
    consume_wrapped('{') do
      local_var_count = 0
      while current_token == "var"
        local_var_count += compile_var_dec
      end

      current_method.local_var_count = local_var_count

      current_method.emit(vm_writer)

      compile_statements
    end
  end

  def compile_statements
    loop do
      case current_token
      when 'let'
        compile_let
      when 'do'
        compile_do
      when 'return'
        compile_return
      when 'if'
        compile_if
      when 'while'
        compile_while
      else
        break
      end
    end
  end

  def compile_while
    consume(Tokenizer::KEYWORD, 'while')

    expression_label = build_label('WHILE_EXP')
    end_label = build_label('WHILE_END')
    vm_writer.write_label(expression_label)
    consume_wrapped('(') do
      compile_expression
    end
    vm_writer.write_arithmetic('not')
    vm_writer.write_if(end_label)

    consume_wrapped('{') do
      compile_statements
    end
    vm_writer.write_goto(expression_label)
    vm_writer.write_label(end_label)
  end

  def compile_var_dec
    consume(Tokenizer::KEYWORD, 'var')

    kind = :var

    type = current_token
    consume_type

    variables_in_declaration_count = 0
    consume_separated(',') do
      name = current_token
      @symbols.define(name, type, kind)
      consume_identifier
      variables_in_declaration_count += 1
    end

    consume(Tokenizer::SYMBOL, ';')
    variables_in_declaration_count
  end

  def compile_let
    consume(Tokenizer::KEYWORD, 'let')

    variable = ExpressionParser::Variable.new(current_token)
    consume_identifier

    array_index_expression = nil
    try_consume_wrapped('[') do
      array_index_expression = extract_expression
    end
    unless array_index_expression.nil?
      variable = ExpressionParser::ArrayReference.new(variable, array_index_expression)
    end

    consume(Tokenizer::SYMBOL, '=')

    assignment_expression = extract_expression

    consume(Tokenizer::SYMBOL, ';')

    variable.emit_assignment_to(assignment_expression, vm_writer, @symbols, current_class)
  end

  def compile_do
    consume(Tokenizer::KEYWORD, 'do')

    consume_subroutine_call

    consume(Tokenizer::SYMBOL, ';')
    vm_writer.write_pop('temp', 0)
  end

  def compile_return
    consume(Tokenizer::KEYWORD, 'return')

    if current_token == ';'
      vm_writer.write_push('constant', 0)
    else
      compile_expression
    end
    consume(Tokenizer::SYMBOL, ';')
    vm_writer.write_return
  end

  def compile_if
    consume(Tokenizer::KEYWORD, 'if')

    end_label = build_label('IF_END')
    then_label = build_label('IF_TRUE')
    else_label = build_label('IF_FALSE')

    consume_wrapped('(') do
      compile_expression
    end
    vm_writer.write_if(then_label)
    vm_writer.write_goto(else_label)

    vm_writer.write_label(then_label)
    consume_wrapped('{') do
      compile_statements
    end
    if try_consume(Tokenizer::KEYWORD, 'else')
      vm_writer.write_goto(end_label)
      vm_writer.write_label(else_label)
      consume_wrapped('{') do
        compile_statements
      end
      vm_writer.write_label(end_label)
    else
      vm_writer.write_label(else_label)
    end
  end

  def compile_expression_list
    return if current_token == ')'

    consume_separated(',') do
      compile_expression
    end
  end

  def compile_expression
    extract_expression.emit(vm_writer, @symbols, current_class)
  end

  def extract_expression
    ExpressionParser.new(input).parse_expression
  end

  def compile_term
    return if try_consume(Tokenizer::INT_CONST) ||
              try_consume(Tokenizer::STRING_CONST) ||
              try_consume_wrapped('(') { compile_expression }

    case current_token
    when 'true', 'false', 'null', 'this' #keywordConst
      consume(Tokenizer::KEYWORD)
    when '-', '~' # unary op
      consume(Tokenizer::SYMBOL)
      compile_term
    else
      name = current_token
      input.advance

      case current_token
      when '['
        # b.identifier(
        #   name,
        #   type: @symbols.type_of(name),
        #   kind: @symbols.kind_of(name),
        #   index: @symbols.index_of(name)
        # )

        consume_wrapped('[') do
          compile_expression
        end
      when '.', '('
        # b.identifier(name)
        consume_subroutine_call(skip_identifier: true)
      else
        # b.identifier(
        #   name,
        #   type: @symbols.type_of(name),
        #   kind: @symbols.kind_of(name),
        #   index: @symbols.index_of(name)
        # )
      end
    end
  end

  private

  def consume(expected_type, expected_token = nil)
    unless try_consume(expected_type, expected_token)
      if expected_token
        raise "expected a #{expected_type} `#{expected_token}`, got #{current_type} `#{current_token}`"
      else
        raise "expected any #{expected_type}, got #{current_type} `#{current_token}`"
      end
    end
  end

  def try_consume(expected_type, expected_token = nil)
    return false unless current_type == expected_type &&
                        current_token == (expected_token || current_token)

    input.advance if input.has_more_tokens?
    true
  end

  def consume_identifier
    try_consume(Tokenizer::IDENTIFIER)
  end

  def consume_wrapped(opening, &block)
    unless try_consume_wrapped(opening) { block.call }
      raise "expected wrapping `#{opening}`, got #{current_type}, `#{current_token}`"
    end
  end

  def try_consume_wrapped(opening)
    closing = case opening
    when '(' then ')'
    when '[' then ']'
    when '{' then '}'
    else raise "Unknown opening brace: `#{opening}`"
    end

    if try_consume(Tokenizer::SYMBOL, opening)
      yield
      consume(Tokenizer::SYMBOL, closing)
      true
    end
  end

  def current_type
    input.token_type
  end

  def current_token
    case current_type
      when Tokenizer::KEYWORD
        input.keyword
      when Tokenizer::SYMBOL
        input.symbol
      when Tokenizer::IDENTIFIER
        input.identifier
      when Tokenizer::INT_CONST
        input.int_val
      when Tokenizer::STRING_CONST
        input.string_val
    end
  end

  def consume_separated(sep)
    begin
      yield
    end while try_consume(Tokenizer::SYMBOL, sep)
  end

  def consume_type
    case current_type
    when Tokenizer::KEYWORD
      if %w[int char boolean].include? current_token
        consume(Tokenizer::KEYWORD)
      end
    else
      consume(Tokenizer::IDENTIFIER)
    end
  end

  def consume_subroutine_call
    subroutine_call = ExpressionParser.new(input).parse_subroutine_call
    subroutine_call.emit(vm_writer, @symbols, current_class)
  end

  def build_label(label_base)
    @labeller.label(label_base)
  end

  def reset_labels
    @labeller = Labeller.new
  end
end
