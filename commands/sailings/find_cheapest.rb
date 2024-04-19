module Sailings
  class FindCheapest
    def initialize(origin_port:, destination_port:, response: JSON.parse(File.read('./response.json')))
      @origin_port = origin_port
      @destination_port = destination_port
      @response = response
      @sailings_sums = []
    end

    def call
      connected_sailings.each.with_index do |sailing, index|
        sailing.each do |sailing_leg|
          rate = sailing_rate(sailing_leg.fetch("sailing_code"))
          sailing_leg["rate"] = rate
          sailing_leg["rate_cost_in_euro"] = rate_cost_in_euro(rate, sailing_leg.fetch("departure_date"))
        end

        sailing_sum = sailing.sum { |sailing_leg| BigDecimal(sailing_leg.fetch("rate_cost_in_euro").to_s) }
        sailings_sums << { index: index, sum: sailing_sum }
      end

      cheapest_sailing.map { |sailing_leg| SailingSerializer.new(sailing: sailing_leg).serialize }.to_json
    end

    attr_reader :origin_port, :destination_port, :response, :sailings_sums

    def sailings
      @sailings ||= response.fetch("sailings")
    end

    def connected_sailings
      @connected_sailings ||= direct_sailings + indirect_sailings
    end

    def direct_sailings
      Sailing.direct_sailings(sailings, origin_port, destination_port).map { |sailing| [sailing] }
    end

    def indirect_sailings
      Sailings::FilterIndirectConnections.new(
        sailings: sailings,
        origin_port: origin_port,
        destination_port: destination_port
      ).call
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

    def cheapest_direct_sailing
      FindCheapestDirectSailing.new(
        origin_port: origin_port,
        destination_port: destination_port,
        response: response
      ).call
    end

    def cheapest_sailing
      index_of_cheapest_sailing = sailings_sums.min_by { |sum| sum[:sum] }[:index]

      connected_sailings[index_of_cheapest_sailing]
    end
  end
end
