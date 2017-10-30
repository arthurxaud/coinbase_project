module AxQuoter
  module Helpers
    class Precision
      PRECISION_MAP = { 'BTC' => 8, 'ETH' => 18, 'LTC' => 8,
                        'USD' => 2, 'EUR' => 2,  'GBP' => 2 }.freeze

      def self.currency(value, currency)
        precision = PRECISION_MAP[currency] || 8
        "%0.#{precision}f" % value
      end
    end
  end
end
