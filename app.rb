require_relative "config/load_files"

#### (1) PLS-0001 - Solution:

result = Sailings::FindDirectAndCheapest.new(
  origin_port: "CNSHA",
  destination_port: "NLRTM"
).call

puts "(1) PLS-0001 - Solution: "
puts result
puts

#### (2) WRT-0002 - Solution:

second_result = Sailings::FindCheapest.new(
  origin_port: "CNSHA",
  destination_port: "NLRTM"
).call

puts "(2) WRT-0002 - Solution: "
puts second_result
puts
