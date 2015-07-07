require_relative 'vm_writer'

class ExpressionParser
  attr_reader :tokenizer
  private :tokenizer

  def initialize(tokenizer)
    @tokenizer = tokenizer
  end

  def parse
    number = tokenizer.int_val

    Struct.new(:value) {
      def emit(vm_writer)
        vm_writer.write_push('constant', value)
      end
    }.new(number)
  end
end
