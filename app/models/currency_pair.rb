class CurrencyPair
  attr_reader :base, :quote

  def initialize(base, quote)
    @base = base
    @quote = quote
  end

  def invert
    self.class.new(quote, base)
  end

  def to_s
    format('%s-%s', base, quote)
  end
end
