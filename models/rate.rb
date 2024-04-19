class Rate
  def self.find_by_sailing_code(rates, sailing_code)
    rates.find { |rate| rate.fetch("sailing_code") == sailing_code }
  end
end
