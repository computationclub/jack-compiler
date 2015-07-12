require_relative 'vm_writer'

class ExpressionParser
  Number = Struct.new(:value) do
    def emit(vm_writer, _symbol_table)
      vm_writer.write_push('constant', value)
    end
  end

  Variable = Struct.new(:value) do
    def emit(vm_writer, symbol_table)
      vm_writer.write_push(symbol_table.kind_of(value), symbol_table.index_of(value))
    end
  end

  BinaryOperation = Struct.new(:operation, :left_node, :right_node) do
    def emit(vm_writer, symbol_table)
      left_node.emit(vm_writer, symbol_table)
      right_node.emit(vm_writer, symbol_table)
      vm_writer.write_operation(operation)
    end
  end

  UnaryOperation = Struct.new(:operation, :expression) do
    def emit(vm_writer, symbol_table)
      expression.emit(vm_writer, symbol_table)
      vm_writer.write_operation(operation)
    end
  end

  Keyword = Struct.new(:value) do
    def emit(vm_writer, symbol_table)
      case value
      when 'true'
        vm_writer.write_push('constant', '1')
        vm_writer.write_arithmetic('neg')
      when 'null', 'false'
        vm_writer.write_push('constant', '0')
      end
    end
  end

  MethodCall = Struct.new(:recipient, :method, :arguments) do
    def emit(vm_writer, symbol_table)
      arguments.each { |argument| argument.emit(vm_writer, symbol_table) }
      vm_writer.write_call("#{recipient}.#{method}", arguments.length)
    end
  end

  attr_reader :tokenizer
  private :tokenizer

  def initialize(tokenizer)
    @tokenizer = tokenizer
  end

  def parse_expression
    left_node = case tokenizer.token_type
    when Tokenizer::INT_CONST
      number = tokenizer.int_val

      Number.new(number)
    when Tokenizer::IDENTIFIER
      identifier = tokenizer.identifier

      Variable.new(identifier)
    when Tokenizer::KEYWORD
      keyword = tokenizer.keyword

      Keyword.new(keyword)
    when Tokenizer::SYMBOL
      case tokenizer.symbol
      when '('
        parse_nested_expression
      else
        parse_unary_operation
      end
    end

    return left_node unless tokenizer.has_more_tokens?

    tokenizer.advance

    if %w[+ - * / & | < > =].include?(tokenizer.symbol)
      operation = tokenizer.symbol
      tokenizer.advance

      right_node = parse_expression

      BinaryOperation.new(operation, left_node, right_node)
    elsif tokenizer.symbol == '.'
      fail 'Can only call methods on identifiers' unless left_node.is_a? Variable
      tokenizer.advance
      recipient = left_node.value
      parse_method_call(recipient)
    else
      left_node
    end
  end

  def parse_subroutine_call
    fail 'Must start subroutine call with an identifier' unless tokenizer.token_type == Tokenizer::IDENTIFIER
    recipient_or_method = tokenizer.identifier
    tokenizer.advance
    fail 'Expected "." or "("' unless (tokenizer.token_type == Tokenizer::SYMBOL) && (%w[. (].include? tokenizer.symbol)
    tokenizer.advance
    case tokenizer.symbol
    when '.'
      parse_method_call(recipient_or_method)
    end
  ensure
    tokenizer.advance if tokenizer.has_more_tokens?
  end

  private

  def parse_unary_operation
    fail 'Not a supported unary operation' unless %w(- ~).include?(tokenizer.symbol)
    operation = tokenizer.symbol
    tokenizer.advance
    expression = parse_expression

    UnaryOperation.new(operation, expression)
  end

  def parse_nested_expression
    fail 'Not an opening parenthesis' unless tokenizer.symbol == '('
    tokenizer.advance

    node = parse_expression

    fail 'Not a closing parenthesis' unless tokenizer.token_type == Tokenizer::SYMBOL && tokenizer.symbol == ')'

    node
  end

  def parse_method_call(recipient)
    fail 'Not an identifier' unless tokenizer.token_type == Tokenizer::IDENTIFIER
    method_name = tokenizer.identifier
    tokenizer.advance

    fail 'Must supply opening parenthesis for method call' unless (tokenizer.token_type == Tokenizer::SYMBOL && tokenizer.symbol == '(')
    tokenizer.advance

    arguments = []

    loop do
      break if (tokenizer.token_type == Tokenizer::SYMBOL && tokenizer.symbol == ')')
      arguments << parse_expression
      tokenizer.advance if (tokenizer.token_type == Tokenizer::SYMBOL && tokenizer.symbol == ',')
      break unless tokenizer.has_more_tokens?
    end

    fail 'Must supply closing parenthesis for method call' unless (tokenizer.token_type == Tokenizer::SYMBOL && tokenizer.symbol == ')')

    MethodCall.new(recipient, method_name, arguments)
  end

end
