class OrderBook
  attr_reader :asks, :bids

  ACTIONS_BOOK_MAP = { 'buy' => :asks, 'sell' => :bids }.freeze

  def initialize(params)
    @asks = create_orders(params[:asks])
    @bids = create_orders(params[:bids])
  end

  def invert
    old_bids = bids
    old_asks = asks
    @asks = old_bids.map(&:invert)
    @bids = old_asks.map(&:invert)
    self
  end

  def best_price(amount, action)
    amount_to_process = amount
    total = 0
    action_book(action).each do |order|
      break if amount_to_process.zero?
      proccess_amount = [amount_to_process, order.size].min
      total += order.price * proccess_amount
      amount_to_process -= proccess_amount
    end
    return total if amount_to_process.zero?
    raise Error::AmountExceeded, 'Available amount at this level was exceeded'
  end

  private

  def action_book(action)
    send(ACTIONS_BOOK_MAP[action])
  end

  def create_orders(params)
    params.map do |aggregated_order|
      price = BigDecimal.new(aggregated_order[0])
      size = BigDecimal.new(aggregated_order[1])
      Order.new(price, size)
    end
  end
end
