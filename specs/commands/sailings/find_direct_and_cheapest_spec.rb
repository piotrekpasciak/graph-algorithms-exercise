require_relative "../../spec_helper.rb"

RSpec.describe Sailings::FindDirectAndCheapest do
  subject { described_class.new(origin_port: origin_port, destination_port: destination_port) }

  describe "#call" do
    context "when existing origin port and destination port are provided" do
      let(:origin_port) { "CNSHA" }
      let(:destination_port) { "NLRTM" }

      it "returns sailing data" do
        expect(JSON.parse(subject.call)).to eq [
          {
            "origin_port" => "CNSHA",
            "destination_port" => "NLRTM",
            "departure_date" => "2022-01-30",
            "arrival_date" => "2022-03-05",
            "sailing_code" => "MNOP",
            "rate" => "456.78",
            "rate_currency" => "USD"
          }
        ]
      end
    end
  end
end
