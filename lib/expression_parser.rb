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

  attr_reader :tokenizer
  private :tokenizer

  def initialize(tokenizer)
    @tokenizer = tokenizer
  end

  def parse
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

      right_node = parse

      BinaryOperation.new(operation, left_node, right_node)
    else
      left_node
    end
  end

  def parse_unary_operation
    fail 'Not a supported unary operation' unless %w(- ~).include?(tokenizer.symbol)
    operation = tokenizer.symbol
    tokenizer.advance
    expression = parse

    UnaryOperation.new(operation, expression)
  end

  def parse_nested_expression
    fail 'Not an opening parenthesis' unless tokenizer.symbol == '('
    tokenizer.advance

    node = parse

    fail 'Not a closing parenthesis' unless tokenizer.token_type == Tokenizer::SYMBOL && tokenizer.symbol == ')'

    node
  end
end
