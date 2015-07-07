class VMWriter
  attr_accessor :io
  private :io, :io=

  def initialize(io)
    self.io = io
  end

  def write_push(segment, index)
    io.puts("push #{segment} #{index}")
  end

  def write_pop(segment, index)
    io.puts("pop #{segment} #{index}")
  end

  def write_operation(operation)
    write_arithmetic({ '+' => 'add', '-' => 'neg', '~' => 'not' }.fetch(operation))
  end

  def write_arithmetic(command)
    io.puts(command)
  end

  def write_label(label)
    io.puts("label #{label}")
  end

  def write_goto(label)
    io.puts("goto #{label}")
  end

  def write_if(label)
    io.puts("if-goto #{label}")
  end

  def write_call(name, n)
    io.puts("call #{name} #{n}")
  end

  def write_function(name, n)
    io.puts("function #{name} #{n}")
  end

  def write_return
    io.puts("return")
  end

  def close
    io.close
  end
end
