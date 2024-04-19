require_relative "../../spec_helper.rb"

RSpec.describe Sailings::FindCheapest do
  subject { described_class.new(origin_port: origin_port, destination_port: destination_port) }

  describe "#call" do
    context "when existing origin port and destination port are provided" do
      let(:origin_port) { "CNSHA" }
      let(:destination_port) { "NLRTM" }

      it "returns sailing data" do
        expect(JSON.parse(subject.call)).to eq([
          {
            "origin_port" => "CNSHA",
            "destination_port" => "ESBCN",
            "departure_date" => "2022-01-29",
            "arrival_date" => "2022-02-12",
            "sailing_code" => "ERXQ",
            "rate" => "261.96",
            "rate_currency" => "EUR"
          },
          {
            "origin_port" => "ESBCN",
            "destination_port" => "NLRTM",
            "departure_date" => "2022-02-16",
            "arrival_date" => "2022-02-20",
            "sailing_code" => "ETRG",
            "rate" => "69.96",
            "rate_currency" => "USD"
          }
        ])
      end
    end
  end
end
