require 'tokenizer'
require 'compilation_engine'

module CompilesDownTo
  def compile_down_to(expected_vm_code)
    CompilesDownTo::Matcher.new(expected_vm_code)
  end

  class Matcher
    attr_reader :expected_vm_code
    alias_method :expected, :expected_vm_code

    def initialize(expected_vm_code)
      self.expected_vm_code = expected_vm_code
    end

    def matches?(jack_source)
      compile(jack_source)
      matcher.matches?(actual_vm_code)
    end

    def actual_vm_code
      output.string
    end
    alias_method :actual, :actual_vm_code

    def failure_message
      matcher.failure_message
    end
    def failure_message_when_negated
      matcher.failure_message_when_negated
    end
    def diffable?
      true
    end

    private
    attr_writer :expected_vm_code
    def output
      @_output ||= StringIO.new
    end

    def compile(jack_source)
      tokenizer = Tokenizer.new(jack_source)
      CompilationEngine.new(tokenizer, output).compile_class
    end

    def matcher
      @_matcher ||= RSpec::Matchers::BuiltIn::Eq.new(expected_vm_code)
    end
  end
end
