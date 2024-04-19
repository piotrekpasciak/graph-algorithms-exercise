class Sailing
  def self.direct_sailings(sailings, origin_port, destination_port)
    sailings.filter do |sailing|
      sailing.fetch("origin_port") == origin_port && sailing.fetch("destination_port") == destination_port
    end
  end
end
