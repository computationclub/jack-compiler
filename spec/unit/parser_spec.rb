require 'parser'
require 'tokenizer'

RSpec.describe "Parser" do
  it "parses ExpressionlessSquare::Square" do
    input =<<-EOJACK
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/10/ExpressionlessSquare/Square.jack

// Expressionless version of Square.jack.

/**
 * The Square class implements a graphic square. A graphic square
 * has a location on the screen and a size. It also has methods
 * for drawing, erasing, moving on the screen, and changing its size.
 */
class Square {

    // Location on the screen
    field int x, y;

    // The size of the square
    field int size;

    // Constructs a new square with a given location and size.
    constructor Square new(int Ax, int Ay, int Asize) {
        let x = Ax;
        let y = Ay;
        let size = Asize;

        do draw();

        return x;
    }

    // Deallocates the object's memory.
    method void dispose() {
        do Memory.deAlloc(x);
        return;
    }

    // Draws the square on the screen.
    method void draw() {
        do Screen.setColor(x);
        do Screen.drawRectangle(x, y, x, y);
        return;
    }

    // Erases the square from the screen.
    method void erase() {
        do Screen.setColor(x);
        do Screen.drawRectangle(x, y, x, y);
        return;
    }

    // Increments the size by 2.
    method void incSize() {
        if (x) {
            do erase();
            let size = size;
            do draw();
        }
        return;
    }

    // Decrements the size by 2.
    method void decSize() {
        if (size) {
            do erase();
            let size = size;
            do draw();
        }
        return;
    }

    // Moves up by 2.
    method void moveUp() {
        if (y) {
            do Screen.setColor(x);
            do Screen.drawRectangle(x, y, x, y);
            let y = y;
            do Screen.setColor(x);
            do Screen.drawRectangle(x, y, x, y);
        }
        return;
    }

    // Moves down by 2.
    method void moveDown() {
        if (y) {
            do Screen.setColor(x);
            do Screen.drawRectangle(x, y, x, y);
            let y = y;
            do Screen.setColor(x);
            do Screen.drawRectangle(x, y, x, y);
        }
        return;
    }

    // Moves left by 2.
    method void moveLeft() {
        if (x) {
            do Screen.setColor(x);
            do Screen.drawRectangle(x, y, x, y);
            let x = x;
            do Screen.setColor(x);
            do Screen.drawRectangle(x, y, x, y);
        }
        return;
    }

    // Moves right by 2.
    method void moveRight() {
        if (x) {
            do Screen.setColor(x);
            do Screen.drawRectangle(x, y, x, y);
            let x = x;
            do Screen.setColor(x);
            do Screen.drawRectangle(x, y, x, y);
        }
        return;
    }
}
    EOJACK

    expected =<<-EOXML
<class>
  <keyword>class</keyword>
  <identifier>Square</identifier>
  <symbol>{</symbol>
  <classVarDec>
    <keyword>field</keyword>
    <keyword>int</keyword>
    <identifier>x</identifier>
    <symbol>,</symbol>
    <identifier>y</identifier>
    <symbol>;</symbol>
  </classVarDec>
  <classVarDec>
    <keyword>field</keyword>
    <keyword>int</keyword>
    <identifier>size</identifier>
    <symbol>;</symbol>
  </classVarDec>
  <subroutineDec>
    <keyword>constructor</keyword>
    <identifier>Square</identifier>
    <identifier>new</identifier>
    <symbol>(</symbol>
    <parameterList>
      <keyword>int</keyword>
      <identifier>Ax</identifier>
      <symbol>,</symbol>
      <keyword>int</keyword>
      <identifier>Ay</identifier>
      <symbol>,</symbol>
      <keyword>int</keyword>
      <identifier>Asize</identifier>
    </parameterList>
    <symbol>)</symbol>
    <subroutineBody>
      <symbol>{</symbol>
      <statements>
        <letStatement>
          <keyword>let</keyword>
          <identifier>x</identifier>
          <symbol>=</symbol>
          <expression>
            <term>
              <identifier>Ax</identifier>
            </term>
          </expression>
          <symbol>;</symbol>
        </letStatement>
        <letStatement>
          <keyword>let</keyword>
          <identifier>y</identifier>
          <symbol>=</symbol>
          <expression>
            <term>
              <identifier>Ay</identifier>
            </term>
          </expression>
          <symbol>;</symbol>
        </letStatement>
        <letStatement>
          <keyword>let</keyword>
          <identifier>size</identifier>
          <symbol>=</symbol>
          <expression>
            <term>
              <identifier>Asize</identifier>
            </term>
          </expression>
          <symbol>;</symbol>
        </letStatement>
        <doStatement>
          <keyword>do</keyword>
          <identifier>draw</identifier>
          <symbol>(</symbol>
          <expressionList>
          </expressionList>
          <symbol>)</symbol>
          <symbol>;</symbol>
        </doStatement>
        <returnStatement>
          <keyword>return</keyword>
          <expression>
            <term>
              <identifier>x</identifier>
            </term>
          </expression>
          <symbol>;</symbol>
        </returnStatement>
      </statements>
      <symbol>}</symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword>method</keyword>
    <keyword>void</keyword>
    <identifier>dispose</identifier>
    <symbol>(</symbol>
    <parameterList>
    </parameterList>
    <symbol>)</symbol>
    <subroutineBody>
      <symbol>{</symbol>
      <statements>
        <doStatement>
          <keyword>do</keyword>
          <identifier>Memory</identifier>
          <symbol>.</symbol>
          <identifier>deAlloc</identifier>
          <symbol>(</symbol>
          <expressionList>
            <expression>
              <term>
                <identifier>x</identifier>
              </term>
            </expression>
          </expressionList>
          <symbol>)</symbol>
          <symbol>;</symbol>
        </doStatement>
        <returnStatement>
          <keyword>return</keyword>
          <symbol>;</symbol>
        </returnStatement>
      </statements>
      <symbol>}</symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword>method</keyword>
    <keyword>void</keyword>
    <identifier>draw</identifier>
    <symbol>(</symbol>
    <parameterList>
    </parameterList>
    <symbol>)</symbol>
    <subroutineBody>
      <symbol>{</symbol>
      <statements>
        <doStatement>
          <keyword>do</keyword>
          <identifier>Screen</identifier>
          <symbol>.</symbol>
          <identifier>setColor</identifier>
          <symbol>(</symbol>
          <expressionList>
            <expression>
              <term>
                <identifier>x</identifier>
              </term>
            </expression>
          </expressionList>
          <symbol>)</symbol>
          <symbol>;</symbol>
        </doStatement>
        <doStatement>
          <keyword>do</keyword>
          <identifier>Screen</identifier>
          <symbol>.</symbol>
          <identifier>drawRectangle</identifier>
          <symbol>(</symbol>
          <expressionList>
            <expression>
              <term>
                <identifier>x</identifier>
              </term>
            </expression>
            <symbol>,</symbol>
            <expression>
              <term>
                <identifier>y</identifier>
              </term>
            </expression>
            <symbol>,</symbol>
            <expression>
              <term>
                <identifier>x</identifier>
              </term>
            </expression>
            <symbol>,</symbol>
            <expression>
              <term>
                <identifier>y</identifier>
              </term>
            </expression>
          </expressionList>
          <symbol>)</symbol>
          <symbol>;</symbol>
        </doStatement>
        <returnStatement>
          <keyword>return</keyword>
          <symbol>;</symbol>
        </returnStatement>
      </statements>
      <symbol>}</symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword>method</keyword>
    <keyword>void</keyword>
    <identifier>erase</identifier>
    <symbol>(</symbol>
    <parameterList>
    </parameterList>
    <symbol>)</symbol>
    <subroutineBody>
      <symbol>{</symbol>
      <statements>
        <doStatement>
          <keyword>do</keyword>
          <identifier>Screen</identifier>
          <symbol>.</symbol>
          <identifier>setColor</identifier>
          <symbol>(</symbol>
          <expressionList>
            <expression>
              <term>
                <identifier>x</identifier>
              </term>
            </expression>
          </expressionList>
          <symbol>)</symbol>
          <symbol>;</symbol>
        </doStatement>
        <doStatement>
          <keyword>do</keyword>
          <identifier>Screen</identifier>
          <symbol>.</symbol>
          <identifier>drawRectangle</identifier>
          <symbol>(</symbol>
          <expressionList>
            <expression>
              <term>
                <identifier>x</identifier>
              </term>
            </expression>
            <symbol>,</symbol>
            <expression>
              <term>
                <identifier>y</identifier>
              </term>
            </expression>
            <symbol>,</symbol>
            <expression>
              <term>
                <identifier>x</identifier>
              </term>
            </expression>
            <symbol>,</symbol>
            <expression>
              <term>
                <identifier>y</identifier>
              </term>
            </expression>
          </expressionList>
          <symbol>)</symbol>
          <symbol>;</symbol>
        </doStatement>
        <returnStatement>
          <keyword>return</keyword>
          <symbol>;</symbol>
        </returnStatement>
      </statements>
      <symbol>}</symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword>method</keyword>
    <keyword>void</keyword>
    <identifier>incSize</identifier>
    <symbol>(</symbol>
    <parameterList>
    </parameterList>
    <symbol>)</symbol>
    <subroutineBody>
      <symbol>{</symbol>
      <statements>
        <ifStatement>
          <keyword>if</keyword>
          <symbol>(</symbol>
          <expression>
            <term>
              <identifier>x</identifier>
            </term>
          </expression>
          <symbol>)</symbol>
          <symbol>{</symbol>
          <statements>
            <doStatement>
              <keyword>do</keyword>
              <identifier>erase</identifier>
              <symbol>(</symbol>
              <expressionList>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
            <letStatement>
              <keyword>let</keyword>
              <identifier>size</identifier>
              <symbol>=</symbol>
              <expression>
                <term>
                  <identifier>size</identifier>
                </term>
              </expression>
              <symbol>;</symbol>
            </letStatement>
            <doStatement>
              <keyword>do</keyword>
              <identifier>draw</identifier>
              <symbol>(</symbol>
              <expressionList>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
          </statements>
          <symbol>}</symbol>
        </ifStatement>
        <returnStatement>
          <keyword>return</keyword>
          <symbol>;</symbol>
        </returnStatement>
      </statements>
      <symbol>}</symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword>method</keyword>
    <keyword>void</keyword>
    <identifier>decSize</identifier>
    <symbol>(</symbol>
    <parameterList>
    </parameterList>
    <symbol>)</symbol>
    <subroutineBody>
      <symbol>{</symbol>
      <statements>
        <ifStatement>
          <keyword>if</keyword>
          <symbol>(</symbol>
          <expression>
            <term>
              <identifier>size</identifier>
            </term>
          </expression>
          <symbol>)</symbol>
          <symbol>{</symbol>
          <statements>
            <doStatement>
              <keyword>do</keyword>
              <identifier>erase</identifier>
              <symbol>(</symbol>
              <expressionList>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
            <letStatement>
              <keyword>let</keyword>
              <identifier>size</identifier>
              <symbol>=</symbol>
              <expression>
                <term>
                  <identifier>size</identifier>
                </term>
              </expression>
              <symbol>;</symbol>
            </letStatement>
            <doStatement>
              <keyword>do</keyword>
              <identifier>draw</identifier>
              <symbol>(</symbol>
              <expressionList>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
          </statements>
          <symbol>}</symbol>
        </ifStatement>
        <returnStatement>
          <keyword>return</keyword>
          <symbol>;</symbol>
        </returnStatement>
      </statements>
      <symbol>}</symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword>method</keyword>
    <keyword>void</keyword>
    <identifier>moveUp</identifier>
    <symbol>(</symbol>
    <parameterList>
    </parameterList>
    <symbol>)</symbol>
    <subroutineBody>
      <symbol>{</symbol>
      <statements>
        <ifStatement>
          <keyword>if</keyword>
          <symbol>(</symbol>
          <expression>
            <term>
              <identifier>y</identifier>
            </term>
          </expression>
          <symbol>)</symbol>
          <symbol>{</symbol>
          <statements>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>setColor</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>drawRectangle</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
            <letStatement>
              <keyword>let</keyword>
              <identifier>y</identifier>
              <symbol>=</symbol>
              <expression>
                <term>
                  <identifier>y</identifier>
                </term>
              </expression>
              <symbol>;</symbol>
            </letStatement>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>setColor</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>drawRectangle</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
          </statements>
          <symbol>}</symbol>
        </ifStatement>
        <returnStatement>
          <keyword>return</keyword>
          <symbol>;</symbol>
        </returnStatement>
      </statements>
      <symbol>}</symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword>method</keyword>
    <keyword>void</keyword>
    <identifier>moveDown</identifier>
    <symbol>(</symbol>
    <parameterList>
    </parameterList>
    <symbol>)</symbol>
    <subroutineBody>
      <symbol>{</symbol>
      <statements>
        <ifStatement>
          <keyword>if</keyword>
          <symbol>(</symbol>
          <expression>
            <term>
              <identifier>y</identifier>
            </term>
          </expression>
          <symbol>)</symbol>
          <symbol>{</symbol>
          <statements>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>setColor</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>drawRectangle</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
            <letStatement>
              <keyword>let</keyword>
              <identifier>y</identifier>
              <symbol>=</symbol>
              <expression>
                <term>
                  <identifier>y</identifier>
                </term>
              </expression>
              <symbol>;</symbol>
            </letStatement>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>setColor</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>drawRectangle</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
          </statements>
          <symbol>}</symbol>
        </ifStatement>
        <returnStatement>
          <keyword>return</keyword>
          <symbol>;</symbol>
        </returnStatement>
      </statements>
      <symbol>}</symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword>method</keyword>
    <keyword>void</keyword>
    <identifier>moveLeft</identifier>
    <symbol>(</symbol>
    <parameterList>
    </parameterList>
    <symbol>)</symbol>
    <subroutineBody>
      <symbol>{</symbol>
      <statements>
        <ifStatement>
          <keyword>if</keyword>
          <symbol>(</symbol>
          <expression>
            <term>
              <identifier>x</identifier>
            </term>
          </expression>
          <symbol>)</symbol>
          <symbol>{</symbol>
          <statements>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>setColor</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>drawRectangle</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
            <letStatement>
              <keyword>let</keyword>
              <identifier>x</identifier>
              <symbol>=</symbol>
              <expression>
                <term>
                  <identifier>x</identifier>
                </term>
              </expression>
              <symbol>;</symbol>
            </letStatement>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>setColor</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>drawRectangle</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
          </statements>
          <symbol>}</symbol>
        </ifStatement>
        <returnStatement>
          <keyword>return</keyword>
          <symbol>;</symbol>
        </returnStatement>
      </statements>
      <symbol>}</symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword>method</keyword>
    <keyword>void</keyword>
    <identifier>moveRight</identifier>
    <symbol>(</symbol>
    <parameterList>
    </parameterList>
    <symbol>)</symbol>
    <subroutineBody>
      <symbol>{</symbol>
      <statements>
        <ifStatement>
          <keyword>if</keyword>
          <symbol>(</symbol>
          <expression>
            <term>
              <identifier>x</identifier>
            </term>
          </expression>
          <symbol>)</symbol>
          <symbol>{</symbol>
          <statements>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>setColor</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>drawRectangle</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
            <letStatement>
              <keyword>let</keyword>
              <identifier>x</identifier>
              <symbol>=</symbol>
              <expression>
                <term>
                  <identifier>x</identifier>
                </term>
              </expression>
              <symbol>;</symbol>
            </letStatement>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>setColor</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
            <doStatement>
              <keyword>do</keyword>
              <identifier>Screen</identifier>
              <symbol>.</symbol>
              <identifier>drawRectangle</identifier>
              <symbol>(</symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>x</identifier>
                  </term>
                </expression>
                <symbol>,</symbol>
                <expression>
                  <term>
                    <identifier>y</identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol>)</symbol>
              <symbol>;</symbol>
            </doStatement>
          </statements>
          <symbol>}</symbol>
        </ifStatement>
        <returnStatement>
          <keyword>return</keyword>
          <symbol>;</symbol>
        </returnStatement>
      </statements>
      <symbol>}</symbol>
    </subroutineBody>
  </subroutineDec>
  <symbol>}</symbol>
</class>
    EOXML

    difftest(input, expected)
  end

  it "parses ExpressionlessSquare::Main" do
    input =<<-EOJACK
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/10/ExpressionlessSquare/Main.jack

// Expressionless version of Main.jack.

/**
 * The Main class initializes a new Square Dance game and starts it.
 */
class Main {

    // Initializes the square game and starts it.
    function void main() {
        var SquareGame game;

        let game = game;
        do game.run();
    do game.dispose();

        return;
    }
}
    EOJACK

    expected =<<-EOXML
<class>
  <keyword> class </keyword>
  <identifier> Main </identifier>
  <symbol> { </symbol>
  <subroutineDec>
    <keyword> function </keyword>
    <keyword> void </keyword>
    <identifier> main </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <varDec>
        <keyword> var </keyword>
        <identifier> SquareGame </identifier>
        <identifier> game </identifier>
        <symbol> ; </symbol>
      </varDec>
      <statements>
        <letStatement>
          <keyword> let </keyword>
          <identifier> game </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <identifier> game </identifier>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <doStatement>
          <keyword> do </keyword>
          <identifier> game </identifier>
          <symbol> . </symbol>
          <identifier> run </identifier>
          <symbol> ( </symbol>
          <expressionList>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <doStatement>
          <keyword> do </keyword>
          <identifier> game </identifier>
          <symbol> . </symbol>
          <identifier> dispose </identifier>
          <symbol> ( </symbol>
          <expressionList>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <symbol> } </symbol>
</class>
    EOXML

    difftest(input, expected)
  end

  it "parses ExpressionlessSquare::SquareGame" do
    input =<<-EOJACK
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/10/ExpressionlessSquare/SquareGame.jack

// Expressionless version of Square.jack.

/**
 * The SquareDance class implements the Square Dance game.
 * In this game you can move a black square around the screen and
 * change its size during the movement.
 * In the beggining, the square is located at the top left corner.
 * Use the arrow keys to move the square.
 * Use 'z' & 'x' to decrement & increment the size.
 * Use 'q' to quit.
 */
class SquareGame {

    // The square
    field Square square;

    // The square's movement direction
    field int direction; // 0=none,1=up,2=down,3=left,4=right

    // Constructs a new Square Game.
    constructor SquareGame new() {
        let square = square;
        let direction = direction;

        return square;
    }

    // Deallocates the object's memory.
    method void dispose() {
        do square.dispose();
        do Memory.deAlloc(square);
        return;
    }

    // Starts the game. Handles inputs from the user that controls
    // the square movement direction and size.
    method void run() {
        var char key;
        var boolean exit;

        let exit = key;

        while (exit) {
            // waits for a key to be pressed.
            while (key) {
                let key = key;
                do moveSquare();
            }

            if (key) {
                let exit = exit;
            }
            if (key) {
                do square.decSize();
            }
            if (key) {
                do square.incSize();
            }
            if (key) {
                let direction = exit;
            }
            if (key) {
                let direction = key;
            }
            if (key) {
                let direction = square;
            }
            if (key) {
                let direction = direction;
            }

            // waits for the key to be released.
            while (key) {
                let key = key;
                do moveSquare();
            }
        }

        return;
    }

    // Moves the square by 2 in the current direction.
    method void moveSquare() {
        if (direction) {
            do square.moveUp();
        }
        if (direction) {
            do square.moveDown();
        }
        if (direction) {
            do square.moveLeft();
        }
        if (direction) {
            do square.moveRight();
        }

        do Sys.wait(direction); // Delays the next movement.
        return;
    }
}
    EOJACK

    expected =<<-EOXML
<class>
  <keyword> class </keyword>
  <identifier> SquareGame </identifier>
  <symbol> { </symbol>
  <classVarDec>
    <keyword> field </keyword>
    <identifier> Square </identifier>
    <identifier> square </identifier>
    <symbol> ; </symbol>
  </classVarDec>
  <classVarDec>
    <keyword> field </keyword>
    <keyword> int </keyword>
    <identifier> direction </identifier>
    <symbol> ; </symbol>
  </classVarDec>
  <subroutineDec>
    <keyword> constructor </keyword>
    <identifier> SquareGame </identifier>
    <identifier> new </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <letStatement>
          <keyword> let </keyword>
          <identifier> square </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <identifier> square </identifier>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <letStatement>
          <keyword> let </keyword>
          <identifier> direction </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <identifier> direction </identifier>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <returnStatement>
          <keyword> return </keyword>
          <expression>
            <term>
              <identifier> square </identifier>
            </term>
          </expression>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> dispose </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <doStatement>
          <keyword> do </keyword>
          <identifier> square </identifier>
          <symbol> . </symbol>
          <identifier> dispose </identifier>
          <symbol> ( </symbol>
          <expressionList>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <doStatement>
          <keyword> do </keyword>
          <identifier> Memory </identifier>
          <symbol> . </symbol>
          <identifier> deAlloc </identifier>
          <symbol> ( </symbol>
          <expressionList>
            <expression>
              <term>
                <identifier> square </identifier>
              </term>
            </expression>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> run </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <varDec>
        <keyword> var </keyword>
        <keyword> char </keyword>
        <identifier> key </identifier>
        <symbol> ; </symbol>
      </varDec>
      <varDec>
        <keyword> var </keyword>
        <keyword> boolean </keyword>
        <identifier> exit </identifier>
        <symbol> ; </symbol>
      </varDec>
      <statements>
        <letStatement>
          <keyword> let </keyword>
          <identifier> exit </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <identifier> key </identifier>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <whileStatement>
          <keyword> while </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> exit </identifier>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <whileStatement>
              <keyword> while </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <letStatement>
                  <keyword> let </keyword>
                  <identifier> key </identifier>
                  <symbol> = </symbol>
                  <expression>
                    <term>
                      <identifier> key </identifier>
                    </term>
                  </expression>
                  <symbol> ; </symbol>
                </letStatement>
                <doStatement>
                  <keyword> do </keyword>
                  <identifier> moveSquare </identifier>
                  <symbol> ( </symbol>
                  <expressionList>
                  </expressionList>
                  <symbol> ) </symbol>
                  <symbol> ; </symbol>
                </doStatement>
              </statements>
              <symbol> } </symbol>
            </whileStatement>
            <ifStatement>
              <keyword> if </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <letStatement>
                  <keyword> let </keyword>
                  <identifier> exit </identifier>
                  <symbol> = </symbol>
                  <expression>
                    <term>
                      <identifier> exit </identifier>
                    </term>
                  </expression>
                  <symbol> ; </symbol>
                </letStatement>
              </statements>
              <symbol> } </symbol>
            </ifStatement>
            <ifStatement>
              <keyword> if </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <doStatement>
                  <keyword> do </keyword>
                  <identifier> square </identifier>
                  <symbol> . </symbol>
                  <identifier> decSize </identifier>
                  <symbol> ( </symbol>
                  <expressionList>
                  </expressionList>
                  <symbol> ) </symbol>
                  <symbol> ; </symbol>
                </doStatement>
              </statements>
              <symbol> } </symbol>
            </ifStatement>
            <ifStatement>
              <keyword> if </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <doStatement>
                  <keyword> do </keyword>
                  <identifier> square </identifier>
                  <symbol> . </symbol>
                  <identifier> incSize </identifier>
                  <symbol> ( </symbol>
                  <expressionList>
                  </expressionList>
                  <symbol> ) </symbol>
                  <symbol> ; </symbol>
                </doStatement>
              </statements>
              <symbol> } </symbol>
            </ifStatement>
            <ifStatement>
              <keyword> if </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <letStatement>
                  <keyword> let </keyword>
                  <identifier> direction </identifier>
                  <symbol> = </symbol>
                  <expression>
                    <term>
                      <identifier> exit </identifier>
                    </term>
                  </expression>
                  <symbol> ; </symbol>
                </letStatement>
              </statements>
              <symbol> } </symbol>
            </ifStatement>
            <ifStatement>
              <keyword> if </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <letStatement>
                  <keyword> let </keyword>
                  <identifier> direction </identifier>
                  <symbol> = </symbol>
                  <expression>
                    <term>
                      <identifier> key </identifier>
                    </term>
                  </expression>
                  <symbol> ; </symbol>
                </letStatement>
              </statements>
              <symbol> } </symbol>
            </ifStatement>
            <ifStatement>
              <keyword> if </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <letStatement>
                  <keyword> let </keyword>
                  <identifier> direction </identifier>
                  <symbol> = </symbol>
                  <expression>
                    <term>
                      <identifier> square </identifier>
                    </term>
                  </expression>
                  <symbol> ; </symbol>
                </letStatement>
              </statements>
              <symbol> } </symbol>
            </ifStatement>
            <ifStatement>
              <keyword> if </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <letStatement>
                  <keyword> let </keyword>
                  <identifier> direction </identifier>
                  <symbol> = </symbol>
                  <expression>
                    <term>
                      <identifier> direction </identifier>
                    </term>
                  </expression>
                  <symbol> ; </symbol>
                </letStatement>
              </statements>
              <symbol> } </symbol>
            </ifStatement>
            <whileStatement>
              <keyword> while </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <letStatement>
                  <keyword> let </keyword>
                  <identifier> key </identifier>
                  <symbol> = </symbol>
                  <expression>
                    <term>
                      <identifier> key </identifier>
                    </term>
                  </expression>
                  <symbol> ; </symbol>
                </letStatement>
                <doStatement>
                  <keyword> do </keyword>
                  <identifier> moveSquare </identifier>
                  <symbol> ( </symbol>
                  <expressionList>
                  </expressionList>
                  <symbol> ) </symbol>
                  <symbol> ; </symbol>
                </doStatement>
              </statements>
              <symbol> } </symbol>
            </whileStatement>
          </statements>
          <symbol> } </symbol>
        </whileStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> moveSquare </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> direction </identifier>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <doStatement>
              <keyword> do </keyword>
              <identifier> square </identifier>
              <symbol> . </symbol>
              <identifier> moveUp </identifier>
              <symbol> ( </symbol>
              <expressionList>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
          </statements>
          <symbol> } </symbol>
        </ifStatement>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> direction </identifier>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <doStatement>
              <keyword> do </keyword>
              <identifier> square </identifier>
              <symbol> . </symbol>
              <identifier> moveDown </identifier>
              <symbol> ( </symbol>
              <expressionList>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
          </statements>
          <symbol> } </symbol>
        </ifStatement>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> direction </identifier>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <doStatement>
              <keyword> do </keyword>
              <identifier> square </identifier>
              <symbol> . </symbol>
              <identifier> moveLeft </identifier>
              <symbol> ( </symbol>
              <expressionList>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
          </statements>
          <symbol> } </symbol>
        </ifStatement>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> direction </identifier>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <doStatement>
              <keyword> do </keyword>
              <identifier> square </identifier>
              <symbol> . </symbol>
              <identifier> moveRight </identifier>
              <symbol> ( </symbol>
              <expressionList>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
          </statements>
          <symbol> } </symbol>
        </ifStatement>
        <doStatement>
          <keyword> do </keyword>
          <identifier> Sys </identifier>
          <symbol> . </symbol>
          <identifier> wait </identifier>
          <symbol> ( </symbol>
          <expressionList>
            <expression>
              <term>
                <identifier> direction </identifier>
              </term>
            </expression>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <symbol> } </symbol>
</class>
    EOXML

    difftest(input, expected)
  end

  it "parses Square::Main" do
    input =<<-EOJACK
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
    EOJACK

    expected =<<-EOXML
<class>
  <keyword> class </keyword>
  <identifier> Main </identifier>
  <symbol> { </symbol>
  <subroutineDec>
    <keyword> function </keyword>
    <keyword> void </keyword>
    <identifier> main </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <varDec>
        <keyword> var </keyword>
        <identifier> SquareGame </identifier>
        <identifier> game </identifier>
        <symbol> ; </symbol>
      </varDec>
      <statements>
        <letStatement>
          <keyword> let </keyword>
          <identifier> game </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <identifier> SquareGame </identifier>
              <symbol> . </symbol>
              <identifier> new </identifier>
              <symbol> ( </symbol>
              <expressionList>
              </expressionList>
              <symbol> ) </symbol>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <doStatement>
          <keyword> do </keyword>
          <identifier> game </identifier>
          <symbol> . </symbol>
          <identifier> run </identifier>
          <symbol> ( </symbol>
          <expressionList>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <doStatement>
          <keyword> do </keyword>
          <identifier> game </identifier>
          <symbol> . </symbol>
          <identifier> dispose </identifier>
          <symbol> ( </symbol>
          <expressionList>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <symbol> } </symbol>
</class>
    EOXML

    difftest(input, expected)
  end

  it "parses Square::Square" do
    input =<<-EOJACK
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
    EOJACK

    expected =<<-EOXML
<class>
  <keyword> class </keyword>
  <identifier> Square </identifier>
  <symbol> { </symbol>
  <classVarDec>
    <keyword> field </keyword>
    <keyword> int </keyword>
    <identifier> x </identifier>
    <symbol> , </symbol>
    <identifier> y </identifier>
    <symbol> ; </symbol>
  </classVarDec>
  <classVarDec>
    <keyword> field </keyword>
    <keyword> int </keyword>
    <identifier> size </identifier>
    <symbol> ; </symbol>
  </classVarDec>
  <subroutineDec>
    <keyword> constructor </keyword>
    <identifier> Square </identifier>
    <identifier> new </identifier>
    <symbol> ( </symbol>
    <parameterList>
      <keyword> int </keyword>
      <identifier> Ax </identifier>
      <symbol> , </symbol>
      <keyword> int </keyword>
      <identifier> Ay </identifier>
      <symbol> , </symbol>
      <keyword> int </keyword>
      <identifier> Asize </identifier>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <letStatement>
          <keyword> let </keyword>
          <identifier> x </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <identifier> Ax </identifier>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <letStatement>
          <keyword> let </keyword>
          <identifier> y </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <identifier> Ay </identifier>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <letStatement>
          <keyword> let </keyword>
          <identifier> size </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <identifier> Asize </identifier>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <doStatement>
          <keyword> do </keyword>
          <identifier> draw </identifier>
          <symbol> ( </symbol>
          <expressionList>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <returnStatement>
          <keyword> return </keyword>
          <expression>
            <term>
              <keyword> this </keyword>
            </term>
          </expression>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> dispose </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <doStatement>
          <keyword> do </keyword>
          <identifier> Memory </identifier>
          <symbol> . </symbol>
          <identifier> deAlloc </identifier>
          <symbol> ( </symbol>
          <expressionList>
            <expression>
              <term>
                <keyword> this </keyword>
              </term>
            </expression>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> draw </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <doStatement>
          <keyword> do </keyword>
          <identifier> Screen </identifier>
          <symbol> . </symbol>
          <identifier> setColor </identifier>
          <symbol> ( </symbol>
          <expressionList>
            <expression>
              <term>
                <keyword> true </keyword>
              </term>
            </expression>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <doStatement>
          <keyword> do </keyword>
          <identifier> Screen </identifier>
          <symbol> . </symbol>
          <identifier> drawRectangle </identifier>
          <symbol> ( </symbol>
          <expressionList>
            <expression>
              <term>
                <identifier> x </identifier>
              </term>
            </expression>
            <symbol> , </symbol>
            <expression>
              <term>
                <identifier> y </identifier>
              </term>
            </expression>
            <symbol> , </symbol>
            <expression>
              <term>
                <identifier> x </identifier>
              </term>
              <symbol> + </symbol>
              <term>
                <identifier> size </identifier>
              </term>
            </expression>
            <symbol> , </symbol>
            <expression>
              <term>
                <identifier> y </identifier>
              </term>
              <symbol> + </symbol>
              <term>
                <identifier> size </identifier>
              </term>
            </expression>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> erase </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <doStatement>
          <keyword> do </keyword>
          <identifier> Screen </identifier>
          <symbol> . </symbol>
          <identifier> setColor </identifier>
          <symbol> ( </symbol>
          <expressionList>
            <expression>
              <term>
                <keyword> false </keyword>
              </term>
            </expression>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <doStatement>
          <keyword> do </keyword>
          <identifier> Screen </identifier>
          <symbol> . </symbol>
          <identifier> drawRectangle </identifier>
          <symbol> ( </symbol>
          <expressionList>
            <expression>
              <term>
                <identifier> x </identifier>
              </term>
            </expression>
            <symbol> , </symbol>
            <expression>
              <term>
                <identifier> y </identifier>
              </term>
            </expression>
            <symbol> , </symbol>
            <expression>
              <term>
                <identifier> x </identifier>
              </term>
              <symbol> + </symbol>
              <term>
                <identifier> size </identifier>
              </term>
            </expression>
            <symbol> , </symbol>
            <expression>
              <term>
                <identifier> y </identifier>
              </term>
              <symbol> + </symbol>
              <term>
                <identifier> size </identifier>
              </term>
            </expression>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> incSize </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <symbol> ( </symbol>
                  <expression>
                    <term>
                      <identifier> y </identifier>
                    </term>
                    <symbol> + </symbol>
                    <term>
                      <identifier> size </identifier>
                    </term>
                  </expression>
                  <symbol> ) </symbol>
                </term>
                <symbol> &lt; </symbol>
                <term>
                  <integerConstant> 254 </integerConstant>
                </term>
              </expression>
              <symbol> ) </symbol>
            </term>
            <symbol> &amp; </symbol>
            <term>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <symbol> ( </symbol>
                  <expression>
                    <term>
                      <identifier> x </identifier>
                    </term>
                    <symbol> + </symbol>
                    <term>
                      <identifier> size </identifier>
                    </term>
                  </expression>
                  <symbol> ) </symbol>
                </term>
                <symbol> &lt; </symbol>
                <term>
                  <integerConstant> 510 </integerConstant>
                </term>
              </expression>
              <symbol> ) </symbol>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <doStatement>
              <keyword> do </keyword>
              <identifier> erase </identifier>
              <symbol> ( </symbol>
              <expressionList>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
            <letStatement>
              <keyword> let </keyword>
              <identifier> size </identifier>
              <symbol> = </symbol>
              <expression>
                <term>
                  <identifier> size </identifier>
                </term>
                <symbol> + </symbol>
                <term>
                  <integerConstant> 2 </integerConstant>
                </term>
              </expression>
              <symbol> ; </symbol>
            </letStatement>
            <doStatement>
              <keyword> do </keyword>
              <identifier> draw </identifier>
              <symbol> ( </symbol>
              <expressionList>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
          </statements>
          <symbol> } </symbol>
        </ifStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> decSize </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> size </identifier>
            </term>
            <symbol> &gt; </symbol>
            <term>
              <integerConstant> 2 </integerConstant>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <doStatement>
              <keyword> do </keyword>
              <identifier> erase </identifier>
              <symbol> ( </symbol>
              <expressionList>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
            <letStatement>
              <keyword> let </keyword>
              <identifier> size </identifier>
              <symbol> = </symbol>
              <expression>
                <term>
                  <identifier> size </identifier>
                </term>
                <symbol> - </symbol>
                <term>
                  <integerConstant> 2 </integerConstant>
                </term>
              </expression>
              <symbol> ; </symbol>
            </letStatement>
            <doStatement>
              <keyword> do </keyword>
              <identifier> draw </identifier>
              <symbol> ( </symbol>
              <expressionList>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
          </statements>
          <symbol> } </symbol>
        </ifStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> moveUp </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> y </identifier>
            </term>
            <symbol> &gt; </symbol>
            <term>
              <integerConstant> 1 </integerConstant>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> setColor </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <keyword> false </keyword>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> drawRectangle </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier> x </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <symbol> ( </symbol>
                    <expression>
                      <term>
                        <identifier> y </identifier>
                      </term>
                      <symbol> + </symbol>
                      <term>
                        <identifier> size </identifier>
                      </term>
                    </expression>
                    <symbol> ) </symbol>
                  </term>
                  <symbol> - </symbol>
                  <term>
                    <integerConstant> 1 </integerConstant>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> x </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <identifier> size </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> y </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <identifier> size </identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
            <letStatement>
              <keyword> let </keyword>
              <identifier> y </identifier>
              <symbol> = </symbol>
              <expression>
                <term>
                  <identifier> y </identifier>
                </term>
                <symbol> - </symbol>
                <term>
                  <integerConstant> 2 </integerConstant>
                </term>
              </expression>
              <symbol> ; </symbol>
            </letStatement>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> setColor </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <keyword> true </keyword>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> drawRectangle </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier> x </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> y </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> x </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <identifier> size </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> y </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <integerConstant> 1 </integerConstant>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
          </statements>
          <symbol> } </symbol>
        </ifStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> moveDown </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> y </identifier>
                </term>
                <symbol> + </symbol>
                <term>
                  <identifier> size </identifier>
                </term>
              </expression>
              <symbol> ) </symbol>
            </term>
            <symbol> &lt; </symbol>
            <term>
              <integerConstant> 254 </integerConstant>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> setColor </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <keyword> false </keyword>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> drawRectangle </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier> x </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> y </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> x </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <identifier> size </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> y </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <integerConstant> 1 </integerConstant>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
            <letStatement>
              <keyword> let </keyword>
              <identifier> y </identifier>
              <symbol> = </symbol>
              <expression>
                <term>
                  <identifier> y </identifier>
                </term>
                <symbol> + </symbol>
                <term>
                  <integerConstant> 2 </integerConstant>
                </term>
              </expression>
              <symbol> ; </symbol>
            </letStatement>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> setColor </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <keyword> true </keyword>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> drawRectangle </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier> x </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <symbol> ( </symbol>
                    <expression>
                      <term>
                        <identifier> y </identifier>
                      </term>
                      <symbol> + </symbol>
                      <term>
                        <identifier> size </identifier>
                      </term>
                    </expression>
                    <symbol> ) </symbol>
                  </term>
                  <symbol> - </symbol>
                  <term>
                    <integerConstant> 1 </integerConstant>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> x </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <identifier> size </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> y </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <identifier> size </identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
          </statements>
          <symbol> } </symbol>
        </ifStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> moveLeft </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> x </identifier>
            </term>
            <symbol> &gt; </symbol>
            <term>
              <integerConstant> 1 </integerConstant>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> setColor </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <keyword> false </keyword>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> drawRectangle </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <symbol> ( </symbol>
                    <expression>
                      <term>
                        <identifier> x </identifier>
                      </term>
                      <symbol> + </symbol>
                      <term>
                        <identifier> size </identifier>
                      </term>
                    </expression>
                    <symbol> ) </symbol>
                  </term>
                  <symbol> - </symbol>
                  <term>
                    <integerConstant> 1 </integerConstant>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> y </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> x </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <identifier> size </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> y </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <identifier> size </identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
            <letStatement>
              <keyword> let </keyword>
              <identifier> x </identifier>
              <symbol> = </symbol>
              <expression>
                <term>
                  <identifier> x </identifier>
                </term>
                <symbol> - </symbol>
                <term>
                  <integerConstant> 2 </integerConstant>
                </term>
              </expression>
              <symbol> ; </symbol>
            </letStatement>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> setColor </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <keyword> true </keyword>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> drawRectangle </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier> x </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> y </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> x </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <integerConstant> 1 </integerConstant>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> y </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <identifier> size </identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
          </statements>
          <symbol> } </symbol>
        </ifStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> moveRight </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> x </identifier>
                </term>
                <symbol> + </symbol>
                <term>
                  <identifier> size </identifier>
                </term>
              </expression>
              <symbol> ) </symbol>
            </term>
            <symbol> &lt; </symbol>
            <term>
              <integerConstant> 510 </integerConstant>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> setColor </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <keyword> false </keyword>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> drawRectangle </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier> x </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> y </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> x </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <integerConstant> 1 </integerConstant>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> y </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <identifier> size </identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
            <letStatement>
              <keyword> let </keyword>
              <identifier> x </identifier>
              <symbol> = </symbol>
              <expression>
                <term>
                  <identifier> x </identifier>
                </term>
                <symbol> + </symbol>
                <term>
                  <integerConstant> 2 </integerConstant>
                </term>
              </expression>
              <symbol> ; </symbol>
            </letStatement>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> setColor </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <keyword> true </keyword>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
            <doStatement>
              <keyword> do </keyword>
              <identifier> Screen </identifier>
              <symbol> . </symbol>
              <identifier> drawRectangle </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <symbol> ( </symbol>
                    <expression>
                      <term>
                        <identifier> x </identifier>
                      </term>
                      <symbol> + </symbol>
                      <term>
                        <identifier> size </identifier>
                      </term>
                    </expression>
                    <symbol> ) </symbol>
                  </term>
                  <symbol> - </symbol>
                  <term>
                    <integerConstant> 1 </integerConstant>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> y </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> x </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <identifier> size </identifier>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <identifier> y </identifier>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <identifier> size </identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
          </statements>
          <symbol> } </symbol>
        </ifStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <symbol> } </symbol>
</class>
    EOXML

    difftest(input, expected)
  end

  it "parses ExpressionlessSquare::SquareDance" do
    input =<<-EOJACK
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
    EOJACK

    expected =<<-EOXML
<class>
  <keyword> class </keyword>
  <identifier> SquareGame </identifier>
  <symbol> { </symbol>
  <classVarDec>
    <keyword> field </keyword>
    <identifier> Square </identifier>
    <identifier> square </identifier>
    <symbol> ; </symbol>
  </classVarDec>
  <classVarDec>
    <keyword> field </keyword>
    <keyword> int </keyword>
    <identifier> direction </identifier>
    <symbol> ; </symbol>
  </classVarDec>
  <subroutineDec>
    <keyword> constructor </keyword>
    <identifier> SquareGame </identifier>
    <identifier> new </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <letStatement>
          <keyword> let </keyword>
          <identifier> square </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <identifier> Square </identifier>
              <symbol> . </symbol>
              <identifier> new </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <integerConstant> 0 </integerConstant>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <integerConstant> 0 </integerConstant>
                  </term>
                </expression>
                <symbol> , </symbol>
                <expression>
                  <term>
                    <integerConstant> 30 </integerConstant>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <letStatement>
          <keyword> let </keyword>
          <identifier> direction </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <integerConstant> 0 </integerConstant>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <returnStatement>
          <keyword> return </keyword>
          <expression>
            <term>
              <keyword> this </keyword>
            </term>
          </expression>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> dispose </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <doStatement>
          <keyword> do </keyword>
          <identifier> square </identifier>
          <symbol> . </symbol>
          <identifier> dispose </identifier>
          <symbol> ( </symbol>
          <expressionList>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <doStatement>
          <keyword> do </keyword>
          <identifier> Memory </identifier>
          <symbol> . </symbol>
          <identifier> deAlloc </identifier>
          <symbol> ( </symbol>
          <expressionList>
            <expression>
              <term>
                <keyword> this </keyword>
              </term>
            </expression>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> run </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <varDec>
        <keyword> var </keyword>
        <keyword> char </keyword>
        <identifier> key </identifier>
        <symbol> ; </symbol>
      </varDec>
      <varDec>
        <keyword> var </keyword>
        <keyword> boolean </keyword>
        <identifier> exit </identifier>
        <symbol> ; </symbol>
      </varDec>
      <statements>
        <letStatement>
          <keyword> let </keyword>
          <identifier> exit </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <keyword> false </keyword>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <whileStatement>
          <keyword> while </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <symbol> ~ </symbol>
              <term>
                <identifier> exit </identifier>
              </term>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <whileStatement>
              <keyword> while </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
                <symbol> = </symbol>
                <term>
                  <integerConstant> 0 </integerConstant>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <letStatement>
                  <keyword> let </keyword>
                  <identifier> key </identifier>
                  <symbol> = </symbol>
                  <expression>
                    <term>
                      <identifier> Keyboard </identifier>
                      <symbol> . </symbol>
                      <identifier> keyPressed </identifier>
                      <symbol> ( </symbol>
                      <expressionList>
                      </expressionList>
                      <symbol> ) </symbol>
                    </term>
                  </expression>
                  <symbol> ; </symbol>
                </letStatement>
                <doStatement>
                  <keyword> do </keyword>
                  <identifier> moveSquare </identifier>
                  <symbol> ( </symbol>
                  <expressionList>
                  </expressionList>
                  <symbol> ) </symbol>
                  <symbol> ; </symbol>
                </doStatement>
              </statements>
              <symbol> } </symbol>
            </whileStatement>
            <ifStatement>
              <keyword> if </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
                <symbol> = </symbol>
                <term>
                  <integerConstant> 81 </integerConstant>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <letStatement>
                  <keyword> let </keyword>
                  <identifier> exit </identifier>
                  <symbol> = </symbol>
                  <expression>
                    <term>
                      <keyword> true </keyword>
                    </term>
                  </expression>
                  <symbol> ; </symbol>
                </letStatement>
              </statements>
              <symbol> } </symbol>
            </ifStatement>
            <ifStatement>
              <keyword> if </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
                <symbol> = </symbol>
                <term>
                  <integerConstant> 90 </integerConstant>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <doStatement>
                  <keyword> do </keyword>
                  <identifier> square </identifier>
                  <symbol> . </symbol>
                  <identifier> decSize </identifier>
                  <symbol> ( </symbol>
                  <expressionList>
                  </expressionList>
                  <symbol> ) </symbol>
                  <symbol> ; </symbol>
                </doStatement>
              </statements>
              <symbol> } </symbol>
            </ifStatement>
            <ifStatement>
              <keyword> if </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
                <symbol> = </symbol>
                <term>
                  <integerConstant> 88 </integerConstant>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <doStatement>
                  <keyword> do </keyword>
                  <identifier> square </identifier>
                  <symbol> . </symbol>
                  <identifier> incSize </identifier>
                  <symbol> ( </symbol>
                  <expressionList>
                  </expressionList>
                  <symbol> ) </symbol>
                  <symbol> ; </symbol>
                </doStatement>
              </statements>
              <symbol> } </symbol>
            </ifStatement>
            <ifStatement>
              <keyword> if </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
                <symbol> = </symbol>
                <term>
                  <integerConstant> 131 </integerConstant>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <letStatement>
                  <keyword> let </keyword>
                  <identifier> direction </identifier>
                  <symbol> = </symbol>
                  <expression>
                    <term>
                      <integerConstant> 1 </integerConstant>
                    </term>
                  </expression>
                  <symbol> ; </symbol>
                </letStatement>
              </statements>
              <symbol> } </symbol>
            </ifStatement>
            <ifStatement>
              <keyword> if </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
                <symbol> = </symbol>
                <term>
                  <integerConstant> 133 </integerConstant>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <letStatement>
                  <keyword> let </keyword>
                  <identifier> direction </identifier>
                  <symbol> = </symbol>
                  <expression>
                    <term>
                      <integerConstant> 2 </integerConstant>
                    </term>
                  </expression>
                  <symbol> ; </symbol>
                </letStatement>
              </statements>
              <symbol> } </symbol>
            </ifStatement>
            <ifStatement>
              <keyword> if </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
                <symbol> = </symbol>
                <term>
                  <integerConstant> 130 </integerConstant>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <letStatement>
                  <keyword> let </keyword>
                  <identifier> direction </identifier>
                  <symbol> = </symbol>
                  <expression>
                    <term>
                      <integerConstant> 3 </integerConstant>
                    </term>
                  </expression>
                  <symbol> ; </symbol>
                </letStatement>
              </statements>
              <symbol> } </symbol>
            </ifStatement>
            <ifStatement>
              <keyword> if </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <identifier> key </identifier>
                </term>
                <symbol> = </symbol>
                <term>
                  <integerConstant> 132 </integerConstant>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <letStatement>
                  <keyword> let </keyword>
                  <identifier> direction </identifier>
                  <symbol> = </symbol>
                  <expression>
                    <term>
                      <integerConstant> 4 </integerConstant>
                    </term>
                  </expression>
                  <symbol> ; </symbol>
                </letStatement>
              </statements>
              <symbol> } </symbol>
            </ifStatement>
            <whileStatement>
              <keyword> while </keyword>
              <symbol> ( </symbol>
              <expression>
                <term>
                  <symbol> ~ </symbol>
                  <term>
                    <symbol> ( </symbol>
                    <expression>
                      <term>
                        <identifier> key </identifier>
                      </term>
                      <symbol> = </symbol>
                      <term>
                        <integerConstant> 0 </integerConstant>
                      </term>
                    </expression>
                    <symbol> ) </symbol>
                  </term>
                </term>
              </expression>
              <symbol> ) </symbol>
              <symbol> { </symbol>
              <statements>
                <letStatement>
                  <keyword> let </keyword>
                  <identifier> key </identifier>
                  <symbol> = </symbol>
                  <expression>
                    <term>
                      <identifier> Keyboard </identifier>
                      <symbol> . </symbol>
                      <identifier> keyPressed </identifier>
                      <symbol> ( </symbol>
                      <expressionList>
                      </expressionList>
                      <symbol> ) </symbol>
                    </term>
                  </expression>
                  <symbol> ; </symbol>
                </letStatement>
                <doStatement>
                  <keyword> do </keyword>
                  <identifier> moveSquare </identifier>
                  <symbol> ( </symbol>
                  <expressionList>
                  </expressionList>
                  <symbol> ) </symbol>
                  <symbol> ; </symbol>
                </doStatement>
              </statements>
              <symbol> } </symbol>
            </whileStatement>
          </statements>
          <symbol> } </symbol>
        </whileStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <subroutineDec>
    <keyword> method </keyword>
    <keyword> void </keyword>
    <identifier> moveSquare </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> direction </identifier>
            </term>
            <symbol> = </symbol>
            <term>
              <integerConstant> 1 </integerConstant>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <doStatement>
              <keyword> do </keyword>
              <identifier> square </identifier>
              <symbol> . </symbol>
              <identifier> moveUp </identifier>
              <symbol> ( </symbol>
              <expressionList>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
          </statements>
          <symbol> } </symbol>
        </ifStatement>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> direction </identifier>
            </term>
            <symbol> = </symbol>
            <term>
              <integerConstant> 2 </integerConstant>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <doStatement>
              <keyword> do </keyword>
              <identifier> square </identifier>
              <symbol> . </symbol>
              <identifier> moveDown </identifier>
              <symbol> ( </symbol>
              <expressionList>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
          </statements>
          <symbol> } </symbol>
        </ifStatement>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> direction </identifier>
            </term>
            <symbol> = </symbol>
            <term>
              <integerConstant> 3 </integerConstant>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <doStatement>
              <keyword> do </keyword>
              <identifier> square </identifier>
              <symbol> . </symbol>
              <identifier> moveLeft </identifier>
              <symbol> ( </symbol>
              <expressionList>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
          </statements>
          <symbol> } </symbol>
        </ifStatement>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> direction </identifier>
            </term>
            <symbol> = </symbol>
            <term>
              <integerConstant> 4 </integerConstant>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <doStatement>
              <keyword> do </keyword>
              <identifier> square </identifier>
              <symbol> . </symbol>
              <identifier> moveRight </identifier>
              <symbol> ( </symbol>
              <expressionList>
              </expressionList>
              <symbol> ) </symbol>
              <symbol> ; </symbol>
            </doStatement>
          </statements>
          <symbol> } </symbol>
        </ifStatement>
        <doStatement>
          <keyword> do </keyword>
          <identifier> Sys </identifier>
          <symbol> . </symbol>
          <identifier> wait </identifier>
          <symbol> ( </symbol>
          <expressionList>
            <expression>
              <term>
                <integerConstant> 5 </integerConstant>
              </term>
            </expression>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <symbol> } </symbol>
</class>
    EOXML

    difftest(input, expected)
  end

  it "parses ExpressionlessSquare::Main" do
    input =<<-EOJACK
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/10/ArrayTest/Main.jack

/** Computes the average of a sequence of integers. */
class Main {
    function void main() {
        var Array a;
        var int length;
    var int i, sum;

    let length = Keyboard.readInt("HOW MANY NUMBERS? ");
    let a = Array.new(length);
    let i = 0;

    while (i < length) {
          let a[i] = Keyboard.readInt("ENTER THE NEXT NUMBER: ");
        let i = i + 1;
    }

    let i = 0;
    let sum = 0;

    while (i < length) {
        let sum = sum + a[i];
        let i = i + 1;
    }

    do Output.printString("THE AVERAGE IS: ");
    do Output.printInt(sum / length);
    do Output.println();

    return;
    }
}
    EOJACK

    expected =<<-EOXML
<class>
  <keyword> class </keyword>
  <identifier> Main </identifier>
  <symbol> { </symbol>
  <subroutineDec>
    <keyword> function </keyword>
    <keyword> void </keyword>
    <identifier> main </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <varDec>
        <keyword> var </keyword>
        <identifier> Array </identifier>
        <identifier> a </identifier>
        <symbol> ; </symbol>
      </varDec>
      <varDec>
        <keyword> var </keyword>
        <keyword> int </keyword>
        <identifier> length </identifier>
        <symbol> ; </symbol>
      </varDec>
      <varDec>
        <keyword> var </keyword>
        <keyword> int </keyword>
        <identifier> i </identifier>
        <symbol> , </symbol>
        <identifier> sum </identifier>
        <symbol> ; </symbol>
      </varDec>
      <statements>
        <letStatement>
          <keyword> let </keyword>
          <identifier> length </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <identifier> Keyboard </identifier>
              <symbol> . </symbol>
              <identifier> readInt </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <stringConstant> HOW MANY NUMBERS?  </stringConstant>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <letStatement>
          <keyword> let </keyword>
          <identifier> a </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <identifier> Array </identifier>
              <symbol> . </symbol>
              <identifier> new </identifier>
              <symbol> ( </symbol>
              <expressionList>
                <expression>
                  <term>
                    <identifier> length </identifier>
                  </term>
                </expression>
              </expressionList>
              <symbol> ) </symbol>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <letStatement>
          <keyword> let </keyword>
          <identifier> i </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <integerConstant> 0 </integerConstant>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <whileStatement>
          <keyword> while </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> i </identifier>
            </term>
            <symbol> &lt; </symbol>
            <term>
              <identifier> length </identifier>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <letStatement>
              <keyword> let </keyword>
              <identifier> a </identifier>
              <symbol> [ </symbol>
              <expression>
                <term>
                  <identifier> i </identifier>
                </term>
              </expression>
              <symbol> ] </symbol>
              <symbol> = </symbol>
              <expression>
                <term>
                  <identifier> Keyboard </identifier>
                  <symbol> . </symbol>
                  <identifier> readInt </identifier>
                  <symbol> ( </symbol>
                  <expressionList>
                    <expression>
                      <term>
                        <stringConstant> ENTER THE NEXT NUMBER:  </stringConstant>
                      </term>
                    </expression>
                  </expressionList>
                  <symbol> ) </symbol>
                </term>
              </expression>
              <symbol> ; </symbol>
            </letStatement>
            <letStatement>
              <keyword> let </keyword>
              <identifier> i </identifier>
              <symbol> = </symbol>
              <expression>
                <term>
                  <identifier> i </identifier>
                </term>
                <symbol> + </symbol>
                <term>
                  <integerConstant> 1 </integerConstant>
                </term>
              </expression>
              <symbol> ; </symbol>
            </letStatement>
          </statements>
          <symbol> } </symbol>
        </whileStatement>
        <letStatement>
          <keyword> let </keyword>
          <identifier> i </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <integerConstant> 0 </integerConstant>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <letStatement>
          <keyword> let </keyword>
          <identifier> sum </identifier>
          <symbol> = </symbol>
          <expression>
            <term>
              <integerConstant> 0 </integerConstant>
            </term>
          </expression>
          <symbol> ; </symbol>
        </letStatement>
        <whileStatement>
          <keyword> while </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> i </identifier>
            </term>
            <symbol> &lt; </symbol>
            <term>
              <identifier> length </identifier>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <letStatement>
              <keyword> let </keyword>
              <identifier> sum </identifier>
              <symbol> = </symbol>
              <expression>
                <term>
                  <identifier> sum </identifier>
                </term>
                <symbol> + </symbol>
                <term>
                  <identifier> a </identifier>
                  <symbol> [ </symbol>
                  <expression>
                    <term>
                      <identifier> i </identifier>
                    </term>
                  </expression>
                  <symbol> ] </symbol>
                </term>
              </expression>
              <symbol> ; </symbol>
            </letStatement>
            <letStatement>
              <keyword> let </keyword>
              <identifier> i </identifier>
              <symbol> = </symbol>
              <expression>
                <term>
                  <identifier> i </identifier>
                </term>
                <symbol> + </symbol>
                <term>
                  <integerConstant> 1 </integerConstant>
                </term>
              </expression>
              <symbol> ; </symbol>
            </letStatement>
          </statements>
          <symbol> } </symbol>
        </whileStatement>
        <doStatement>
          <keyword> do </keyword>
          <identifier> Output </identifier>
          <symbol> . </symbol>
          <identifier> printString </identifier>
          <symbol> ( </symbol>
          <expressionList>
            <expression>
              <term>
                <stringConstant> THE AVERAGE IS:  </stringConstant>
              </term>
            </expression>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <doStatement>
          <keyword> do </keyword>
          <identifier> Output </identifier>
          <symbol> . </symbol>
          <identifier> printInt </identifier>
          <symbol> ( </symbol>
          <expressionList>
            <expression>
              <term>
                <identifier> sum </identifier>
              </term>
              <symbol> / </symbol>
              <term>
                <identifier> length </identifier>
              </term>
            </expression>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <doStatement>
          <keyword> do </keyword>
          <identifier> Output </identifier>
          <symbol> . </symbol>
          <identifier> println </identifier>
          <symbol> ( </symbol>
          <expressionList>
          </expressionList>
          <symbol> ) </symbol>
          <symbol> ; </symbol>
        </doStatement>
        <returnStatement>
          <keyword> return </keyword>
          <symbol> ; </symbol>
        </returnStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <symbol> } </symbol>
</class>
    EOXML

    difftest(input, expected)
  end

  it "parses the remaining grammar" do
    input =<<-EOJACK
// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/10/ArrayTest/Main.jack

/** Computes the average of a sequence of integers. */
class Main {
    function void main() {
      // This is nonsense just to test extra things
      if (i < 4) {
        let i = i * a[-2];
        return false;
      } else {
        let i = -i | 4 + 1;
        let i = this / null;
        return true;
      }
    }
}
    EOJACK

    expected =<<-EOXML
<class>
  <keyword> class </keyword>
  <identifier> Main </identifier>
  <symbol> { </symbol>
  <subroutineDec>
    <keyword> function </keyword>
    <keyword> void </keyword>
    <identifier> main </identifier>
    <symbol> ( </symbol>
    <parameterList>
    </parameterList>
    <symbol> ) </symbol>
    <subroutineBody>
      <symbol> { </symbol>
      <statements>
        <ifStatement>
          <keyword> if </keyword>
          <symbol> ( </symbol>
          <expression>
            <term>
              <identifier> i </identifier>
            </term>
            <symbol> &lt; </symbol>
            <term>
              <int_const> 4 </int_const>
            </term>
          </expression>
          <symbol> ) </symbol>
          <symbol> { </symbol>
          <statements>
            <letStatement>
              <keyword> let </keyword>
              <identifier> i </identifier>
              <symbol> = </symbol>
              <expression>
                <term>
                  <identifier> i </identifier>
                </term>
                <symbol> * </symbol>
                <term>
                  <identifier> a </identifier>
                  <symbol> [ </symbol>
                  <expression>
                    <term>
                      <symbol> - </symbol>
                      <term>
                        <int_const> 2 </int_const>
                      </term>
                    </term>
                  </expression>
                  <symbol> ] </symbol>
                </term>
              </expression>
              <symbol> ; </symbol>
            </letStatement>
            <returnStatement>
              <keyword>return</keyword>
              <expression>
                <term>
                  <keyword>false</keyword>
                </term>
              </expression>
              <symbol> ; </symbol>
            </returnStatement>
          </statements>
          <symbol> } </symbol>
          <keyword> else </keyword>
          <symbol> { </symbol>
            <statements>
              <letStatement>
                <keyword> let </keyword>
                <identifier> i </identifier>
                <symbol> = </symbol>
                <expression>
                  <term>
                    <symbol> - </symbol>
                    <term>
                      <identifier> i </identifier>
                    </term>
                  </term>
                  <symbol> | </symbol>
                  <term>
                    <int_const> 4 </int_const>
                  </term>
                  <symbol> + </symbol>
                  <term>
                    <int_const> 1 </int_const>
                  </term>
                </expression>
                <symbol> ; </symbol>
              </letStatement>
              <letStatement>
                <keyword> let </keyword>
                <identifier> i </identifier>
                <symbol> = </symbol>
                <expression>
                  <term>
                    <keyword> this </keyword>
                  </term>
                  <symbol> / </symbol>
                  <term>
                    <keyword> null </keyword>
                  </term>
                </expression>
                <symbol> ; </symbol>
              </letStatement>
              <returnStatement>
                <keyword>return</keyword>
                <expression>
                  <term>
                    <keyword>true</keyword>
                  </term>
                </expression>
                <symbol> ; </symbol>
              </returnStatement>
            </statements>
          <symbol> } </symbol>
        </ifStatement>
      </statements>
      <symbol> } </symbol>
    </subroutineBody>
  </subroutineDec>
  <symbol> } </symbol>
</class>
    EOXML

    difftest(input, expected)
  end

  def difftest(input, expected)
    tokenizer = Tokenizer.new(input)
    actual = StringIO.new

    parser = Parser.new(tokenizer, actual)
    begin
      parser.compile_class
    rescue
      puts nil, actual.string, nil
      raise
    end

    actual.string.lines.zip(expected.lines) do |a, e|
      e.gsub!(/> /, ">")
      e.gsub!(/ </, "<")
      e.gsub!(/integerConstant/, "int_const")
      e.gsub!(/stringConstant/, "string_const")
      e.strip!
      a.strip!
      expect(a).to eq(e)#, "'#{a}' != '#{e}' in: #{actual.string}"
    end
  end
end
