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

  attr_reader :tokenizer
  private :tokenizer

  def initialize(tokenizer)
    @tokenizer = tokenizer
  end

  def parse
    case tokenizer.token_type
    when Tokenizer::INT_CONST
      number = tokenizer.int_val

      Number.new(number)
    else
      identifier = tokenizer.identifier

      Variable.new(identifier)
    end
  end
end
