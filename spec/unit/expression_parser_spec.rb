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

  context '#parse_expression' do
    it 'emits VM code for numeric constants' do
      tokenizer = build_tokenizer('1')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, SymbolTable.new)

      expect(output.string).to eq("push constant 1\n")
    end

    it 'emits VM code for different numeric constants' do
      tokenizer = build_tokenizer('2')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, SymbolTable.new)

      expect(output.string).to eq("push constant 2\n")
    end

    it 'emits VM code for empty strings by emitting a string constructor' do
      tokenizer = build_tokenizer('""')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, SymbolTable.new)

      expect(output.string).to eq(<<-VM)
push constant 0
call String.new 1
      VM
    end

    it 'emits VM code for filled strings by emitting a string constructor and appending each char' do
      tokenizer = build_tokenizer('"hello!"')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, SymbolTable.new)

      expect(output.string).to eq(<<-VM)
push constant 6
call String.new 1
push constant 104
call String.appendChar 2
push constant 101
call String.appendChar 2
push constant 108
call String.appendChar 2
push constant 108
call String.appendChar 2
push constant 111
call String.appendChar 2
push constant 33
call String.appendChar 2
      VM
    end

    it 'emits VM code for strings with unicode characters as single numbers per character' do
      tokenizer = build_tokenizer('"héllo→"')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, SymbolTable.new)

      expect(output.string).to eq(<<-VM)
push constant 6
call String.new 1
push constant 104
call String.appendChar 2
push constant 233
call String.appendChar 2
push constant 108
call String.appendChar 2
push constant 108
call String.appendChar 2
push constant 111
call String.appendChar 2
push constant 8594
call String.appendChar 2
      VM
    end

    it 'emits VM code for variables' do
      tokenizer = build_tokenizer('a')
      symbol_table.define('a', :int, :static)

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq("push static 0\n")
    end

    it 'emits VM code for binary expressions' do
      tokenizer = build_tokenizer('1 + 1')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 1
push constant 1
add
      VM
    end

    it 'emits VM code for compound binary expressions' do
      tokenizer = build_tokenizer('1 + 2 - 3')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 1
push constant 2
push constant 3
sub
add
      VM
    end

    it 'emits VM code for compound binary expressions with parentheses' do
      tokenizer = build_tokenizer('(1 + 2) - 3')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 1
push constant 2
add
push constant 3
sub
      VM
    end

    it 'emits VM code for unary not operations' do
      tokenizer = build_tokenizer('~a')
      symbol_table.define('a', :int, :static)

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push static 0
not
      VM
    end

    it 'emits VM code for unary negation operations' do
      tokenizer = build_tokenizer('-1')
      symbol_table.define('a', :int, :static)

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 1
neg
      VM
    end

    it 'emits VM code for `true`' do
      tokenizer = build_tokenizer('true')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 0
not
      VM
    end

    it 'emits VM code for `false`' do
      tokenizer = build_tokenizer('false')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 0
      VM
    end

    it 'emits VM code for bitwise and' do
      tokenizer = build_tokenizer('1 & 2')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 1
push constant 2
and
      VM
    end

    it 'emits VM code for bitwise or' do
      tokenizer = build_tokenizer('3 | 4')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 3
push constant 4
or
      VM
    end

    it 'emits VM code for equality comparison' do
      tokenizer = build_tokenizer('1 = 2')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 1
push constant 2
eq
      VM
    end

    it 'emits VM code for greater than comparison' do
      tokenizer = build_tokenizer('3 > 4')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 3
push constant 4
gt
      VM
    end

    it 'emits VM code for less than comparison' do
      tokenizer = build_tokenizer('5 < 6')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 5
push constant 6
lt
      VM
    end

    it 'emits VM code for multiplication' do
      tokenizer = build_tokenizer('1 * 2')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 1
push constant 2
call Math.multiply 2
      VM
    end

    it 'emits VM code for division' do
      tokenizer = build_tokenizer('3 / 4')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 3
push constant 4
call Math.divide 2
      VM
    end

    it 'emits VM code for calling external methods witn no arguments' do
      tokenizer = build_tokenizer('Sys.halt()')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
call Sys.halt 0
      VM
    end

    it 'emits VM code for calling external methods with a single argument' do
      tokenizer = build_tokenizer('Output.printInt(4)')

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 4
call Output.printInt 1
      VM
    end

    it 'emits VM code for calling external methods with multiple arguments' do
      tokenizer = build_tokenizer('Screen.drawPixel(4, 5)')

      result = ExpressionParser.new(tokenizer).parse_expression
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

      result = ExpressionParser.new(tokenizer).parse_expression
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

    it 'emits VM code for calling nullary methods on variables defined in symbol table' do
      tokenizer = build_tokenizer('game.run()')
      symbol_table.define('game', 'SquareGame', :var)

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push local 0
call SquareGame.run 1
      VM
    end

    it 'emits VM code for calling methods with arguments on variables defined in symbol table' do
      tokenizer = build_tokenizer('game.run(1, x, y)')
      symbol_table.define('game', 'SquareGame', :var)
      symbol_table.define('x', :int, :arg)
      symbol_table.define('y', :int, :arg)

      result = ExpressionParser.new(tokenizer).parse_expression
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push local 0
push constant 1
push argument 0
push argument 1
call SquareGame.run 4
      VM
    end
  end

  context 'parse_subroutine_call' do
    it 'breaks if given a simple expression that is not a function call' do
      expect { ExpressionParser.new(build_tokenizer('1')).parse_subroutine_call }.to raise_error
      expect { ExpressionParser.new(build_tokenizer('1 + 2')).parse_subroutine_call }.to raise_error
      expect { ExpressionParser.new(build_tokenizer('1.2')).parse_subroutine_call }.to raise_error
      expect { ExpressionParser.new(build_tokenizer('()')).parse_subroutine_call }.to raise_error
      expect { ExpressionParser.new(build_tokenizer('(call.me())')).parse_subroutine_call }.to raise_error
    end

    it 'emits VM code for calling external methods witn no arguments' do
      tokenizer = build_tokenizer('Sys.halt()')

      result = ExpressionParser.new(tokenizer).parse_subroutine_call
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
call Sys.halt 0
      VM
    end

    it 'emits VM code for calling external methods with a single argument' do
      tokenizer = build_tokenizer('Output.printInt(4)')

      result = ExpressionParser.new(tokenizer).parse_subroutine_call
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 4
call Output.printInt 1
      VM
    end

    it 'emits VM code for calling external methods with a single argument' do
      tokenizer = build_tokenizer('Output.printInt(4)')

      result = ExpressionParser.new(tokenizer).parse_subroutine_call
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 4
call Output.printInt 1
      VM
    end


    it 'emits VM code for calling external methods with unary operations' do
      tokenizer = build_tokenizer('Screen.drawPixel(-4, -5)')

      result = ExpressionParser.new(tokenizer).parse_subroutine_call
      result.emit(vm_writer, symbol_table)

      expect(output.string).to eq(<<-VM)
push constant 4
neg
push constant 5
neg
call Screen.drawPixel 2
      VM
    end

    it 'emits VM code for calling external methods with complex expression-based arguments' do
      tokenizer = build_tokenizer('Math.min((1*2), Memory.peek(array_start + 5))')
      symbol_table.define('array_start', :int, :static)

      result = ExpressionParser.new(tokenizer).parse_subroutine_call
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
end
