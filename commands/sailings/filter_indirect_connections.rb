module Sailings
  class FilterIndirectConnections
    def initialize(sailings:, origin_port:, destination_port:)
      @sailings = sailings
      @origin_port = origin_port
      @destination_port = destination_port
    end

    def call
      indirect_sailings = depth_first_search(build_graph, origin_port, destination_port)

      indirect_sailings.each { |connected_path| connected_path.delete_at(0) }

      indirect_sailings
    end

    private

    attr_reader :sailings, :origin_port, :destination_port

    def build_graph
      graph = Hash.new([])

      remaining_sailings.each do |sailing|
        graph[sailing["origin_port"]] |= [sailing]
      end

      graph
    end

    def direct_sailings
      Sailing.direct_sailings(sailings, origin_port, destination_port)
    end

    def remaining_sailings
      sailings - direct_sailings
    end

    def depth_first_search(graph, origin_port, destination_port)
      stack = origin_port_sailing
      connected_paths = []

      while stack.any?
        path = stack.pop
        current_node = path.last
        current_port = current_node["destination_port"]
        current_date = current_node["arrival_date"]

        next connected_paths << path if current_port == destination_port

        graph[current_port].each do |new_connection|
          port_name = new_connection["destination_port"]
          new_connection_date = Date.parse(new_connection["departure_date"])

          next if path.include?(new_connection)

          if current_date.nil? || Date.parse(current_date) <= new_connection_date
            stack << path + [new_connection]
          end
        end
      end

      connected_paths
    end

    def origin_port_sailing
      [[{ "destination_port" => origin_port, "departure_date" => nil, "arrival_date" => nil }]]
    end
  end
end
