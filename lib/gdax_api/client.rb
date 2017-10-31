module GdaxAPI
  class Client
    include GdaxAPI::Request

    def order_book(product_id, level = 2)
      path = "/products/#{product_id}/book"
      get(path, level: level)
    end
  end
end
