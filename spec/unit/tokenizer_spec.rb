require 'tokenizer'

RSpec.describe Tokenizer do
  it "tokenizes" do
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
end
