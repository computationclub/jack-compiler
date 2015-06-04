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

      consume(Tokenizer::IDENTIFIER)

      consume(Tokenizer::SYMBOL, '{')

      while %w[field static].include? current_token
        compile_class_var_dec
      end

      while %w[constructor function method].include? current_token
        compile_subroutine
      end

      consume(Tokenizer::SYMBOL, '}')
    end
  end

  def compile_class_var_dec
    b.classVarDec do
      consume(Tokenizer::KEYWORD)

      case current_type
      when Tokenizer::KEYWORD
        if %w[int char boolean].include? current_token
          consume(Tokenizer::KEYWORD)
        end
      else
        consume(Tokenizer::IDENTIFIER)
      end

      begin
        consume(Tokenizer::IDENTIFIER)

        symbol = current_token
        consume(Tokenizer::SYMBOL)
      end while symbol == ','
    end
  end

  def compile_subroutine
    b.subroutineDec do
      consume(Tokenizer::KEYWORD)

      case current_type
      when Tokenizer::KEYWORD
        b.keyword(current_token)
      when Tokenizer::IDENTIFIER
        b.identifier(current_token)
      end
      input.advance

      consume(Tokenizer::IDENTIFIER) # subroutine name

      consume(Tokenizer::SYMBOL, '(')

      compile_parameter_list

      consume(Tokenizer::SYMBOL, ')')

      compile_subroutine_body
    end
  end

  def compile_parameter_list
    b.parameterList do
      until current_token == ')'
        consume(Tokenizer::KEYWORD)
        consume(Tokenizer::IDENTIFIER)

        if current_token == ','
          consume(Tokenizer::SYMBOL, ',')
        end
      end
    end
  end

  def compile_subroutine_body
    b.subroutineBody do
      consume(Tokenizer::SYMBOL, '{')

      while current_token == "var"
        compile_var_dec
      end

      compile_statements

      consume(Tokenizer::SYMBOL, '}')
    end
  end

  def compile_statements
    b.statements do
      loop do
        case current_token
        when 'let'
          compile_let
        when 'do'
          compile_do
        when 'return'
          compile_return
        when 'if'
          compile_if
        when 'while'
          compile_while
        else
          break
        end
      end
    end
  end

  def compile_while
    b.whileStatement do
      consume(Tokenizer::KEYWORD, 'while')

      consume(Tokenizer::SYMBOL, '(')

      compile_expression

      consume(Tokenizer::SYMBOL, ')')

      consume(Tokenizer::SYMBOL, '{')

      compile_statements

      consume(Tokenizer::SYMBOL, '}')
    end
  end

  def compile_var_dec
    b.varDec do
      consume(Tokenizer::KEYWORD, 'var')

      case current_type
      when Tokenizer::KEYWORD
        if %w[int char boolean].include? current_token
          consume(Tokenizer::KEYWORD)
        end
      else
        consume(Tokenizer::IDENTIFIER)
      end

      consume(Tokenizer::IDENTIFIER)

      consume(Tokenizer::SYMBOL, ';')
    end
  end

  def compile_let
    b.letStatement do
      consume(Tokenizer::KEYWORD, 'let')

      consume(Tokenizer::IDENTIFIER)

      consume(Tokenizer::SYMBOL, '=')

      compile_expression

      consume(Tokenizer::SYMBOL, ';')
    end
  end

  def compile_do
    b.doStatement do
      consume(Tokenizer::KEYWORD, 'do')

      consume(Tokenizer::IDENTIFIER)

      if current_token == '.'
        consume(Tokenizer::SYMBOL, '.')

        consume(Tokenizer::IDENTIFIER)
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

      compile_expression unless current_token == ';'

      consume(Tokenizer::SYMBOL, ';')
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
      until current_token == ')'
        compile_expression

        if current_token == ','
          consume(Tokenizer::SYMBOL, ',')
        end
      end
    end
  end

  def compile_expression
    b.expression do
      compile_term

      if %w[+ < & > - ~ =].include? current_token
        consume(Tokenizer::SYMBOL)
        compile_term
      end
    end
  end

  def compile_term
    b.term do
      case current_type
      when Tokenizer::KEYWORD
        consume(Tokenizer::KEYWORD)
      when Tokenizer::SYMBOL
        if current_token == '('
          consume(Tokenizer::SYMBOL, '(')
          compile_expression
          consume(Tokenizer::SYMBOL, ')')
        elsif %w[- ~].include? current_token
          # unary op
          consume(Tokenizer::SYMBOL)
          compile_term
        end
      when Tokenizer::INT_CONST
        consume(Tokenizer::INT_CONST)
      else
        consume(Tokenizer::IDENTIFIER)

        # Possible subroutine calls
        if current_token == '.'
          consume(Tokenizer::SYMBOL, '.')

          consume(Tokenizer::IDENTIFIER)
        end

        if current_token == '('
          consume(Tokenizer::SYMBOL, '(')

          compile_expression_list

          consume(Tokenizer::SYMBOL, ')')
        end
      end
    end
  end

  private

  def consume(expected_type, expected_token = nil)
    unless current_type == expected_type && current_token == (expected_token || current_token)
      if expected_token
        raise "expected a #{expected_type} `#{expected_token}`, got #{current_type} `#{current_token}`"
      else
        raise "expected any #{expected_type}, got #{current_type} `#{current_token}`"
      end
    end

    b.tag!(current_type, current_token)

    input.advance if input.has_more_tokens?
  end

  def b
    @builder
  end

  def current_type
    input.token_type
  end

  def current_token
    case current_type
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
  end
end
