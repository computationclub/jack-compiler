require 'tokenizer'
require 'expression_parser'
require 'symbol_table'

RSpec.describe ExpressionParser do
  let(:output) { StringIO.new }
  let(:vm_writer) { VMWriter.new(output) }
  let(:symbol_table) { SymbolTable.new }

  def build_tokenizer(input_expression)
    Tokenizer.new(input_expression).tap { |t| t.advance }
  end

  it 'emits VM code for numeric constants' do
    tokenizer = build_tokenizer('1')

    result = ExpressionParser.new(tokenizer).parse
    result.emit(vm_writer, SymbolTable.new)

    expect(output.string).to eq("push constant 1\n")
  end

  it 'emits VM code for different numeric constants' do
    tokenizer = build_tokenizer('2')

    result = ExpressionParser.new(tokenizer).parse
    result.emit(vm_writer, SymbolTable.new)

    expect(output.string).to eq("push constant 2\n")
  end

  it 'emits VM code for variables' do
    tokenizer = build_tokenizer('a')
    symbol_table.define('a', :int, :static)

    result = ExpressionParser.new(tokenizer).parse
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq("push static 0\n")
  end

  it 'emits VM code for binary expressions' do
    tokenizer = build_tokenizer('1 + 1')

    result = ExpressionParser.new(tokenizer).parse
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 1
push constant 1
add
    VM
  end

  it 'emits VM code for compound binary expressions' do
    tokenizer = build_tokenizer('1 + 2 + 3')

    result = ExpressionParser.new(tokenizer).parse
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
    tokenizer = build_tokenizer('(1 + 2) + 3')

    result = ExpressionParser.new(tokenizer).parse
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
    tokenizer = build_tokenizer('~a')
    symbol_table.define('a', :int, :static)

    result = ExpressionParser.new(tokenizer).parse
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push static 0
not
    VM
  end

  it 'emits VM code for keywords' do
    tokenizer = build_tokenizer('true')

    result = ExpressionParser.new(tokenizer).parse
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 1
neg
    VM
  end

  it 'emits VM code for multiplication' do
    tokenizer = build_tokenizer('1 * 2')

    result = ExpressionParser.new(tokenizer).parse
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 1
push constant 2
call Math.multiply 2
    VM
  end

  it 'emits VM code for division' do
    tokenizer = build_tokenizer('3 / 4')

    result = ExpressionParser.new(tokenizer).parse
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 3
push constant 4
call Math.divide 2
    VM
  end

  it 'emits VM code for calling external methods witn no arguments' do
    tokenizer = build_tokenizer('Sys.halt()')

    result = ExpressionParser.new(tokenizer).parse
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
call Sys.halt 0
    VM
  end

  it 'emits VM code for calling external methods with a single argument' do
    tokenizer = build_tokenizer('Output.printInt(4)')

    result = ExpressionParser.new(tokenizer).parse
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 4
call Output.printInt 1
    VM
  end

  it 'emits VM code for calling external methods with multiple arguments' do
    tokenizer = build_tokenizer('Screen.drawPixel(4, 5)')

    result = ExpressionParser.new(tokenizer).parse
    result.emit(vm_writer, symbol_table)

    expect(output.string).to eq(<<-VM)
push constant 4
push constant 5
call Screen.drawPixel 2
    VM
  end

  it 'emits VM code for calling external methods with complex expression-based arguments' do
    tokenizer = build_tokenizer('Math.min((1*2), Memory.peek(array_start + 5))')
    symbol_table.define('array_start', :int, :static)

    result = ExpressionParser.new(tokenizer).parse
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
