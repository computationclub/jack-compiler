require 'tokenizer'
require 'expression_parser'
require 'symbol_table'

RSpec.describe ExpressionParser do
  it 'emits VM code for numeric constants' do
    tokenizer = Tokenizer.new('1')
    tokenizer.advance

    result = ExpressionParser.new(tokenizer).parse
    output = StringIO.new
    vm_writer = VMWriter.new(output)
    result.emit(vm_writer, SymbolTable.new)

    expect(output.string).to eq("push constant 1\n")
  end

  it 'emits VM code for different numeric constants' do
    tokenizer = Tokenizer.new('2')
    tokenizer.advance

    result = ExpressionParser.new(tokenizer).parse
    output = StringIO.new
    vm_writer = VMWriter.new(output)
    result.emit(vm_writer, SymbolTable.new)

    expect(output.string).to eq("push constant 2\n")
  end

  it 'emits VM code for variables' do
    tokenizer = Tokenizer.new('a')
    tokenizer.advance

    symbol_table = SymbolTable.new
    symbol_table.define('a', :int, :static)

    result = ExpressionParser.new(tokenizer).parse
    output = StringIO.new
    vm_writer = VMWriter.new(output)
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq("push static 0\n")
  end
end
