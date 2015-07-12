require 'labeller'

RSpec.describe Labeller do
  subject(:labeller) { described_class.new }
  it 'appends 0 to a label the first time it sees it' do
    expect(labeller.label('cheese')).to eq 'cheese0'
  end

  it 'appends 1 to a label the first time it sees it' do
    labeller.label('cheese')
    expect(labeller.label('cheese')).to eq 'cheese1'
  end

  it 'keeps the label suffix independent per label' do
    labeller.label('cheese')
    labeller.label('ham')
    labeller.label('cheese')
    expect(labeller.label('cheese')).to eq 'cheese2'
    expect(labeller.label('ham')).to eq 'ham1'
    expect(labeller.label('bread')).to eq 'bread0'
  end
end
