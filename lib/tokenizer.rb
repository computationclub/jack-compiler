class Tokenizer
  KEYWORD, SYMBOL, IDENTIFIER,
  INT_CONST, STRING_CONST = 5.times.map { Object.new }

  ALL_KEYWORDS = %w[
    class method function constructor
    int boolean char void var
    static field let do if
    else while return true false
    null this
  ]

  def initialize(input)
    @input = input
  end

  def has_more_tokens?
    !input.strip.empty?
  end

  def advance
    case input
    # Leading whitespace
    when %r{\A\s+}
      input.sub!(%r{\A\s+}, '')
      advance
    # //-type comment
    when %r{\A//.*$}
      input.sub!(%r{\A//.*$}, '')
      advance
    # /*-type comment
    when %r{\A/\*.*?\*/}m
      input.sub!(%r{\A/\*.*?\*/}m, '')
      advance
    when %r{\A".*?"}
      next_word = input[%r{\A"(.*?)"}, 1]
      input.sub!("\"#{next_word}\"", '')
      self.token_type = STRING_CONST
      self.string_val = next_word
    else
      next_word = input[%r{(\w+|[()\[\]{}.,;=<>&*/+~-])}]
      input.sub!(next_word, '')

      case next_word
      when *ALL_KEYWORDS
        self.token_type = KEYWORD
        self.keyword = next_word
      when '(', ')', '[', ']', '{', '}', '.', ',', ';', '=', '<', '>', '&', '*', '/', '+', '-', '~'
        self.token_type = SYMBOL
        self.symbol = next_word
      when /\d+/
        self.token_type = INT_CONST
        self.int_val = next_word
      else
        self.token_type = IDENTIFIER
        self.identifier = next_word
      end
    end
  end

  attr_reader :input, :token_type, :keyword,
              :identifier, :symbol, :string_val, :int_val

  private

  attr_writer :token_type, :keyword, :identifier,
              :symbol, :string_val, :int_val
end
