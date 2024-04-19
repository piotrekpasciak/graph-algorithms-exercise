module Rates
  class ComputeCostInEuro
    def initialize(rate:, departure_date:, exchange_rates:)
      @rate = rate
      @departure_date = departure_date
      @exchange_rates = exchange_rates
    end

    def call
      return rate_value.to_f if rate_currency == "eur"
      return nil if euro_exchange_rate.nil?

      (BigDecimal(rate_value) / BigDecimal(euro_exchange_rate)).round(2)
    end

    private

    attr_reader :rate, :departure_date, :exchange_rates

    def rate_currency
      rate.fetch("rate_currency").downcase
    end

    def rate_value
      rate.fetch("rate").to_s
    end

    def euro_exchange_rate
      @euro_exchange_rate ||= exchange_rates.dig(departure_date, rate_currency)&.to_s
    end
  end
end
