require 'builder'
require_relative 'symbol_table'

class Parser
  attr_reader :input

  def initialize(input, output)
    @input = input
    @builder = Builder::XmlMarkup.new(target: output, indent: 2)
  end

  def compile_class
    @symbols = SymbolTable.new

    b.tag!(:class) do
      # Get the ball moving!
      input.advance

      consume(Tokenizer::KEYWORD, 'class')

      consume(Tokenizer::IDENTIFIER)

      consume_wrapped('{') do
        while %w[field static].include? current_token
          compile_class_var_dec
        end

        while %w[constructor function method].include? current_token
          compile_subroutine
        end
      end
    end
  end

  def compile_class_var_dec
    b.classVarDec do
      kind = current_token # field, static, etc.
      consume(Tokenizer::KEYWORD)

      type = current_token # int, char, etc.
      consume_type

      consume_separated(',') do
        name = current_token
        @symbols.define(name, type, kind)
        consume_identifier(name)
      end

      consume(Tokenizer::SYMBOL, ';')
    end
  end

  def compile_subroutine
    @symbols.start_subroutine

    b.subroutineDec do
      consume(Tokenizer::KEYWORD)

      try_consume(Tokenizer::KEYWORD, 'void') || consume_type

      consume(Tokenizer::IDENTIFIER)

      consume_wrapped('(') do
        compile_parameter_list
      end

      compile_subroutine_body
    end
  end

  def compile_parameter_list
    b.parameterList do
      return if current_token == ')'

      consume_separated(',') do
        kind = :arg

        type = current_token # int, char, etc.
        consume_type

        name = current_token
        @symbols.define(name, type, kind)
        consume_identifier(name)
      end
    end
  end

  def compile_subroutine_body
    b.subroutineBody do
      consume_wrapped('{') do
        while current_token == "var"
          compile_var_dec
        end

        compile_statements
      end
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

      consume_wrapped('(') do
        compile_expression
      end

      consume_wrapped('{') do
        compile_statements
      end
    end
  end

  def compile_var_dec
    b.varDec do
      consume(Tokenizer::KEYWORD, 'var')

      kind = :var

      type = current_token
      consume_type

      consume_separated(',') do
        name = current_token
        @symbols.define(name, type, kind)
        consume_identifier(name)
      end

      consume(Tokenizer::SYMBOL, ';')
    end
  end

  def compile_let
    b.letStatement do
      consume(Tokenizer::KEYWORD, 'let')

      consume_identifier

      try_consume_wrapped('[') do
        compile_expression
      end

      consume(Tokenizer::SYMBOL, '=')

      compile_expression

      consume(Tokenizer::SYMBOL, ';')
    end
  end

  def compile_do
    b.doStatement do
      consume(Tokenizer::KEYWORD, 'do')

      consume_subroutine_call

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

      consume_wrapped('(') do
        compile_expression
      end

      consume_wrapped('{') do
        compile_statements
      end

      if try_consume(Tokenizer::KEYWORD, 'else')
        consume_wrapped('{') do
          compile_statements
        end
      end
    end
  end

  def compile_expression_list
    b.expressionList do
      return if  current_token == ')'

      consume_separated(',') do
        compile_expression
      end
    end
  end

  def compile_expression
    b.expression do
      compile_term

      while %w[+ - * / & | < > =].include? current_token
        consume(Tokenizer::SYMBOL)
        compile_term
      end
    end
  end

  def compile_term
    b.term do
      return if try_consume(Tokenizer::INT_CONST) ||
                try_consume(Tokenizer::STRING_CONST) ||
                try_consume_wrapped('(') { compile_expression }

      case current_token
      when 'true', 'false', 'null', 'this' #keywordConst
        consume(Tokenizer::KEYWORD)
      when '-', '~' # unary op
        consume(Tokenizer::SYMBOL)
        compile_term
      else
        name = current_token
        input.advance

        case current_token
        when '['
          b.identifier(
            name,
            type: @symbols.type_of(name),
            kind: @symbols.kind_of(name),
            index: @symbols.index_of(name)
          )

          consume_wrapped('[') do
            compile_expression
          end
        when '.', '('
          b.identifier(name)
          consume_subroutine_call(skip_identifier: true)
        else
          b.identifier(
            name,
            type: @symbols.type_of(name),
            kind: @symbols.kind_of(name),
            index: @symbols.index_of(name)
          )
        end
      end
    end
  end

  private

  def consume(expected_type, expected_token = nil)
    unless try_consume(expected_type, expected_token)
      if expected_token
        raise "expected a #{expected_type} `#{expected_token}`, got #{current_type} `#{current_token}`"
      else
        raise "expected any #{expected_type}, got #{current_type} `#{current_token}`"
      end
    end
  end

  def try_consume(expected_type, expected_token = nil)
    return false unless current_type == expected_type &&
                        current_token == (expected_token || current_token)

    b.tag!(current_type, current_token)

    input.advance if input.has_more_tokens?
    true
  end

  def consume_identifier(name = current_token)
    b.identifier(
      name,
      type: @symbols.type_of(name),
      kind: @symbols.kind_of(name),
      index: @symbols.index_of(name)
    )

    input.advance if input.has_more_tokens?
  end

  def consume_wrapped(opening, &block)
    unless try_consume_wrapped(opening) { block.call }
      raise "expected wrapping `#{opening}`, got #{current_type}, `#{current_token}`"
    end
  end

  def try_consume_wrapped(opening)
    closing = case opening
    when '(' then ')'
    when '[' then ']'
    when '{' then '}'
    else raise "Unknown opening brace: `#{opening}`"
    end

    if try_consume(Tokenizer::SYMBOL, opening)
      yield
      consume(Tokenizer::SYMBOL, closing)
      true
    end
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

  def consume_separated(sep)
    begin
      yield
    end while try_consume(Tokenizer::SYMBOL, sep)
  end

  def consume_type
    case current_type
    when Tokenizer::KEYWORD
      if %w[int char boolean].include? current_token
        consume(Tokenizer::KEYWORD)
      end
    else
      consume(Tokenizer::IDENTIFIER)
    end
  end

  def consume_subroutine_call(skip_identifier: false)
    consume(Tokenizer::IDENTIFIER) unless skip_identifier

    if try_consume(Tokenizer::SYMBOL, '.')
      consume(Tokenizer::IDENTIFIER)
    end

    consume_wrapped('(') do
      compile_expression_list
    end
  end
end
