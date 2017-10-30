module AxQuoter
  class Calculator
    attr_reader :order_book, :action, :amount

    ACTIONS_BOOK_MAP = { 'buy' => :asks, 'sell' => :bids }.freeze

    def initialize(order_book, action, amount)
      @order_book = order_book
      @action = action
      @amount = amount
    end

    def total_price
      amount_to_process = amount
      total = 0
      action_book.each do |order|
        break if amount_to_process.zero?
        proccess_amount = [amount_to_process, order.size].min
        total += order.price * proccess_amount
        amount_to_process -= proccess_amount
      end
      return total if amount_to_process.zero?
      raise AmountExceededError, 'Available amount at this level was exceeded'
    end

    private

    def action_book
      order_book.send(ACTIONS_BOOK_MAP[action])
    end
  end
end
