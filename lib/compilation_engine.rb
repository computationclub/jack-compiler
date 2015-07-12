require_relative 'symbol_table'
require_relative 'vm_writer'
require_relative 'expression_parser'
require_relative 'labeller'

class CompilationEngine
  attr_reader :input, :vm_writer

  def initialize(input, output)
    @input = input
    @vm_writer = VMWriter.new(output)
    @symbols = SymbolTable.new
  end

  def compile_class
    # Get the ball moving!
    input.advance

    consume(Tokenizer::KEYWORD, 'class')

    @class_name = current_token
    consume(Tokenizer::IDENTIFIER)

    consume_wrapped('{') do
      while %w[field static].include? current_token
        compile_class_var_dec
      end

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

    consume_separated(',') do
      name = current_token
      @symbols.define(name, type, kind)
      consume_identifier
    end

    consume(Tokenizer::SYMBOL, ';')
  end

  def compile_subroutine
    @symbols.start_subroutine
    reset_labels

    consume(Tokenizer::KEYWORD)

    try_consume(Tokenizer::KEYWORD, 'void') || consume_type

    method_name = full_method_name
    consume(Tokenizer::IDENTIFIER)

    n = 0
    consume_wrapped('(') do
      n = compile_parameter_list
    end

    compile_subroutine_body(method_name)
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

  def compile_subroutine_body(subroutine_name)
    consume_wrapped('{') do
      local_var_count = 0
      while current_token == "var"
        local_var_count += compile_var_dec
      end

      vm_writer.write_function(subroutine_name, local_var_count)

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

    name = current_token
    consume_identifier

    try_consume_wrapped('[') do
      compile_expression
    end

    consume(Tokenizer::SYMBOL, '=')

    compile_expression

    consume(Tokenizer::SYMBOL, ';')
    vm_writer.write_pop(@symbols.kind_of(name), @symbols.index_of(name))
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

    consume_wrapped('(') do
      compile_expression
    end

    consume_wrapped('{') do
      compile_statements
    end

    if try_consume(Tokenizer::KEYWORD, 'else')
      consume_wrapped('{') do
        compile_statements
      end
    end
  end

  def compile_expression_list
    return if current_token == ')'

    consume_separated(',') do
      compile_expression
    end
  end

  def compile_expression
    expression = ExpressionParser.new(input).parse_expression
    expression.emit(vm_writer, @symbols)
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
    subroutine_call.emit(vm_writer, @symbols)
  end

  def full_method_name
    "#{@class_name}.#{current_token}"
  end

  def build_label(label_base)
    @labeller.label(label_base)
  end

  def reset_labels
    @labeller = Labeller.new
  end
end
