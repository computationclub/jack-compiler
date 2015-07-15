require 'compilation_engine'
require 'tokenizer'

RSpec.describe CompilationEngine do
  let(:output) { StringIO.new }
  subject(:compiled_vm_code) { output.string }

  it 'compiles the Seven program correctly' do
    tokenizer = Tokenizer.new(seven_jack_source)

    compilation_engine = CompilationEngine.new(tokenizer, output)
    compilation_engine.compile_class

    expect(compiled_vm_code).to eq(<<-VM)
function Main.main 0
push constant 1
push constant 2
push constant 3
call Math.multiply 2
add
call Output.printInt 1
pop temp 0
push constant 0
return
    VM
  end

  it 'compiles the ConvertToBin programm correctly' do
    tokenizer = Tokenizer.new(convert_to_bin_source)
    compilation_engine = CompilationEngine.new(tokenizer, output)
    compilation_engine.compile_class

    expect(compiled_vm_code).to eq(<<-VM)
function Main.main 2
push constant 8001
push constant 16
push constant 1
neg
call Main.fillMemory 3
pop temp 0
push constant 8000
call Memory.peek 1
pop local 1
push local 1
call Main.convert 1
pop temp 0
push constant 0
return
function Main.convert 3
push constant 0
not
pop local 2
label WHILE_EXP0
push local 2
not
if-goto WHILE_END0
push local 1
push constant 1
add
pop local 1
push local 0
call Main.nextMask 1
pop local 0
push constant 9000
push local 1
add
push local 0
call Memory.poke 2
pop temp 0
push local 1
push constant 16
gt
not
if-goto IF_TRUE0
goto IF_FALSE0
label IF_TRUE0
push argument 0
push local 0
and
push constant 0
eq
not
if-goto IF_TRUE1
goto IF_FALSE1
label IF_TRUE1
push constant 8000
push local 1
add
push constant 1
call Memory.poke 2
pop temp 0
goto IF_END1
label IF_FALSE1
push constant 8000
push local 1
add
push constant 0
call Memory.poke 2
pop temp 0
label IF_END1
goto IF_END0
label IF_FALSE0
push constant 0
pop local 2
label IF_END0
goto WHILE_EXP0
label WHILE_END0
push constant 0
return
function Main.nextMask 0
push argument 0
push constant 0
eq
if-goto IF_TRUE0
goto IF_FALSE0
label IF_TRUE0
push constant 1
return
goto IF_END0
label IF_FALSE0
push argument 0
push constant 2
call Math.multiply 2
return
label IF_END0
function Main.fillMemory 0
label WHILE_EXP0
push argument 1
push constant 0
gt
not
if-goto WHILE_END0
push argument 0
push argument 2
call Memory.poke 2
pop temp 0
push argument 1
push constant 1
sub
pop argument 1
push argument 0
push constant 1
add
pop argument 0
goto WHILE_EXP0
label WHILE_END0
push constant 0
return
    VM
  end

  context 'Square program' do
    it 'compiles the main file correctly' do
      tokenizer = Tokenizer.new(square_main_source)
      compilation_engine = CompilationEngine.new(tokenizer, output)
      compilation_engine.compile_class

      expect(compiled_vm_code).to eq(<<-VM)
function Main.main 1
call SquareGame.new 0
pop local 0
push local 0
call SquareGame.run 1
pop temp 0
push local 0
call SquareGame.dispose 1
pop temp 0
push constant 0
return
      VM
    end

    it 'compiles the square file correctly' do
      tokenizer = Tokenizer.new(square_square_source)
      compilation_engine = CompilationEngine.new(tokenizer, output)
      compilation_engine.compile_class

      expect(compiled_vm_code).to eq(<<-VM)
function Square.new 0
push constant 3
call Memory.alloc 1
pop pointer 0
push argument 0
pop this 0
push argument 1
pop this 1
push argument 2
pop this 2
push pointer 0
call Square.draw 1
pop temp 0
push pointer 0
return
function Square.dispose 0
push argument 0
pop pointer 0
push pointer 0
call Memory.deAlloc 1
pop temp 0
push constant 0
return
function Square.draw 0
push argument 0
pop pointer 0
push constant 0
not
call Screen.setColor 1
pop temp 0
push this 0
push this 1
push this 0
push this 2
add
push this 1
push this 2
add
call Screen.drawRectangle 4
pop temp 0
push constant 0
return
function Square.erase 0
push argument 0
pop pointer 0
push constant 0
call Screen.setColor 1
pop temp 0
push this 0
push this 1
push this 0
push this 2
add
push this 1
push this 2
add
call Screen.drawRectangle 4
pop temp 0
push constant 0
return
function Square.incSize 0
push argument 0
pop pointer 0
push this 1
push this 2
add
push constant 254
lt
push this 0
push this 2
add
push constant 510
lt
and
if-goto IF_TRUE0
goto IF_FALSE0
label IF_TRUE0
push pointer 0
call Square.erase 1
pop temp 0
push this 2
push constant 2
add
pop this 2
push pointer 0
call Square.draw 1
pop temp 0
label IF_FALSE0
push constant 0
return
function Square.decSize 0
push argument 0
pop pointer 0
push this 2
push constant 2
gt
if-goto IF_TRUE0
goto IF_FALSE0
label IF_TRUE0
push pointer 0
call Square.erase 1
pop temp 0
push this 2
push constant 2
sub
pop this 2
push pointer 0
call Square.draw 1
pop temp 0
label IF_FALSE0
push constant 0
return
function Square.moveUp 0
push argument 0
pop pointer 0
push this 1
push constant 1
gt
if-goto IF_TRUE0
goto IF_FALSE0
label IF_TRUE0
push constant 0
call Screen.setColor 1
pop temp 0
push this 0
push this 1
push this 2
add
push constant 1
sub
push this 0
push this 2
add
push this 1
push this 2
add
call Screen.drawRectangle 4
pop temp 0
push this 1
push constant 2
sub
pop this 1
push constant 0
not
call Screen.setColor 1
pop temp 0
push this 0
push this 1
push this 0
push this 2
add
push this 1
push constant 1
add
call Screen.drawRectangle 4
pop temp 0
label IF_FALSE0
push constant 0
return
function Square.moveDown 0
push argument 0
pop pointer 0
push this 1
push this 2
add
push constant 254
lt
if-goto IF_TRUE0
goto IF_FALSE0
label IF_TRUE0
push constant 0
call Screen.setColor 1
pop temp 0
push this 0
push this 1
push this 0
push this 2
add
push this 1
push constant 1
add
call Screen.drawRectangle 4
pop temp 0
push this 1
push constant 2
add
pop this 1
push constant 0
not
call Screen.setColor 1
pop temp 0
push this 0
push this 1
push this 2
add
push constant 1
sub
push this 0
push this 2
add
push this 1
push this 2
add
call Screen.drawRectangle 4
pop temp 0
label IF_FALSE0
push constant 0
return
function Square.moveLeft 0
push argument 0
pop pointer 0
push this 0
push constant 1
gt
if-goto IF_TRUE0
goto IF_FALSE0
label IF_TRUE0
push constant 0
call Screen.setColor 1
pop temp 0
push this 0
push this 2
add
push constant 1
sub
push this 1
push this 0
push this 2
add
push this 1
push this 2
add
call Screen.drawRectangle 4
pop temp 0
push this 0
push constant 2
sub
pop this 0
push constant 0
not
call Screen.setColor 1
pop temp 0
push this 0
push this 1
push this 0
push constant 1
add
push this 1
push this 2
add
call Screen.drawRectangle 4
pop temp 0
label IF_FALSE0
push constant 0
return
function Square.moveRight 0
push argument 0
pop pointer 0
push this 0
push this 2
add
push constant 510
lt
if-goto IF_TRUE0
goto IF_FALSE0
label IF_TRUE0
push constant 0
call Screen.setColor 1
pop temp 0
push this 0
push this 1
push this 0
push constant 1
add
push this 1
push this 2
add
call Screen.drawRectangle 4
pop temp 0
push this 0
push constant 2
add
pop this 0
push constant 0
not
call Screen.setColor 1
pop temp 0
push this 0
push this 2
add
push constant 1
sub
push this 1
push this 0
push this 2
add
push this 1
push this 2
add
call Screen.drawRectangle 4
pop temp 0
label IF_FALSE0
push constant 0
return
      VM
    end

    it 'compiles the squaregame file correctly' do
      tokenizer = Tokenizer.new(square_squaregame_source)
      compilation_engine = CompilationEngine.new(tokenizer, output)
      compilation_engine.compile_class

      expect(compiled_vm_code).to eq(<<-VM)
function SquareGame.new 0
push constant 2
call Memory.alloc 1
pop pointer 0
push constant 0
push constant 0
push constant 30
call Square.new 3
pop this 0
push constant 0
pop this 1
push pointer 0
return
function SquareGame.dispose 0
push argument 0
pop pointer 0
push this 0
call Square.dispose 1
pop temp 0
push pointer 0
call Memory.deAlloc 1
pop temp 0
push constant 0
return
function SquareGame.run 2
push argument 0
pop pointer 0
push constant 0
pop local 1
label WHILE_EXP0
push local 1
not
not
if-goto WHILE_END0
label WHILE_EXP1
push local 0
push constant 0
eq
not
if-goto WHILE_END1
call Keyboard.keyPressed 0
pop local 0
push pointer 0
call SquareGame.moveSquare 1
pop temp 0
goto WHILE_EXP1
label WHILE_END1
push local 0
push constant 81
eq
if-goto IF_TRUE0
goto IF_FALSE0
label IF_TRUE0
push constant 0
not
pop local 1
label IF_FALSE0
push local 0
push constant 90
eq
if-goto IF_TRUE1
goto IF_FALSE1
label IF_TRUE1
push this 0
call Square.decSize 1
pop temp 0
label IF_FALSE1
push local 0
push constant 88
eq
if-goto IF_TRUE2
goto IF_FALSE2
label IF_TRUE2
push this 0
call Square.incSize 1
pop temp 0
label IF_FALSE2
push local 0
push constant 131
eq
if-goto IF_TRUE3
goto IF_FALSE3
label IF_TRUE3
push constant 1
pop this 1
label IF_FALSE3
push local 0
push constant 133
eq
if-goto IF_TRUE4
goto IF_FALSE4
label IF_TRUE4
push constant 2
pop this 1
label IF_FALSE4
push local 0
push constant 130
eq
if-goto IF_TRUE5
goto IF_FALSE5
label IF_TRUE5
push constant 3
pop this 1
label IF_FALSE5
push local 0
push constant 132
eq
if-goto IF_TRUE6
goto IF_FALSE6
label IF_TRUE6
push constant 4
pop this 1
label IF_FALSE6
label WHILE_EXP2
push local 0
push constant 0
eq
not
not
if-goto WHILE_END2
call Keyboard.keyPressed 0
pop local 0
push pointer 0
call SquareGame.moveSquare 1
pop temp 0
goto WHILE_EXP2
label WHILE_END2
goto WHILE_EXP0
label WHILE_END0
push constant 0
return
function SquareGame.moveSquare 0
push argument 0
pop pointer 0
push this 1
push constant 1
eq
if-goto IF_TRUE0
goto IF_FALSE0
label IF_TRUE0
push this 0
call Square.moveUp 1
pop temp 0
label IF_FALSE0
push this 1
push constant 2
eq
if-goto IF_TRUE1
goto IF_FALSE1
label IF_TRUE1
push this 0
call Square.moveDown 1
pop temp 0
label IF_FALSE1
push this 1
push constant 3
eq
if-goto IF_TRUE2
goto IF_FALSE2
label IF_TRUE2
push this 0
call Square.moveLeft 1
pop temp 0
label IF_FALSE2
push this 1
push constant 4
eq
if-goto IF_TRUE3
goto IF_FALSE3
label IF_TRUE3
push this 0
call Square.moveRight 1
pop temp 0
label IF_FALSE3
push constant 5
call Sys.wait 1
pop temp 0
push constant 0
return
      VM
    end
  end

  it 'compiles the Average programm correctly' do
    tokenizer = Tokenizer.new(average_source)
    compilation_engine = CompilationEngine.new(tokenizer, output)
    compilation_engine.compile_class

    expect(compiled_vm_code).to eq(<<-VM)
function Main.main 4
push constant 18
call String.new 1
push constant 72
call String.appendChar 2
push constant 111
call String.appendChar 2
push constant 119
call String.appendChar 2
push constant 32
call String.appendChar 2
push constant 109
call String.appendChar 2
push constant 97
call String.appendChar 2
push constant 110
call String.appendChar 2
push constant 121
call String.appendChar 2
push constant 32
call String.appendChar 2
push constant 110
call String.appendChar 2
push constant 117
call String.appendChar 2
push constant 109
call String.appendChar 2
push constant 98
call String.appendChar 2
push constant 101
call String.appendChar 2
push constant 114
call String.appendChar 2
push constant 115
call String.appendChar 2
push constant 63
call String.appendChar 2
push constant 32
call String.appendChar 2
call Keyboard.readInt 1
pop local 1
push local 1
call Array.new 1
pop local 0
push constant 0
pop local 2
label WHILE_EXP0
push local 2
push local 1
lt
not
if-goto WHILE_END0
push local 2
push local 0
add
push constant 23
call String.new 1
push constant 69
call String.appendChar 2
push constant 110
call String.appendChar 2
push constant 116
call String.appendChar 2
push constant 101
call String.appendChar 2
push constant 114
call String.appendChar 2
push constant 32
call String.appendChar 2
push constant 116
call String.appendChar 2
push constant 104
call String.appendChar 2
push constant 101
call String.appendChar 2
push constant 32
call String.appendChar 2
push constant 110
call String.appendChar 2
push constant 101
call String.appendChar 2
push constant 120
call String.appendChar 2
push constant 116
call String.appendChar 2
push constant 32
call String.appendChar 2
push constant 110
call String.appendChar 2
push constant 117
call String.appendChar 2
push constant 109
call String.appendChar 2
push constant 98
call String.appendChar 2
push constant 101
call String.appendChar 2
push constant 114
call String.appendChar 2
push constant 58
call String.appendChar 2
push constant 32
call String.appendChar 2
call Keyboard.readInt 1
pop temp 0
pop pointer 1
push temp 0
pop that 0
push local 2
push constant 1
add
pop local 2
goto WHILE_EXP0
label WHILE_END0
push constant 0
pop local 2
push constant 0
pop local 3
label WHILE_EXP1
push local 2
push local 1
lt
not
if-goto WHILE_END1
push local 3
push local 2
push local 0
add
pop pointer 1
push that 0
add
pop local 3
push local 2
push constant 1
add
pop local 2
goto WHILE_EXP1
label WHILE_END1
push constant 16
call String.new 1
push constant 84
call String.appendChar 2
push constant 104
call String.appendChar 2
push constant 101
call String.appendChar 2
push constant 32
call String.appendChar 2
push constant 97
call String.appendChar 2
push constant 118
call String.appendChar 2
push constant 101
call String.appendChar 2
push constant 114
call String.appendChar 2
push constant 97
call String.appendChar 2
push constant 103
call String.appendChar 2
push constant 101
call String.appendChar 2
push constant 32
call String.appendChar 2
push constant 105
call String.appendChar 2
push constant 115
call String.appendChar 2
push constant 58
call String.appendChar 2
push constant 32
call String.appendChar 2
call Output.printString 1
pop temp 0
push local 3
push local 1
call Math.divide 2
call Output.printInt 1
pop temp 0
call Output.println 0
pop temp 0
push constant 0
return
    VM
  end

  let(:seven_jack_source) {
    <<-JACK
    // This file is part of www.nand2tetris.org
    // and the book "The Elements of Computing Systems"
    // by Nisan and Schocken, MIT Press.
    // File name: projects/11/Seven/Main.jack

    /**
     * Computes the value of 1 + (2 * 3) and prints the result
     *  at the top-left of the screen.
     */
    class Main {

       function void main() {
           do Output.printInt(1 + (2 * 3));
           return;
       }

    }
    JACK
  }

  let(:convert_to_bin_source) {
    <<-JACK
    // This file is part of www.nand2tetris.org
    // and the book "The Elements of Computing Systems"
    // by Nisan and Schocken, MIT Press.
    // File name: projects/11/ConvertToBin/Main.jack

    /**
     * Unpacks a 16-bit number into its binary representation:
     * Takes the 16-bit number stored in RAM[8000] and stores its individual
     * bits in RAM[8001..8016] (each location will contain 0 or 1).
     * Before the conversion, RAM[8001]..RAM[8016] are initialized to -1.
     *
     * The program should be tested as follows:
     * 1) Load the program into the supplied VM Emulator
     * 2) Put some value in RAM[8000]
     * 3) Switch to "no animation"
     * 4) Run the program (give it enough time to run)
     * 5) Stop the program
     * 6) Check that RAM[8001]..RAM[8016] contains the correct binary result, and
     *    that none of these memory locations contain -1.
     */
    class Main {

        /**
         * Initializes RAM[8001]..RAM[8016] to -1, and converts the value in
         * RAM[8000] to binary.
         */
        function void main() {
            var int result, value;

            do Main.fillMemory(8001, 16, -1); // sets RAM[8001]..RAM[8016] to -1
            let value = Memory.peek(8000);    // reads a value from RAM[8000]
            do Main.convert(value);           // perform the conversion

          return;
        }

        /** Converts the given decimal value to binary, and puts
         *  the resulting bits in RAM[8001]..RAM[8016]. */
        function void convert(int value) {
          var int mask, position;
          var boolean loop;

          let loop = true;

          while (loop) {
              let position = position + 1;
              let mask = Main.nextMask(mask);
              do Memory.poke(9000 + position, mask);

              if (~(position > 16)) {

                  if (~((value & mask) = 0)) {
                      do Memory.poke(8000 + position, 1);
                  }
                  else {
                      do Memory.poke(8000 + position, 0);
                  }
              }
              else {
                  let loop = false;
              }
          }

          return;
        }

        /** Returns the next mask (the mask that should follow the given mask). */
        function int nextMask(int mask) {
          if (mask = 0) {
              return 1;
          }
          else {
          return mask * 2;
          }
        }

        /** Fills 'length' consecutive memory locations with 'value',
          * starting at 'startAddress'. */
        function void fillMemory(int startAddress, int length, int value) {
            while (length > 0) {
                do Memory.poke(startAddress, value);
                let length = length - 1;
                let startAddress = startAddress + 1;
            }

            return;
        }
    }

    JACK
  }

  let(:square_main_source) {
    <<-JACK
    // This file is part of www.nand2tetris.org
    // and the book "The Elements of Computing Systems"
    // by Nisan and Schocken, MIT Press.
    // File name: projects/09/Square/Main.jack

    /**
     * The Main class initializes a new Square Dance game and starts it.
     */
    class Main {

        /** Initializes a new game and starts it. */
        function void main() {
            var SquareGame game;

            let game = SquareGame.new();
            do game.run();
            do game.dispose();

            return;
        }
    }
    JACK
  }
  let(:square_square_source) {
    <<-JACK
    // This file is part of www.nand2tetris.org
    // and the book "The Elements of Computing Systems"
    // by Nisan and Schocken, MIT Press.
    // File name: projects/09/Square/Square.jack

    /**
     * Implements a graphic square. A graphic square has a screen location
     * and a size. It also has methods for drawing, erasing, moving on the
     * screen, and changing its size.
     */
    class Square {

        // Location on the screen
        field int x, y;

        // The size of the square
        field int size;

        /** Constructs a new square with a given location and size. */
        constructor Square new(int Ax, int Ay, int Asize) {
            let x = Ax;
            let y = Ay;
            let size = Asize;

            do draw();

            return this;
        }

        /** Deallocates the object's memory. */
        method void dispose() {
            do Memory.deAlloc(this);
            return;
        }

        /** Draws the square on the screen. */
        method void draw() {
            do Screen.setColor(true);
            do Screen.drawRectangle(x, y, x + size, y + size);
            return;
        }

        /** Erases the square from the screen. */
        method void erase() {
            do Screen.setColor(false);
            do Screen.drawRectangle(x, y, x + size, y + size);
            return;
        }

        /** Increments the size by 2 pixels. */
        method void incSize() {
            if (((y + size) < 254) & ((x + size) < 510)) {
                do erase();
                let size = size + 2;
                do draw();
            }
            return;
        }

        /** Decrements the size by 2 pixels. */
        method void decSize() {
            if (size > 2) {
                do erase();
                let size = size - 2;
                do draw();
            }
            return;
        }

        /** Moves up by 2 pixels. */
        method void moveUp() {
            if (y > 1) {
                do Screen.setColor(false);
                do Screen.drawRectangle(x, (y + size) - 1, x + size, y + size);
                let y = y - 2;
                do Screen.setColor(true);
                do Screen.drawRectangle(x, y, x + size, y + 1);
            }
            return;
        }

        /** Moves down by 2 pixels. */
        method void moveDown() {
            if ((y + size) < 254) {
                do Screen.setColor(false);
                do Screen.drawRectangle(x, y, x + size, y + 1);
                let y = y + 2;
                do Screen.setColor(true);
                do Screen.drawRectangle(x, (y + size) - 1, x + size, y + size);
            }
            return;
        }

        /** Moves left by 2 pixels. */
        method void moveLeft() {
            if (x > 1) {
                do Screen.setColor(false);
                do Screen.drawRectangle((x + size) - 1, y, x + size, y + size);
                let x = x - 2;
                do Screen.setColor(true);
                do Screen.drawRectangle(x, y, x + 1, y + size);
            }
            return;
        }

        /** Moves right by 2 pixels. */
        method void moveRight() {
            if ((x + size) < 510) {
                do Screen.setColor(false);
                do Screen.drawRectangle(x, y, x + 1, y + size);
                let x = x + 2;
                do Screen.setColor(true);
                do Screen.drawRectangle((x + size) - 1, y, x + size, y + size);
            }
            return;
        }
    }
    JACK
  }
  let(:square_squaregame_source) {
    <<-JACK
    // This file is part of www.nand2tetris.org
    // and the book "The Elements of Computing Systems"
    // by Nisan and Schocken, MIT Press.
    // File name: projects/09/Square/SquareGame.jack

    /**
     * Implements the Square Dance game.
     * In this game you can move a black square around the screen and
     * change its size during the movement.
     * In the beginning, the square is located at the top-left corner
     * of the screen. The arrow keys are used to move the square.
     * The 'z' & 'x' keys are used to decrement and increment the size.
     * The 'q' key is used to quit the game.
     */
    class SquareGame {

        // The square
        field Square square;

        // The square's movement direction
        field int direction; // 0=none,1=up,2=down,3=left,4=right

        /** Constructs a new Square Game. */
        constructor SquareGame new() {
            let square = Square.new(0, 0, 30);
            let direction = 0;

            return this;
        }

        /** Deallocates the object's memory. */
        method void dispose() {
            do square.dispose();
            do Memory.deAlloc(this);
            return;
        }

        /** Starts the game. Handles inputs from the user that control
         *  the square's movement, direction and size. */
        method void run() {
            var char key;
            var boolean exit;

            let exit = false;

            while (~exit) {
                // waits for a key to be pressed.
                while (key = 0) {
                    let key = Keyboard.keyPressed();
                    do moveSquare();
                }

                if (key = 81) {
                    let exit = true;
                }
                if (key = 90) {
                    do square.decSize();
                }
                if (key = 88) {
                    do square.incSize();
                }
                if (key = 131) {
                    let direction = 1;
                }
                if (key = 133) {
                    let direction = 2;
                }
                if (key = 130) {
                    let direction = 3;
                }
                if (key = 132) {
                    let direction = 4;
                }

                // waits for the key to be released.
                while (~(key = 0)) {
                    let key = Keyboard.keyPressed();
                    do moveSquare();
                }
            }

            return;
        }

        /** Moves the square by 2 pixels in the current direction. */
        method void moveSquare() {
            if (direction = 1) {
                do square.moveUp();
            }
            if (direction = 2) {
                do square.moveDown();
            }
            if (direction = 3) {
                do square.moveLeft();
            }
            if (direction = 4) {
                do square.moveRight();
            }

            do Sys.wait(5); // Delays the next movement.
            return;
        }
    }
    JACK
  }

  let(:average_source) {
    <<-JACK
    // This file is part of www.nand2tetris.org
    // and the book "The Elements of Computing Systems"
    // by Nisan and Schocken, MIT Press.
    // File name: projects/11/Average/Main.jack

    /** Computes the average of a sequence of integers */
    class Main {
        function void main() {
            var Array a;
            var int length;
            var int i, sum;

            let length = Keyboard.readInt("How many numbers? ");
            let a = Array.new(length);
            let i = 0;

            while (i < length) {
                let a[i] = Keyboard.readInt("Enter the next number: ");
                let i = i + 1;
            }

            let i = 0;
            let sum = 0;

            while (i < length) {
                let sum = sum + a[i];
                let i = i + 1;
            }

            do Output.printString("The average is: ");
            do Output.printInt(sum / length);
            do Output.println();

            return;
        }
    }
    JACK
  }
end
