require 'vm_writer'

RSpec.describe VMWriter do
  describe 'write_push' do
    it 'writes a VM push command' do
      out = StringIO.new
      writer = VMWriter.new(out)
      writer.write_push(:static, 0)
      expect(out.string).to eq("push static 0\n")
    end

    it 'writes a VM push command with different segments' do
      out = StringIO.new
      writer = VMWriter.new(out)
      writer.write_push(:local, 0)
      expect(out.string).to eq("push local 0\n")
    end

    it 'writes a VM push command with different indices' do
      out = StringIO.new
      writer = VMWriter.new(out)
      writer.write_push(:local, 7)
      expect(out.string).to eq("push local 7\n")
    end
  end

  describe '#write_pop' do
    it 'writes a VM pop command' do
      out = StringIO.new
      writer = VMWriter.new(out)
      writer.write_pop(:local, 7)
      expect(out.string).to eq("pop local 7\n")
    end
  end

  describe '#write_arithmetic' do
    it 'writes a VM arithmetic command' do
      out = StringIO.new
      writer = VMWriter.new(out)
      writer.write_arithmetic(:add)
      expect(out.string).to eq("add\n")
    end
  end

  describe '#write_label' do
    it 'writes a VM label command' do
      out = StringIO.new
      writer = VMWriter.new(out)
      writer.write_label('foo')
      expect(out.string).to eq("label foo\n")
    end
  end

  describe '#write_goto' do
    it 'writes a VM goto command' do
      out = StringIO.new
      writer = VMWriter.new(out)
      writer.write_goto('foo')
      expect(out.string).to eq("goto foo\n")
    end
  end

  describe '#write_if' do
    it 'writes a VM if command' do
      out = StringIO.new
      writer = VMWriter.new(out)
      writer.write_if('foo')
      expect(out.string).to eq("if-goto foo\n")
    end
  end

  describe '#write_call' do
    it 'writes a VM call command' do
      out = StringIO.new
      writer = VMWriter.new(out)
      writer.write_call('foo', 5)
      expect(out.string).to eq("call foo 5\n")
    end
  end

  describe '#write_function' do
    it 'writes a VM function command' do
      out = StringIO.new
      writer = VMWriter.new(out)
      writer.write_function('foo', 5)
      expect(out.string).to eq("function foo 5\n")
    end
  end

  describe '#write_return' do
    it 'writes a VM return command' do
      out = StringIO.new
      writer = VMWriter.new(out)
      writer.write_return
      expect(out.string).to eq("return\n")
    end
  end

  describe '#close' do
    it 'closes the output file' do
      out = StringIO.new
      writer = VMWriter.new(out)
      writer.close
      expect(out).to be_closed
    end
  end
end
