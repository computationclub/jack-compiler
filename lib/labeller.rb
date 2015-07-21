class Labeller
  def label(label_base)
    "#{label_base}#{suffix_for(label_base)}"
  end

  private
  def suffix_for(label_base)
    label_suffixes[label_base] += 1
  end

  def label_suffixes
    @_label_suffixes ||= Hash.new(-1)
  end
end
