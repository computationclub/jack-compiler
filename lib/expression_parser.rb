require_relative 'vm_writer'

class ExpressionParser
  This = Object.new
  Number = Struct.new(:value) do
    def emit(vm_writer, _symbol_table, klass)
      vm_writer.write_push('constant', value)
    end
  end

  String = Struct.new(:value) do
    def emit(vm_writer, _symbol_table, klass)
      emit_constructor(vm_writer)
      emit_chars(vm_writer)
    end

    private
    def emit_constructor(vm_writer)
      vm_writer.write_push('constant', chars.length)
      vm_writer.write_call('String.new', 1)
    end
    def chars
      value.unpack('U*')
    end
    def emit_chars(vm_writer)
      chars.each do |char|
        vm_writer.write_push('constant', char)
        vm_writer.write_call('String.appendChar', 2)
      end
    end
  end

  Variable = Struct.new(:value) do
    def emit_read(vm_writer, symbol_table, _klass)
      vm_writer.write_push(symbol_table.kind_of(value), symbol_table.index_of(value))
    end
    alias_method :emit, :emit_read
    def emit_assignment_to(assignment_expression, vm_writer, symbol_table, klass)
      assignment_expression.emit(vm_writer, symbol_table, klass)
      vm_writer.write_pop(symbol_table.kind_of(value), symbol_table.index_of(value))
    end
  end

  ArrayReference = Struct.new(:variable, :index_expression) do
    def emit_read(vm_writer, symbol_table, klass)
      emit_index(vm_writer, symbol_table, klass)
      emit_dereference(vm_writer)
      vm_writer.write_push('that', 0)
    end
    alias_method :emit, :emit_read
    def emit_assignment_to(assignment_expression, vm_writer, symbol_table, klass)
      emit_index(vm_writer, symbol_table, klass)
      emit_dereference(vm_writer)
      assignment_expression.emit(vm_writer, symbol_table, klass)
      vm_writer.write_pop('that', 0)
    end
    private
    def emit_index(vm_writer, symbol_table, klass)
      variable.emit(vm_writer, symbol_table, klass)
      index_expression.emit(vm_writer, symbol_table, klass)
      vm_writer.write_arithmetic('add')
    end
    def emit_dereference(vm_writer)
      vm_writer.write_pop('pointer', 1)
    end
  end

  BinaryOperation = Struct.new(:operation, :left_node, :right_node) do
    def emit(vm_writer, symbol_table, klass)
      left_node.emit(vm_writer, symbol_table, klass)
      right_node.emit(vm_writer, symbol_table, klass)
      vm_writer.write_binary_operation(operation)
    end
  end

  UnaryOperation = Struct.new(:operation, :expression) do
    def emit(vm_writer, symbol_table, klass)
      expression.emit(vm_writer, symbol_table, klass)
      vm_writer.write_unary_operation(operation)
    end
  end

  Keyword = Struct.new(:value) do
    def emit(vm_writer, symbol_table, klass)
      case value
      when 'true'
        vm_writer.write_push('constant', '0')
        vm_writer.write_arithmetic('not')
      when 'null', 'false'
        vm_writer.write_push('constant', '0')
      when 'this'
        vm_writer.write_push('pointer', 0)
      end
    end
  end

  MethodCall = Struct.new(:recipient, :method, :arguments) do
    def emit(vm_writer, symbol_table, klass)
      Emitter.new(self, vm_writer, symbol_table, klass).emit
    end
    Emitter = Struct.new(:method_call, :vm_writer, :symbol_table, :klass) do
      def emit
        emit_recipient
        emit_arguments
        emit_invocation
      end
      private
      def emit_recipient
        if recipient_is_this?
          vm_writer.write_push('pointer', 0)
        elsif recipient_is_variable?
          Variable.new(method_call.recipient).emit(vm_writer, symbol_table, klass)
        end
      end
      def emit_arguments
        method_call.arguments.each { |argument| argument.emit(vm_writer, symbol_table, klass) }
      end
      def emit_invocation
        vm_writer.write_call(method_name, arguments_length)
      end
      def arguments_length
        @_arguments_lenght ||=
          if recipient_is_this? || recipient_is_variable?
            method_call.arguments.length + 1
          else
            method_call.arguments.length
          end
      end
      def method_name
        @_method_name ||=
          if recipient_is_this?
            "#{klass.name}.#{method_call.method}"
          elsif recipient_is_variable?
            "#{recipient_type}.#{method_call.method}"
          else
            "#{method_call.recipient}.#{method_call.method}"
          end
      end
      def recipient_is_variable?
        (!recipient_is_this?) && recipient_kind != :none
      end
      def recipient_is_this?
        method_call.recipient == This
      end
      def recipient_kind
        @_recipient_kind ||= symbol_table.kind_of(method_call.recipient)
      end
      def recipient_type
        @_recipient_type ||= symbol_table.type_of(method_call.recipient)
      end
    end
  end

  attr_reader :tokenizer
  private :tokenizer

  def initialize(tokenizer)
    @tokenizer = tokenizer
  end

  def parse_expression
    left_node = parse_term

    return left_node unless tokenizer.has_more_tokens?

    tokenizer.advance

    if (tokenizer.token_type == Tokenizer::SYMBOL) && (%w[+ - * / & | < > =].include?(tokenizer.symbol))
      operation = tokenizer.symbol
      tokenizer.advance

      right_node = parse_expression

      BinaryOperation.new(operation, left_node, right_node)
    elsif (tokenizer.token_type == Tokenizer::SYMBOL) && (%w[. (].include? tokenizer.symbol)
      symbol = tokenizer.symbol
      tokenizer.advance
      if symbol == '.'
        fail 'Can only call methods on identifiers' unless left_node.is_a? Variable
        recipient = left_node.value
        parse_method_call(recipient: recipient)
      else
        fail 'method calls must be identifiers' unless left_node.is_a? Variable
        method_name = left_node.value
        parse_method_call(method_name: method_name)
      end
    elsif (tokenizer.token_type == Tokenizer::SYMBOL) && tokenizer.symbol == '['
      tokenizer.advance
      array_variable = left_node
      index_expression = parse_expression

      fail 'must close array reference' unless (tokenizer.token_type == Tokenizer::SYMBOL) && tokenizer.symbol == ']'
      tokenizer.advance if tokenizer.has_more_tokens?

      ArrayReference.new(array_variable, index_expression)
    else
      left_node
    end
  end

  def parse_term
    case tokenizer.token_type
    when Tokenizer::INT_CONST
      number = tokenizer.int_val

      Number.new(number)
    when Tokenizer::STRING_CONST
      string = tokenizer.string_val

      String.new(string)
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
      when '-', '~'
        parse_unary_operation
      end
    end
  end

  def parse_subroutine_call
    fail 'Must start subroutine call with an identifier' unless tokenizer.token_type == Tokenizer::IDENTIFIER
    recipient_or_method = tokenizer.identifier
    tokenizer.advance
    fail 'Expected "." or "("' unless (tokenizer.token_type == Tokenizer::SYMBOL) && (%w[. (].include? tokenizer.symbol)
    symbol = tokenizer.symbol
    tokenizer.advance
    if symbol == '.'
      parse_method_call(recipient: recipient_or_method)
    else
      parse_method_call(method_name: recipient_or_method)
    end
  end

  private

  def parse_unary_operation
    fail 'Not a supported unary operation' unless %w(- ~).include?(tokenizer.symbol)
    operation = tokenizer.symbol
    tokenizer.advance
    expression = parse_term

    UnaryOperation.new(operation, expression)
  end

  def parse_nested_expression
    fail 'Not an opening parenthesis' unless tokenizer.symbol == '('
    tokenizer.advance

    node = parse_expression

    fail 'Not a closing parenthesis' unless tokenizer.token_type == Tokenizer::SYMBOL && tokenizer.symbol == ')'

    node
  end

  def parse_method_call(recipient:nil, method_name:nil)
    fail 'Must provide recipient or method' if recipient.nil? && method_name.nil?
    fail 'Cannot provide both recipient and method' unless recipient.nil? || method_name.nil?

    if method_name.nil?
      fail 'Not an identifier' unless tokenizer.token_type == Tokenizer::IDENTIFIER
      method_name = tokenizer.identifier
      tokenizer.advance

      fail 'Must supply opening parenthesis for method call' unless (tokenizer.token_type == Tokenizer::SYMBOL && tokenizer.symbol == '(')
      tokenizer.advance
    else
      recipient = This
    end

    arguments = []

    loop do
      break if (tokenizer.token_type == Tokenizer::SYMBOL) && (tokenizer.symbol == ')')
      arguments << parse_expression
      tokenizer.advance if (tokenizer.token_type == Tokenizer::SYMBOL) && (tokenizer.symbol == ',')
      break unless tokenizer.has_more_tokens?
    end

    fail 'Must supply closing parenthesis for method call' unless (tokenizer.token_type == Tokenizer::SYMBOL && tokenizer.symbol == ')')
    tokenizer.advance if tokenizer.has_more_tokens?

    MethodCall.new(recipient, method_name, arguments)
  end

end
