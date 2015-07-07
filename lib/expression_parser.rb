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
    when Tokenizer::SYMBOL
      fail 'Not an opening parenthesis' unless tokenizer.symbol == '('
      tokenizer.advance

      node = parse

      fail 'Not a closing parenthesis' unless tokenizer.token_type == Tokenizer::SYMBOL && tokenizer.symbol == ')'

      node
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
end
