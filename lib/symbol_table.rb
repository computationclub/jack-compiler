class SymbolTable
  class SymbolNotFound < StandardError; end

  Symbol = Struct.new(:name, :type, :kind, :index)

  NULL_SYMBOL = Symbol.new("<NULL>", "BAD", :none, -1)

  def initialize
    @symbols = Hash.new(NULL_SYMBOL)
  end

  def define(name, type, kind)
    index = var_count(kind)
    @symbols[name] = Symbol.new(name, type, kind, index)
  end

  def var_count(kind)
    @symbols.select { |_, v| v.kind == kind }.count
  end

  def kind_of(name)
    @symbols[name].kind
  end

  def type_of(name)
    symbol = @symbols.fetch(name) do
      raise SymbolNotFound, "symbol not found: #{name}"
    end
    symbol.type
  end

  def index_of(name)
    @symbols[name].index
  end
end
