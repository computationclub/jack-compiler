require 'symbol_table'

RSpec.describe SymbolTable do
  let(:table) { SymbolTable.new }

  describe "#start_subroutine" do
    pending "not needed yet"
  end

  describe "#define" do
    it "increments var_count for the given kind" do
      table.define("nAccounts", "int", :static)
      expect(table.var_count(:static)).to eq(1)
    end

    it "doesn't increment var_count for other kinds" do
      table.define("nAccounts", "int", :static)
      expect(table.var_count(:field)).to eq(0)
    end
  end

  describe "#var_count" do
    it "starts from 0" do
      expect(table.var_count(:static)).to eq(0)
    end
  end

  describe "#kind_of" do
    it "returns 'none' when given an undefined symbol" do
      expect(table.kind_of("foo")).to eq(:none)
    end

    it "returns the kind of the given symbol, when defined" do
      table.define("nAccounts", "int", :static)
      expect(table.kind_of("nAccounts")).to eq(:static)
    end
  end

  describe "#type_of" do
    it "raises an error when the symbol is undefined" do
      expect { table.type_of("foo") }.to raise_error(SymbolTable::SymbolNotFound)
    end

    it "returns the type of the given symbol, when defined" do
      table.define("nAccounts", "int", :static)
      expect(table.type_of("nAccounts")).to eq("int")
    end
  end

  describe "#index_of" do
    it "returns 0 for the first symbol of its kind" do
      table.define("nAccounts", "int", :static)
      expect(table.index_of("nAccounts")).to eq(0)
    end

    it "returns 1 for the second symbol of its kind" do
      table.define("nAccounts", "int", :static)
      table.define("bankCommission", "int", :static)
      expect(table.index_of("bankCommission")).to eq(1)
    end

    it "doesn't increment the index of other kinds" do
      table.define("nAccounts", "int", :static)
      table.define("bankCommission", "int", :static)
      table.define("foo", "int", :field)
      expect(table.index_of("foo")).to eq(0)
    end
  end
end
