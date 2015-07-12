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

  it 'emits VM code for binary expressions' do
    tokenizer = Tokenizer.new('1 + 1')
    tokenizer.advance

    symbol_table = SymbolTable.new

    result = ExpressionParser.new(tokenizer).parse
    output = StringIO.new
    vm_writer = VMWriter.new(output)
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 1
push constant 1
add
    VM
  end

  it 'emits VM code for compound binary expressions' do
    tokenizer = Tokenizer.new('1 + 2 + 3')
    tokenizer.advance

    symbol_table = SymbolTable.new

    result = ExpressionParser.new(tokenizer).parse
    output = StringIO.new
    vm_writer = VMWriter.new(output)
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 1
push constant 2
push constant 3
add
add
    VM
  end

  it 'emits VM code for compound binary expressions with parentheses' do
    tokenizer = Tokenizer.new('(1 + 2) + 3')
    tokenizer.advance

    symbol_table = SymbolTable.new

    result = ExpressionParser.new(tokenizer).parse
    output = StringIO.new
    vm_writer = VMWriter.new(output)
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 1
push constant 2
add
push constant 3
add
    VM
  end

  it 'emits VM code for unary operations' do
    tokenizer = Tokenizer.new('~a')
    tokenizer.advance

    symbol_table = SymbolTable.new
    symbol_table.define('a', :int, :static)

    result = ExpressionParser.new(tokenizer).parse
    output = StringIO.new
    vm_writer = VMWriter.new(output)
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push static 0
not
    VM
  end

  it 'emits VM code for keywords' do
    tokenizer = Tokenizer.new('true')
    tokenizer.advance

    symbol_table = SymbolTable.new

    result = ExpressionParser.new(tokenizer).parse
    output = StringIO.new
    vm_writer = VMWriter.new(output)
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 1
neg
    VM
  end

  it 'emits VM code for multiplication' do
    tokenizer = Tokenizer.new('1 * 2')
    tokenizer.advance

    symbol_table = SymbolTable.new

    result = ExpressionParser.new(tokenizer).parse
    output = StringIO.new
    vm_writer = VMWriter.new(output)
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 1
push constant 2
call Math.multiply 2
    VM
  end

  it 'emits VM code for division' do
    tokenizer = Tokenizer.new('3 / 4')
    tokenizer.advance

    symbol_table = SymbolTable.new

    result = ExpressionParser.new(tokenizer).parse
    output = StringIO.new
    vm_writer = VMWriter.new(output)
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 3
push constant 4
call Math.divide 2
    VM
  end

  it 'emits VM code for calling external methods witn no arguments' do
    tokenizer = Tokenizer.new('Sys.halt()')
    tokenizer.advance

    symbol_table = SymbolTable.new

    result = ExpressionParser.new(tokenizer).parse
    output = StringIO.new
    vm_writer = VMWriter.new(output)
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
call Sys.halt 0
    VM
  end

  it 'emits VM code for calling external methods with a single argument' do
    tokenizer = Tokenizer.new('Output.printInt(4)')
    tokenizer.advance

    symbol_table = SymbolTable.new

    result = ExpressionParser.new(tokenizer).parse
    output = StringIO.new
    vm_writer = VMWriter.new(output)
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 4
call Output.printInt 1
    VM
  end

  it 'emits VM code for calling external methods with multiple arguments' do
    tokenizer = Tokenizer.new('Screen.drawPixel(4, 5)')
    tokenizer.advance

    symbol_table = SymbolTable.new

    result = ExpressionParser.new(tokenizer).parse
    output = StringIO.new
    vm_writer = VMWriter.new(output)
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 4
push constant 5
call Screen.drawPixel 2
    VM
  end

  it 'emits VM code for calling external methods with complex expression-based arguments' do
    tokenizer = Tokenizer.new('Math.min((1*2), Memory.peek(array_start + 5))')
    tokenizer.advance

    symbol_table = SymbolTable.new
    symbol_table.define('array_start', :int, :static)

    result = ExpressionParser.new(tokenizer).parse
    output = StringIO.new
    vm_writer = VMWriter.new(output)
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 1
push constant 2
call Math.multiply 2
push static 0
push constant 5
add
call Memory.peek 1
call Math.min 2
    VM
  end

end
