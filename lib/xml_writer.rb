require 'builder'

class XMLWriter < SimpleDelegator
  def initialize(output)
    @output = Builder::XmlMarkup.new(target: output, indent: 2)
  end

  def write_class(&blk)
    b.tag!(:class, &blk)
  end

  def write_classVarDec(&blk)
    b.classVarDec(&blk)
  end

  def write_classVarDec(&blk)
    b.classVarDec(&blk)
  end

  private

  def b
    @output
  end
end
