class SailingSerializer
  def initialize(sailing:)
    @sailing = sailing
  end

  def serialize
    {
      origin_port: sailing.fetch("origin_port"),
      destination_port: sailing.fetch("destination_port"),
      departure_date: sailing.fetch("departure_date"),
      arrival_date: sailing.fetch("arrival_date"),
      sailing_code: sailing.fetch("sailing_code"),
      rate: rate.fetch("rate"),
      rate_currency: rate.fetch("rate_currency")
    }
  end

  private

  attr_reader :sailing

  def rate
    @rate ||= sailing.fetch("rate")
  end
end
