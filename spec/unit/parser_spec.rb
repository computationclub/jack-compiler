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
      e.gsub!(/>\s+/, ">")
      e.gsub!(/\s+</, "<")
      a.strip!
      expect(a).to eq(e), "'#{a}' != '#{e}' in: #{actual.string}"
    end
  end
end
