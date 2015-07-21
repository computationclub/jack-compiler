require 'tokenizer'
require 'expression_parser'
require 'vm_writer'

module BeParsedInto
  def be_parsed_into(expected_vm_code)
    BeParsedInto::Matcher.new(expected_vm_code, symbol_table, jack_class)
  end

  class Matcher
    attr_reader :expected_vm_code, :symbol_table, :jack_class
    alias_method :expected, :expected_vm_code

    def initialize(expected_vm_code, symbol_table, jack_class)
      self.expected_vm_code = expected_vm_code
      self.symbol_table = symbol_table
      self.jack_class = jack_class
    end

    def matches?(jack_source)
      parse_and_emit(jack_source)
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

    def when_parsed_as(parse_type)
      self.parse_type = parse_type
      self
    end

    private
    attr_reader :parse_type
    attr_writer :expected_vm_code, :symbol_table, :jack_class, :parse_type
    def output
      @_output ||= StringIO.new
    end

    def parse_and_emit(jack_source)
      ExpressionParser.new(build_tokenizer(jack_source))
        .send(parse_method)
        .emit(vm_writer, symbol_table, jack_class)
    end

    def build_tokenizer(jack_source)
      Tokenizer.new(jack_source).tap { |t| t.advance }
    end

    def matcher
      @_matcher ||= RSpec::Matchers::BuiltIn::Eq.new(expected_vm_code)
    end

    def vm_writer
      @_vm_writer ||= VMWriter.new(output)
    end

    def parse_method
      :"parse_#{parse_type || 'expression'}"
    end
  end
end
