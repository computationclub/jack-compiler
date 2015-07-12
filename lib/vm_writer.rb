class VMWriter
  attr_accessor :io
  private :io, :io=

  def initialize(io)
    self.io = io
  end

  def write_push(segment, index)
    io.puts("push #{variable_reference(segment, index)}")
  end

  def write_pop(segment, index)
    io.puts("pop #{variable_reference(segment, index)}")
  end

  def variable_reference(segment, index)
    case segment
    when 'var', :var
      "local #{index}"
    when 'arg', :arg
      "argument #{index}"
    else
      "#{segment} #{index}"
    end
  end

  def write_binary_operation(operation)
    case operation
    when '+'
      write_arithmetic('add')
    when '-'
      write_arithmetic('sub')
    when '*'
      write_call('Math.multiply', 2)
    when '/'
      write_call('Math.divide', 2)
    when '&'
      write_arithmetic('and')
    when '|'
      write_arithmetic('or')
    when '>'
      write_arithmetic('gt')
    when '<'
      write_arithmetic('lt')
    when '='
      write_arithmetic('eq')
    end
  end

  def write_unary_operation(operation)
    write_arithmetic({'-' => 'neg', '~' => 'not'}.fetch(operation))
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
