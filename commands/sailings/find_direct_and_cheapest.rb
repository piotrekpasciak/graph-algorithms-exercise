module Sailings
  class FindDirectAndCheapest
    def initialize(origin_port:, destination_port:, response: JSON.parse(File.read('./response.json')))
      @origin_port = origin_port
      @destination_port = destination_port
      @response = response
    end

    def call
      direct_sailings.each do |sailing|
        rate = sailing_rate(sailing.fetch("sailing_code"))
        sailing["rate"] = rate
        sailing["rate_cost_in_euro"] = rate_cost_in_euro(rate, sailing.fetch("departure_date"))
      end

      [SailingSerializer.new(sailing: cheapest_sailing).serialize].to_json
    end

    private

    attr_reader :origin_port, :destination_port, :response

    def direct_sailings
      Sailing.direct_sailings(response.fetch("sailings"), origin_port, destination_port)
    end

    def sailing_rate(sailing_code)
      Rate.find_by_sailing_code(response.fetch("rates"), sailing_code)
    end

    def rate_cost_in_euro(rate, departure_date)
      Rates::ComputeCostInEuro.new(
        rate: rate,
        departure_date: departure_date,
        exchange_rates: response.fetch("exchange_rates")
      ).call
    end

    def cheapest_sailing
      direct_sailings.min_by { |sailing| sailing.fetch("rate_cost_in_euro") }
    end
  end
end
