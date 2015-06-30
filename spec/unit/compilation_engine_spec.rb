require 'compilation_engine'
require 'tokenizer'

RSpec.describe CompilationEngine do
  it 'works' do
    tokenizer = Tokenizer.new(<<-JACK)
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

    out = StringIO.new
    compilation_engine = CompilationEngine.new(tokenizer, out)
    compilation_engine.compile_class

    expect(out.string).to eq(<<-VM)
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
end
