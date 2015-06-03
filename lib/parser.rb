require 'builder'

class Parser
  attr_reader :input

  def initialize(input, output)
    @input = input

    @builder = Builder::XmlMarkup.new(target: output, indent: 2)
  end

  def compile_class
    b.tag!(:class) do
      # Get the ball moving!
      input.advance

      consume(Tokenizer::KEYWORD, 'class')

      _, identifier = current_token # identifier
      b.identifier(identifier)
      input.advance

      consume(Tokenizer::SYMBOL, '{')

      _, keyword = current_token # 'field' or 'static'

      while %w[field static].include? keyword
        compile_class_var_dec
        _, keyword = current_token
      end

      while %w[constructor function method].include? keyword
        compile_subroutine
        _, keyword = current_token
      end

      consume(Tokenizer::SYMBOL, '}')
    end
  end

  def compile_class_var_dec
    b.classVarDec do
      _, keyword = current_token
      b.keyword(keyword)
      input.advance

      _, keyword = current_token
      b.keyword(keyword)
      input.advance

      begin
        _, identifier = current_token
        b.identifier(identifier)
        input.advance

        _, symbol = current_token
        b.symbol(symbol)
        input.advance
      end while symbol == ','
    end
  end

  def compile_subroutine
    b.subroutineDec do
      _, keyword = current_token
      b.keyword(keyword)
      input.advance

      type, text = current_token
      case type
      when Tokenizer::KEYWORD
        b.keyword(text)
      when Tokenizer::IDENTIFIER
        b.identifier(text)
      end
      input.advance

      _, identifier = current_token # subroutine name
      b.identifier(identifier)
      input.advance

      consume(Tokenizer::SYMBOL, '(')

      compile_parameter_list

      consume(Tokenizer::SYMBOL, ')')

      compile_subroutine_body
    end
  end

  def compile_parameter_list
    b.parameterList do
      _, symbol = current_token

      until symbol == ')'
        _, keyword = current_token
        b.keyword(keyword)
        input.advance

        _, identifier = current_token
        b.identifier(identifier)
        input.advance

        _, symbol = current_token
        if symbol == ','
          b.symbol(',')
          input.advance
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
        _, text = current_token
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

      _, identifier = current_token
      b.identifier(identifier)
      input.advance

      consume(Tokenizer::SYMBOL, '=')

      compile_expression

      consume(Tokenizer::SYMBOL, ';')
    end
  end

  def compile_do
    b.doStatement do
      consume(Tokenizer::KEYWORD, 'do')

      _, identifier = current_token
      b.identifier(identifier)
      input.advance

      _, text = current_token
      if text == '.'
        b.symbol('.')
        input.advance

        _, identifier = current_token
        b.identifier(identifier)
        input.advance
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

      _, text = current_token
      compile_expression unless text == ';'

      b.symbol(';')
      input.advance
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
      type, _ = current_token
      while type == Tokenizer::IDENTIFIER
        compile_expression

        _, symbol = current_token
        if symbol == ','
          b.symbol(',')
          input.advance
        end

        type, _ = current_token
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
      _, identifier = current_token
      b.identifier(identifier)
      input.advance
    end
  end

  private

  def consume(expected_type, expected_token)
    actual_type, actual_token = current_token

    unless actual_type == expected_type && actual_token == expected_token
      raise "expected a #{expected_type} `#{expected_token}`, got #{actual_type} `#{actual_token}`"
    end

    b.tag!(expected_type, expected_token)

    input.advance if input.has_more_tokens?
  end

  def b
    @builder
  end

  def current_token
    type = input.token_type
    text = case input.token_type
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

    [type, text]
  end
end
