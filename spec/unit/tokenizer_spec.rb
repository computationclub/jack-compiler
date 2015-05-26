require 'tokenizer'

RSpec.describe Tokenizer do
  it "tokenizes ArrayTest" do
    input = <<-EOJACK
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

    expected = [
      [:keyword, "class"],
      [:identifier, "Main"],
      [:symbol, "{"],
      [:keyword, "function"],
      [:keyword, "void"],
      [:identifier, "main"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "var"],
      [:identifier, "Array"],
      [:identifier, "a"],
      [:symbol, ";"],
      [:keyword, "var"],
      [:keyword, "int"],
      [:identifier, "length"],
      [:symbol, ";"],
      [:keyword, "var"],
      [:keyword, "int"],
      [:identifier, "i"],
      [:symbol, ","],
      [:identifier, "sum"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "length"],
      [:symbol, "="],
      [:identifier, "Keyboard"],
      [:symbol, "."],
      [:identifier, "readInt"],
      [:symbol, "("],
      [:stringConstant, "HOW MANY NUMBERS? "],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "a"],
      [:symbol, "="],
      [:identifier, "Array"],
      [:symbol, "."],
      [:identifier, "new"],
      [:symbol, "("],
      [:identifier, "length"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "i"],
      [:symbol, "="],
      [:integerConstant, "0"],
      [:symbol, ";"],
      [:keyword, "while"],
      [:symbol, "("],
      [:identifier, "i"],
      [:symbol, "<"],
      [:identifier, "length"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "let"],
      [:identifier, "a"],
      [:symbol, "["],
      [:identifier, "i"],
      [:symbol, "]"],
      [:symbol, "="],
      [:identifier, "Keyboard"],
      [:symbol, "."],
      [:identifier, "readInt"],
      [:symbol, "("],
      [:stringConstant, "ENTER THE NEXT NUMBER: "],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "i"],
      [:symbol, "="],
      [:identifier, "i"],
      [:symbol, "+"],
      [:integerConstant, "1"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "let"],
      [:identifier, "i"],
      [:symbol, "="],
      [:integerConstant, "0"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "sum"],
      [:symbol, "="],
      [:integerConstant, "0"],
      [:symbol, ";"],
      [:keyword, "while"],
      [:symbol, "("],
      [:identifier, "i"],
      [:symbol, "<"],
      [:identifier, "length"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "let"],
      [:identifier, "sum"],
      [:symbol, "="],
      [:identifier, "sum"],
      [:symbol, "+"],
      [:identifier, "a"],
      [:symbol, "["],
      [:identifier, "i"],
      [:symbol, "]"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "i"],
      [:symbol, "="],
      [:identifier, "i"],
      [:symbol, "+"],
      [:integerConstant, "1"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "do"],
      [:identifier, "Output"],
      [:symbol, "."],
      [:identifier, "printString"],
      [:symbol, "("],
      [:stringConstant, "THE AVERAGE IS: "],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Output"],
      [:symbol, "."],
      [:identifier, "printInt"],
      [:symbol, "("],
      [:identifier, "sum"],
      [:symbol, "/"],
      [:identifier, "length"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Output"],
      [:symbol, "."],
      [:identifier, "println"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "return"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:symbol, "}"]
    ]

    tokenizer = Tokenizer.new(input)

    while tokenizer.has_more_tokens?
      tokenizer.advance

      actual = case tokenizer.token_type
      when Tokenizer::KEYWORD
        [:keyword, tokenizer.keyword]
      when Tokenizer::SYMBOL
        [:symbol, tokenizer.symbol]
      when Tokenizer::IDENTIFIER
        [:identifier, tokenizer.identifier]
      when Tokenizer::INT_CONST
        [:integerConstant, tokenizer.int_val]
      when Tokenizer::STRING_CONST
        [:stringConstant, tokenizer.string_val]
      end

      expect(actual).to eq(expected.shift)
    end

    expect(expected).to be_empty
  end

  it "tokenizes SquareGame" do
    input = <<-EOJACK
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

    expected = [
      [:keyword, "class"],
      [:identifier, "SquareGame"],
      [:symbol, "{"],
      [:keyword, "field"],
      [:identifier, "Square"],
      [:identifier, "square"],
      [:symbol, ";"],
      [:keyword, "field"],
      [:keyword, "int"],
      [:identifier, "direction"],
      [:symbol, ";"],
      [:keyword, "constructor"],
      [:identifier, "SquareGame"],
      [:identifier, "new"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "let"],
      [:identifier, "square"],
      [:symbol, "="],
      [:identifier, "Square"],
      [:symbol, "."],
      [:identifier, "new"],
      [:symbol, "("],
      [:integerConstant, "0"],
      [:symbol, ","],
      [:integerConstant, "0"],
      [:symbol, ","],
      [:integerConstant, "30"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "direction"],
      [:symbol, "="],
      [:integerConstant, "0"],
      [:symbol, ";"],
      [:keyword, "return"],
      [:keyword, "this"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "method"],
      [:keyword, "void"],
      [:identifier, "dispose"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "square"],
      [:symbol, "."],
      [:identifier, "dispose"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Memory"],
      [:symbol, "."],
      [:identifier, "deAlloc"],
      [:symbol, "("],
      [:keyword, "this"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "return"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "method"],
      [:keyword, "void"],
      [:identifier, "run"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "var"],
      [:keyword, "char"],
      [:identifier, "key"],
      [:symbol, ";"],
      [:keyword, "var"],
      [:keyword, "boolean"],
      [:identifier, "exit"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "exit"],
      [:symbol, "="],
      [:keyword, "false"],
      [:symbol, ";"],
      [:keyword, "while"],
      [:symbol, "("],
      [:symbol, "~"],
      [:identifier, "exit"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "while"],
      [:symbol, "("],
      [:identifier, "key"],
      [:symbol, "="],
      [:integerConstant, "0"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "let"],
      [:identifier, "key"],
      [:symbol, "="],
      [:identifier, "Keyboard"],
      [:symbol, "."],
      [:identifier, "keyPressed"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "moveSquare"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "if"],
      [:symbol, "("],
      [:identifier, "key"],
      [:symbol, "="],
      [:integerConstant, "81"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "let"],
      [:identifier, "exit"],
      [:symbol, "="],
      [:keyword, "true"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "if"],
      [:symbol, "("],
      [:identifier, "key"],
      [:symbol, "="],
      [:integerConstant, "90"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "square"],
      [:symbol, "."],
      [:identifier, "decSize"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "if"],
      [:symbol, "("],
      [:identifier, "key"],
      [:symbol, "="],
      [:integerConstant, "88"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "square"],
      [:symbol, "."],
      [:identifier, "incSize"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "if"],
      [:symbol, "("],
      [:identifier, "key"],
      [:symbol, "="],
      [:integerConstant, "131"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "let"],
      [:identifier, "direction"],
      [:symbol, "="],
      [:integerConstant, "1"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "if"],
      [:symbol, "("],
      [:identifier, "key"],
      [:symbol, "="],
      [:integerConstant, "133"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "let"],
      [:identifier, "direction"],
      [:symbol, "="],
      [:integerConstant, "2"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "if"],
      [:symbol, "("],
      [:identifier, "key"],
      [:symbol, "="],
      [:integerConstant, "130"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "let"],
      [:identifier, "direction"],
      [:symbol, "="],
      [:integerConstant, "3"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "if"],
      [:symbol, "("],
      [:identifier, "key"],
      [:symbol, "="],
      [:integerConstant, "132"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "let"],
      [:identifier, "direction"],
      [:symbol, "="],
      [:integerConstant, "4"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "while"],
      [:symbol, "("],
      [:symbol, "~"],
      [:symbol, "("],
      [:identifier, "key"],
      [:symbol, "="],
      [:integerConstant, "0"],
      [:symbol, ")"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "let"],
      [:identifier, "key"],
      [:symbol, "="],
      [:identifier, "Keyboard"],
      [:symbol, "."],
      [:identifier, "keyPressed"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "moveSquare"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:symbol, "}"],
      [:keyword, "return"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "method"],
      [:keyword, "void"],
      [:identifier, "moveSquare"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "if"],
      [:symbol, "("],
      [:identifier, "direction"],
      [:symbol, "="],
      [:integerConstant, "1"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "square"],
      [:symbol, "."],
      [:identifier, "moveUp"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "if"],
      [:symbol, "("],
      [:identifier, "direction"],
      [:symbol, "="],
      [:integerConstant, "2"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "square"],
      [:symbol, "."],
      [:identifier, "moveDown"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "if"],
      [:symbol, "("],
      [:identifier, "direction"],
      [:symbol, "="],
      [:integerConstant, "3"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "square"],
      [:symbol, "."],
      [:identifier, "moveLeft"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "if"],
      [:symbol, "("],
      [:identifier, "direction"],
      [:symbol, "="],
      [:integerConstant, "4"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "square"],
      [:symbol, "."],
      [:identifier, "moveRight"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "do"],
      [:identifier, "Sys"],
      [:symbol, "."],
      [:identifier, "wait"],
      [:symbol, "("],
      [:integerConstant, "5"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "return"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:symbol, "}"]
    ]

    tokenizer = Tokenizer.new(input)

    while tokenizer.has_more_tokens?
      tokenizer.advance

      actual = case tokenizer.token_type
      when Tokenizer::KEYWORD
        [:keyword, tokenizer.keyword]
      when Tokenizer::SYMBOL
        [:symbol, tokenizer.symbol]
      when Tokenizer::IDENTIFIER
        [:identifier, tokenizer.identifier]
      when Tokenizer::INT_CONST
        [:integerConstant, tokenizer.int_val]
      when Tokenizer::STRING_CONST
        [:stringConstant, tokenizer.string_val]
      end

      expect(actual).to eq(expected.shift)
    end

    expect(expected).to be_empty
  end

  it "tokenizes Square" do
    input = <<-EOJACK
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

    expected = [
      [:keyword, "class"],
      [:identifier, "Square"],
      [:symbol, "{"],
      [:keyword, "field"],
      [:keyword, "int"],
      [:identifier, "x"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, ";"],
      [:keyword, "field"],
      [:keyword, "int"],
      [:identifier, "size"],
      [:symbol, ";"],
      [:keyword, "constructor"],
      [:identifier, "Square"],
      [:identifier, "new"],
      [:symbol, "("],
      [:keyword, "int"],
      [:identifier, "Ax"],
      [:symbol, ","],
      [:keyword, "int"],
      [:identifier, "Ay"],
      [:symbol, ","],
      [:keyword, "int"],
      [:identifier, "Asize"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "let"],
      [:identifier, "x"],
      [:symbol, "="],
      [:identifier, "Ax"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "y"],
      [:symbol, "="],
      [:identifier, "Ay"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "size"],
      [:symbol, "="],
      [:identifier, "Asize"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "draw"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "return"],
      [:keyword, "this"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "method"],
      [:keyword, "void"],
      [:identifier, "dispose"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "Memory"],
      [:symbol, "."],
      [:identifier, "deAlloc"],
      [:symbol, "("],
      [:keyword, "this"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "return"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "method"],
      [:keyword, "void"],
      [:identifier, "draw"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "setColor"],
      [:symbol, "("],
      [:keyword, "true"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "drawRectangle"],
      [:symbol, "("],
      [:identifier, "x"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, ","],
      [:identifier, "x"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "return"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "method"],
      [:keyword, "void"],
      [:identifier, "erase"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "setColor"],
      [:symbol, "("],
      [:keyword, "false"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "drawRectangle"],
      [:symbol, "("],
      [:identifier, "x"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, ","],
      [:identifier, "x"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "return"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "method"],
      [:keyword, "void"],
      [:identifier, "incSize"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "if"],
      [:symbol, "("],
      [:symbol, "("],
      [:symbol, "("],
      [:identifier, "y"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, "<"],
      [:integerConstant, "254"],
      [:symbol, ")"],
      [:symbol, "&"],
      [:symbol, "("],
      [:symbol, "("],
      [:identifier, "x"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, "<"],
      [:integerConstant, "510"],
      [:symbol, ")"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "erase"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "size"],
      [:symbol, "="],
      [:identifier, "size"],
      [:symbol, "+"],
      [:integerConstant, "2"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "draw"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "return"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "method"],
      [:keyword, "void"],
      [:identifier, "decSize"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "if"],
      [:symbol, "("],
      [:identifier, "size"],
      [:symbol, ">"],
      [:integerConstant, "2"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "erase"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "size"],
      [:symbol, "="],
      [:identifier, "size"],
      [:symbol, "-"],
      [:integerConstant, "2"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "draw"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "return"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "method"],
      [:keyword, "void"],
      [:identifier, "moveUp"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "if"],
      [:symbol, "("],
      [:identifier, "y"],
      [:symbol, ">"],
      [:integerConstant, "1"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "setColor"],
      [:symbol, "("],
      [:keyword, "false"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "drawRectangle"],
      [:symbol, "("],
      [:identifier, "x"],
      [:symbol, ","],
      [:symbol, "("],
      [:identifier, "y"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, "-"],
      [:integerConstant, "1"],
      [:symbol, ","],
      [:identifier, "x"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "y"],
      [:symbol, "="],
      [:identifier, "y"],
      [:symbol, "-"],
      [:integerConstant, "2"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "setColor"],
      [:symbol, "("],
      [:keyword, "true"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "drawRectangle"],
      [:symbol, "("],
      [:identifier, "x"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, ","],
      [:identifier, "x"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, "+"],
      [:integerConstant, "1"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "return"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "method"],
      [:keyword, "void"],
      [:identifier, "moveDown"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "if"],
      [:symbol, "("],
      [:symbol, "("],
      [:identifier, "y"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, "<"],
      [:integerConstant, "254"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "setColor"],
      [:symbol, "("],
      [:keyword, "false"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "drawRectangle"],
      [:symbol, "("],
      [:identifier, "x"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, ","],
      [:identifier, "x"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, "+"],
      [:integerConstant, "1"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "y"],
      [:symbol, "="],
      [:identifier, "y"],
      [:symbol, "+"],
      [:integerConstant, "2"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "setColor"],
      [:symbol, "("],
      [:keyword, "true"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "drawRectangle"],
      [:symbol, "("],
      [:identifier, "x"],
      [:symbol, ","],
      [:symbol, "("],
      [:identifier, "y"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, "-"],
      [:integerConstant, "1"],
      [:symbol, ","],
      [:identifier, "x"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "return"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "method"],
      [:keyword, "void"],
      [:identifier, "moveLeft"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "if"],
      [:symbol, "("],
      [:identifier, "x"],
      [:symbol, ">"],
      [:integerConstant, "1"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "setColor"],
      [:symbol, "("],
      [:keyword, "false"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "drawRectangle"],
      [:symbol, "("],
      [:symbol, "("],
      [:identifier, "x"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, "-"],
      [:integerConstant, "1"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, ","],
      [:identifier, "x"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "x"],
      [:symbol, "="],
      [:identifier, "x"],
      [:symbol, "-"],
      [:integerConstant, "2"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "setColor"],
      [:symbol, "("],
      [:keyword, "true"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "drawRectangle"],
      [:symbol, "("],
      [:identifier, "x"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, ","],
      [:identifier, "x"],
      [:symbol, "+"],
      [:integerConstant, "1"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "return"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "method"],
      [:keyword, "void"],
      [:identifier, "moveRight"],
      [:symbol, "("],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "if"],
      [:symbol, "("],
      [:symbol, "("],
      [:identifier, "x"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, "<"],
      [:integerConstant, "510"],
      [:symbol, ")"],
      [:symbol, "{"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "setColor"],
      [:symbol, "("],
      [:keyword, "false"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "drawRectangle"],
      [:symbol, "("],
      [:identifier, "x"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, ","],
      [:identifier, "x"],
      [:symbol, "+"],
      [:integerConstant, "1"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "let"],
      [:identifier, "x"],
      [:symbol, "="],
      [:identifier, "x"],
      [:symbol, "+"],
      [:integerConstant, "2"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "setColor"],
      [:symbol, "("],
      [:keyword, "true"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:keyword, "do"],
      [:identifier, "Screen"],
      [:symbol, "."],
      [:identifier, "drawRectangle"],
      [:symbol, "("],
      [:symbol, "("],
      [:identifier, "x"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, "-"],
      [:integerConstant, "1"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, ","],
      [:identifier, "x"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ","],
      [:identifier, "y"],
      [:symbol, "+"],
      [:identifier, "size"],
      [:symbol, ")"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:keyword, "return"],
      [:symbol, ";"],
      [:symbol, "}"],
      [:symbol, "}"]
    ]

    tokenizer = Tokenizer.new(input)

    while tokenizer.has_more_tokens?
      tokenizer.advance

      actual = case tokenizer.token_type
      when Tokenizer::KEYWORD
        [:keyword, tokenizer.keyword]
      when Tokenizer::SYMBOL
        [:symbol, tokenizer.symbol]
      when Tokenizer::IDENTIFIER
        [:identifier, tokenizer.identifier]
      when Tokenizer::INT_CONST
        [:integerConstant, tokenizer.int_val]
      when Tokenizer::STRING_CONST
        [:stringConstant, tokenizer.string_val]
      end

      expect(actual).to eq(expected.shift)
    end

    expect(expected).to be_empty
  end
end
