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
