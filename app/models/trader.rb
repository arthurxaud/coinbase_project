class Trader
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include PrecisionHelper

  attr_reader :action, :base_currency, :quote_currency, :amount

  validates_presence_of :action, :base_currency, :quote_currency, :amount
  validates_inclusion_of :action, in: %w[buy sell]
  validates_numericality_of :amount
  after_validation :amount_to_big_decimal

  def initialize(params)
    @action = params[:action]
    @base_currency = params[:base_currency]
    @quote_currency = params[:quote_currency]
    @amount = params[:amount]
    validate!
  end

  def quote
    pair = CurrencyPair.new(base_currency, quote_currency)
    book = TradingVenue.book_for(pair)
    total = book.best_price(amount, action)
    response(total)
  end

  private

  def response(total)
    { total: currency(total, quote_currency),
      price: currency((total / amount), quote_currency),
      currency: quote_currency }
  end

  def validate!(context = nil)
    valid?(context) || raise_validation_error
  end

  def raise_validation_error
    raise Error::Validation, errors.messages
  end

  def amount_to_big_decimal
    @amount = BigDecimal.new(amount)
  end
end
