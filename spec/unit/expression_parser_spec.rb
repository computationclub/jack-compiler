require 'expression_parser'
require 'symbol_table'
require 'compilation_engine'
require_relative '../be_parsed_into_matcher'

RSpec.describe ExpressionParser do
  include BeParsedInto

  let(:symbol_table) { SymbolTable.new }
  let(:jack_class) { CompilationEngine::JackClass.new('FunTimes', 1) }

  context '#parse_expression' do
    it 'emits VM code for numeric constants' do
      expect(
        '1'
      ).to be_parsed_into(
        "push constant 1\n"
      ).when_parsed_as :expression
    end

    it 'emits VM code for different numeric constants' do
      expect(
        '2'
      ).to be_parsed_into(
        "push constant 2\n"
      ).when_parsed_as :expression
    end

    it 'emits VM code for empty strings by emitting a string constructor' do
      expect(
        '""'
      ).to be_parsed_into(
        <<-VM
push constant 0
call String.new 1
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for filled strings by emitting a string constructor and appending each char' do
      expect(
        '"hello!"'
      ).to be_parsed_into(
        <<-VM
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
      ).when_parsed_as :expression
    end

    it 'emits VM code for strings with unicode characters as single numbers per character' do
      expect(
        '"héllo→"'
      ).to be_parsed_into(
        <<-VM
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
      ).when_parsed_as :expression
    end

    it 'emits VM code for variables' do
      symbol_table.define('a', :int, :static)

      expect(
        'a'
      ).to be_parsed_into(
        "push static 0\n"
      ).when_parsed_as :expression
    end

    it 'emits VM code for array references' do
      symbol_table.define('a', :int, :static)

      expect(
        'a[1]'
      ).to be_parsed_into(
        <<-VM
push constant 1
push static 0
add
pop pointer 1
push that 0
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for array references in expressions' do
      symbol_table.define('a', :int, :static)

      expect(
        'a[1] + 2'
      ).to be_parsed_into(
        <<-VM
push constant 1
push static 0
add
pop pointer 1
push that 0
push constant 2
add
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for binary expressions' do
      expect(
        '1 + 1'
      ).to be_parsed_into(
        <<-VM
push constant 1
push constant 1
add
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for compound binary expressions' do
      expect(
        '1 + 2 - 3'
      ).to be_parsed_into(
        <<-VM
push constant 1
push constant 2
push constant 3
sub
add
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for compound binary expressions with parentheses' do
      expect(
        '(1 + 2) - 3'
      ).to be_parsed_into(
        <<-VM
push constant 1
push constant 2
add
push constant 3
sub
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for unary not operations' do
      symbol_table.define('a', :int, :static)

      expect(
        '~a'
      ).to be_parsed_into(
        <<-VM
push static 0
not
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for unary negation operations' do
      symbol_table.define('a', :int, :static)

      expect(
        '-1'
      ).to be_parsed_into(
        <<-VM
push constant 1
neg
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for `true`' do
      expect(
        'true'
      ).to be_parsed_into(
        <<-VM
push constant 0
not
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for `false`' do
      expect(
        'false'
      ).to be_parsed_into(
        <<-VM
push constant 0
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for `this`' do
      expect(
        'this'
      ).to be_parsed_into(
        <<-VM
push pointer 0
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for bitwise and' do
      expect(
        '1 & 2'
      ).to be_parsed_into(
        <<-VM
push constant 1
push constant 2
and
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for bitwise or' do
      expect(
        '3 | 4'
      ).to be_parsed_into(
        <<-VM
push constant 3
push constant 4
or
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for equality comparison' do
      expect(
        '1 = 2'
      ).to be_parsed_into(
        <<-VM
push constant 1
push constant 2
eq
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for greater than comparison' do
      expect(
        '3 > 4'
      ).to be_parsed_into(
        <<-VM
push constant 3
push constant 4
gt
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for less than comparison' do
      expect(
        '5 < 6'
      ).to be_parsed_into(
        <<-VM
push constant 5
push constant 6
lt
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for multiplication' do
      expect(
        '1 * 2'
      ).to be_parsed_into(
        <<-VM
push constant 1
push constant 2
call Math.multiply 2
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for division' do
      expect(
        '3 / 4'
      ).to be_parsed_into(
        <<-VM
push constant 3
push constant 4
call Math.divide 2
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for calling external methods witn no arguments' do
      expect(
        'Sys.halt()'
      ).to be_parsed_into(
        "call Sys.halt 0\n"
      ).when_parsed_as :expression
    end

    it 'emits VM code for calling external methods with a single argument' do
      expect(
        'Output.printInt(4)'
      ).to be_parsed_into(
        <<-VM
push constant 4
call Output.printInt 1
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for calling external methods with unary operations' do
      expect(
        'Screen.drawPixel(-4, -5)'
      ).to be_parsed_into(
        <<-VM
push constant 4
neg
push constant 5
neg
call Screen.drawPixel 2
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for calling external methods with array references' do
      symbol_table.define('point', 'Array', :var)

      expect(
        'Screen.drawPixel(point[0], point[1])'
      ).to be_parsed_into(
        <<-VM
push constant 0
push local 0
add
pop pointer 1
push that 0
push constant 1
push local 0
add
pop pointer 1
push that 0
call Screen.drawPixel 2
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for calling external methods with multiple arguments' do
      expect(
        'Screen.drawPixel(4, 5)'
      ).to be_parsed_into(
        <<-VM
push constant 4
push constant 5
call Screen.drawPixel 2
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for calling external methods with complex expression-based arguments' do
      symbol_table.define('array_start', :int, :static)

      expect(
        'Math.min((1*2), Memory.peek(array_start + 5))'
      ).to be_parsed_into(
        <<-VM
push constant 1
push constant 2
call Math.multiply 2
push static 0
push constant 5
add
call Memory.peek 1
call Math.min 2
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for calling nullary methods on variables defined in symbol table' do
      symbol_table.define('game', 'SquareGame', :var)

      expect(
        'game.run()'
      ).to be_parsed_into(
        <<-VM
push local 0
call SquareGame.run 1
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for calling methods with arguments on variables defined in symbol table' do
      symbol_table.define('game', 'SquareGame', :var)
      symbol_table.define('x', :int, :arg)
      symbol_table.define('y', :int, :arg)

      expect(
        'game.run(1, x, y)'
      ).to be_parsed_into(
        <<-VM
push local 0
push constant 1
push argument 0
push argument 1
call SquareGame.run 4
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for calling internal methods witn no arguments' do
      expect(
        'woah()'
      ).to be_parsed_into(
        <<-VM
push pointer 0
call FunTimes.woah 1
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for calling internal methods with a single argument' do
      expect(
        'woah(4)'
      ).to be_parsed_into(
        <<-VM
push pointer 0
push constant 4
call FunTimes.woah 2
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for calling internal methods with unary operations' do
      expect(
        'woah(-4, -5)'
      ).to be_parsed_into(
        <<-VM
push pointer 0
push constant 4
neg
push constant 5
neg
call FunTimes.woah 3
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for calling internal methods with array references' do
      symbol_table.define('exclamation', 'Array', :var)

      expect(
        'woah(exclamation[0], exclamation[1])'
      ).to be_parsed_into(
        <<-VM
push pointer 0
push constant 0
push local 0
add
pop pointer 1
push that 0
push constant 1
push local 0
add
pop pointer 1
push that 0
call FunTimes.woah 3
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for calling internal methods with multiple arguments' do
      expect(
        'woah(4, 5)'
      ).to be_parsed_into(
        <<-VM
push pointer 0
push constant 4
push constant 5
call FunTimes.woah 3
        VM
      ).when_parsed_as :expression
    end

    it 'emits VM code for calling internal methods with complex expression-based arguments' do
      symbol_table.define('array_start', :int, :static)

      expect(
        'woah((1*2), Memory.peek(array_start + 5))'
      ).to be_parsed_into(
        <<-VM
push pointer 0
push constant 1
push constant 2
call Math.multiply 2
push static 0
push constant 5
add
call Memory.peek 1
call FunTimes.woah 3
        VM
      ).when_parsed_as :expression
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
      expect(
        'Sys.halt()'
      ).to be_parsed_into(
        "call Sys.halt 0\n"
      ).when_parsed_as :subroutine_call
    end

    it 'emits VM code for calling external methods with a single argument' do
      expect(
        'Output.printInt(4)'
      ).to be_parsed_into(
        <<-VM
push constant 4
call Output.printInt 1
        VM
      ).when_parsed_as :subroutine_call
    end

    it 'emits VM code for calling external methods with unary operations' do
      expect(
        'Screen.drawPixel(-4, -5)'
      ).to be_parsed_into(
        <<-VM
push constant 4
neg
push constant 5
neg
call Screen.drawPixel 2
        VM
      ).when_parsed_as :subroutine_call
    end

    it 'emits VM code for calling external methods with array references' do
      symbol_table.define('point', 'Array', :var)

      expect(
        'Screen.drawPixel(point[0], point[1])'
      ).to be_parsed_into(
        <<-VM
push constant 0
push local 0
add
pop pointer 1
push that 0
push constant 1
push local 0
add
pop pointer 1
push that 0
call Screen.drawPixel 2
        VM
      ).when_parsed_as :subroutine_call
    end

    it 'emits VM code for calling external methods with multiple arguments' do
      expect(
        'Screen.drawPixel(4, 5)'
      ).to be_parsed_into(
        <<-VM
push constant 4
push constant 5
call Screen.drawPixel 2
        VM
      ).when_parsed_as :subroutine_call
    end

    it 'emits VM code for calling external methods with complex expression-based arguments' do
      symbol_table.define('array_start', :int, :static)

      expect(
        'Math.min((1*2), Memory.peek(array_start + 5))'
      ).to be_parsed_into(
        <<-VM
push constant 1
push constant 2
call Math.multiply 2
push static 0
push constant 5
add
call Memory.peek 1
call Math.min 2
        VM
      ).when_parsed_as :subroutine_call
    end

    it 'emits VM code for calling nullary methods on variables defined in symbol table' do
      symbol_table.define('game', 'SquareGame', :var)

      expect(
        'game.run()'
      ).to be_parsed_into(
        <<-VM
push local 0
call SquareGame.run 1
        VM
      ).when_parsed_as :subroutine_call
    end

    it 'emits VM code for calling methods with arguments on variables defined in symbol table' do
      symbol_table.define('game', 'SquareGame', :var)
      symbol_table.define('x', :int, :arg)
      symbol_table.define('y', :int, :arg)

      expect(
        'game.run(1, x, y)'
      ).to be_parsed_into(
        <<-VM
push local 0
push constant 1
push argument 0
push argument 1
call SquareGame.run 4
        VM
      ).when_parsed_as :subroutine_call
    end

    it 'emits VM code for calling internal methods witn no arguments' do
      expect(
        'woah()'
      ).to be_parsed_into(
        <<-VM
push pointer 0
call FunTimes.woah 1
        VM
      ).when_parsed_as :subroutine_call
    end

    it 'emits VM code for calling internal methods with a single argument' do
      expect(
        'woah(4)'
      ).to be_parsed_into(
        <<-VM
push pointer 0
push constant 4
call FunTimes.woah 2
        VM
      ).when_parsed_as :subroutine_call
    end

    it 'emits VM code for calling internal methods with unary operations' do
      expect(
        'woah(-4, -5)'
      ).to be_parsed_into(
        <<-VM
push pointer 0
push constant 4
neg
push constant 5
neg
call FunTimes.woah 3
        VM
      ).when_parsed_as :subroutine_call
    end

    it 'emits VM code for calling internal methods with array references' do
      symbol_table.define('exclamation', 'Array', :var)

      expect(
        'woah(exclamation[0], exclamation[1])'
      ).to be_parsed_into(
        <<-VM
push pointer 0
push constant 0
push local 0
add
pop pointer 1
push that 0
push constant 1
push local 0
add
pop pointer 1
push that 0
call FunTimes.woah 3
        VM
      ).when_parsed_as :subroutine_call
    end

    it 'emits VM code for calling internal methods with multiple arguments' do
      expect(
        'woah(4, 5)'
      ).to be_parsed_into(
        <<-VM
push pointer 0
push constant 4
push constant 5
call FunTimes.woah 3
        VM
      ).when_parsed_as :subroutine_call
    end

    it 'emits VM code for calling internal methods with complex expression-based arguments' do
      symbol_table.define('array_start', :int, :static)

      expect(
        'woah((1*2), Memory.peek(array_start + 5))'
      ).to be_parsed_into(
        <<-VM
push pointer 0
push constant 1
push constant 2
call Math.multiply 2
push static 0
push constant 5
add
call Memory.peek 1
call FunTimes.woah 3
        VM
      ).when_parsed_as :subroutine_call
    end
  end
end
