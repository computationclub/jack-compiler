require 'builder'

class Parser
  attr_reader :input

  def initialize(input, output)
    @input = Enumerator.new do |yielder|
      while input.has_more_tokens?
        input.advance

        type = input.token_type
        text = case type
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

        yielder.yield [type, text]
      end
    end

    @builder = Builder::XmlMarkup.new(target: output, indent: 2)
  end

  def compile_class
    b.tag!(:class) do
      consume(Tokenizer::KEYWORD, 'class')

      _, identifier = input.next # identifier
      b.identifier(identifier)

      consume(Tokenizer::SYMBOL, '{')

      _, keyword = input.peek # 'field' or 'static'

      while %w[field static].include? keyword
        compile_class_var_dec
        _, keyword = input.peek
      end

      while %w[constructor function method].include? keyword
        compile_subroutine
        _, keyword = input.peek
      end

      consume(Tokenizer::SYMBOL, '}')
    end
  end

  def compile_class_var_dec
    b.classVarDec do
      _, keyword = input.next
      b.keyword(keyword)

      _, keyword = input.next
      b.keyword(keyword)

      begin
        _, identifier = input.next
        b.identifier(identifier)

        _, symbol = input.next
        b.symbol(symbol)
      end while symbol == ','
    end
  end

  def compile_subroutine
    b.subroutineDec do
      _, keyword = input.next
      b.keyword(keyword)

      type, text = input.next
      case type
      when Tokenizer::KEYWORD
        b.keyword(text)
      when Tokenizer::IDENTIFIER
        b.identifier(text)
      end

      _, identifier = input.next # subroutine name
      b.identifier(identifier)

      consume(Tokenizer::SYMBOL, '(')

      compile_parameter_list

      consume(Tokenizer::SYMBOL, ')')

      compile_subroutine_body
    end
  end

  def compile_parameter_list
    b.parameterList do
      _, symbol = input.peek

      until symbol == ')'
        _, keyword = input.next
        b.keyword(keyword)

        _, identifier = input.next
        b.identifier(identifier)

        _, symbol = input.peek
        if symbol == ','
          b.symbol(',')
          input.next
        end
      end
    end
  end

  def compile_subroutine_body
    b.subroutineBody do
      consume(Tokenizer::SYMBOL, '{')

      compile_statements

      consume(Tokenizer::SYMBOL, '}')
    end
  end

  def compile_statements
    b.statements do
      loop do
        _, text = input.peek
        case text
        when 'let'
          compile_let
        when 'do'
          compile_do
        when 'return'
          compile_return
        when 'if'
          compile_if
        else
          break
        end
      end
    end
  end

  def compile_let
    b.letStatement do
      consume(Tokenizer::KEYWORD, 'let')

      _, identifier = input.next
      b.identifier(identifier)

      consume(Tokenizer::SYMBOL, '=')

      compile_expression

      consume(Tokenizer::SYMBOL, ';')
    end
  end

  def compile_do
    b.doStatement do
      consume(Tokenizer::KEYWORD, 'do')

      _, identifier = input.next
      b.identifier(identifier)

      _, text = input.peek
      if text == '.'
        input.next
        b.symbol('.')

        _, identifier = input.next
        b.identifier(identifier)
      end

      consume(Tokenizer::SYMBOL, '(')

      compile_expression_list

      consume(Tokenizer::SYMBOL, ')')
      consume(Tokenizer::SYMBOL, ';')
    end
  end

  def compile_return
    b.returnStatement do
      consume(Tokenizer::KEYWORD, 'return')

      _, text = input.peek
      compile_expression unless text == ';'

      input.next
      b.symbol(';')
    end
  end

  def compile_if
    b.ifStatement do
      consume(Tokenizer::KEYWORD, 'if')
      consume(Tokenizer::SYMBOL, '(')

      compile_expression

      consume(Tokenizer::SYMBOL, ')')

      consume(Tokenizer::SYMBOL, '{')

      compile_statements

      consume(Tokenizer::SYMBOL, '}')
    end
  end

  def compile_expression_list
    b.expressionList do
      type, _ = input.peek
      while type == Tokenizer::IDENTIFIER
        compile_expression

        _, symbol = input.peek
        if symbol == ','
          b.symbol(',')
          input.next
        end

        type, _ = input.peek
      end
    end
  end

  def compile_expression
    b.expression do
      compile_term
    end
  end

  def compile_term
    b.term do
      _, identifier = input.next
      b.identifier(identifier)
    end
  end

  private

  def consume(expected_type, expected_token)
    actual_type, actual_token = input.next

    unless actual_type == expected_type && actual_token == expected_token
      raise "expected a #{expected_type} `#{expected_token}`, got #{actual_type} `#{actual_token}`"
    end

    b.tag!(expected_type, expected_token)
  end

  def b
    @builder
  end
end
