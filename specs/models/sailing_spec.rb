require_relative "../spec_helper.rb"

RSpec.describe Sailing do
  describe ".direct_sailings" do
    subject { described_class.direct_sailings(sailings, origin_port, destination_port) }

    let(:origin_port) { "CNSHA" }
    let(:destination_port) { "NLRTM" }

    context "when there are no direct sailings" do
      let(:sailings) do
        [
          {
            "origin_port" => "CNSHA",
            "destination_port" => "BRSSZ",
            "departure_date" => "2022-02-02",
            "arrival_date" => "2022-03-02",
            "sailing_code" => "EFGH"
          }
        ]
      end

      it "returns empty collection" do
        expect(subject).to eq([])
      end
    end

    context "when there are direct sailings" do
      let(:sailings) do
        [
          {
            "origin_port" => "CNSHA",
            "destination_port" => "NLRTM",
            "departure_date" => "2022-02-02",
            "arrival_date" => "2022-03-02",
            "sailing_code" => "EFGH"
          },
          {
            "origin_port" => "CNSHA",
            "destination_port" => "UNKNOWN",
            "departure_date" => "2022-01-31",
            "arrival_date" => "2022-02-28",
            "sailing_code" => "IJKL"
          }
        ]
      end

      it "returns collection of direct sailings" do
        expect(subject).to eq(
          [
            {
              "origin_port" => "CNSHA",
              "destination_port" => "NLRTM",
              "departure_date" => "2022-02-02",
              "arrival_date" => "2022-03-02",
              "sailing_code" => "EFGH"
            }
          ]
        )
      end
    end
  end
end
