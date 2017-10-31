module PrecisionHelper
  PRECISION_MAP = { 'BTC' => 8, 'ETH' => 18, 'LTC' => 8,
                    'USD' => 2, 'EUR' => 2,  'GBP' => 2 }.freeze

  def currency(value, currency)
    precision = PRECISION_MAP[currency] || 8
    format('%%0.%sf', precision) % value
  end
end
