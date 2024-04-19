require_relative "../../spec_helper.rb"

RSpec.describe Sailings::FilterIndirectConnections do
  subject { described_class.new(sailings: sailings, origin_port: origin_port, destination_port: destination_port) }

  let(:origin_port) { "CNSHA" }
  let(:destination_port) { "NLRTM" }

  describe "#call" do
    context "when there are no connections at all" do
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
        expect(subject.call).to eq([])
      end
    end

    context "when there are only direct sailings" do
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
            "destination_port" => "NLRTM",
            "departure_date" => "2022-01-31",
            "arrival_date" => "2022-02-28",
            "sailing_code" => "IJKL"
          }
        ]
      end

      it "returns empty collection" do
        expect(subject.call).to eq([])
      end
    end

    context "when indirect sailing ESBCN arrival date matches only one sailing" do
      let(:sailings) do
        [
          {
            "origin_port" => "CNSHA",
            "destination_port" => "ESBCN",
            "departure_date" => "2022-01-29",
            "arrival_date" => "2022-02-16",
            "sailing_code" => "ERXQ"
          },
          {
            "origin_port" => "ESBCN",
            "destination_port" => "NLRTM",
            "departure_date" => "2022-02-15",
            "arrival_date" => "2022-03-29",
            "sailing_code" => "ETRF"
          },
          {
            "origin_port" => "ESBCN",
            "destination_port" => "NLRTM",
            "departure_date" => "2022-02-16",
            "arrival_date" => "2022-02-20",
            "sailing_code" => "ETRG"
          },
          {
            "origin_port" => "ESBCN",
            "destination_port" => "BRSSZ",
            "departure_date" => "2022-02-16",
            "arrival_date" => "2022-03-14",
            "sailing_code" => "ETRB"
          }
        ]
      end

      it "returns list with one indirect sailing" do
        expect(subject.call).to eq([
          [
            { "origin_port" => "CNSHA", "destination_port" => "ESBCN", "departure_date" => "2022-01-29", "arrival_date" => "2022-02-16", "sailing_code" => "ERXQ" },
            { "origin_port" => "ESBCN", "destination_port" => "NLRTM", "departure_date" => "2022-02-16", "arrival_date" => "2022-02-20", "sailing_code" => "ETRG" }
          ]
        ])
      end
    end

    context "when indirect sailing consist of 3 shipment legs" do
      let(:sailings) do
        [
          {
            "origin_port" => "CNSHA",
            "destination_port" => "ESBCN",
            "departure_date" => "2022-01-29",
            "arrival_date" => "2022-02-10",
            "sailing_code" => "ERXQ"
          },
          {
            "origin_port" => "ESBCN",
            "destination_port" => "BRSSZ",
            "departure_date" => "2022-02-10",
            "arrival_date" => "2022-03-10",
            "sailing_code" => "ETRF"
          },
          {
            "origin_port" => "BRSSZ",
            "destination_port" => "NLRTM",
            "departure_date" => "2022-03-10",
            "arrival_date" => "2022-03-14",
            "sailing_code" => "ETRB"
          }
        ]
      end

      it "returns list with one indirect sailing" do
        expect(subject.call).to eq([
          [
            { "origin_port" => "CNSHA", "destination_port" => "ESBCN", "departure_date" => "2022-01-29", "arrival_date" => "2022-02-10", "sailing_code" => "ERXQ" },
            { "origin_port" => "ESBCN", "destination_port" => "BRSSZ", "departure_date" => "2022-02-10", "arrival_date" => "2022-03-10", "sailing_code" => "ETRF" },
            { "origin_port" => "BRSSZ", "destination_port" => "NLRTM", "departure_date" => "2022-03-10", "arrival_date" => "2022-03-14", "sailing_code" => "ETRB" }
          ]
        ])
      end
    end

    context "when there are 2 indirect sailings consisting of 2 shipments legs each" do
      let(:sailings) do
        [
          {
            "origin_port" => "CNSHA",
            "destination_port" => "ESBCN",
            "departure_date" => "2022-01-29",
            "arrival_date" => "2022-02-12",
            "sailing_code" => "ERXQ"
          },
          {
            "origin_port" => "ESBCN",
            "destination_port" => "NLRTM",
            "departure_date" => "2022-02-15",
            "arrival_date" => "2022-03-29",
            "sailing_code" => "ETRF"
          },
          {
            "origin_port" => "ESBCN",
            "destination_port" => "NLRTM",
            "departure_date" => "2022-02-16",
            "arrival_date" => "2022-02-20",
            "sailing_code" => "ETRG"
          },
          {
            "origin_port" => "ESBCN",
            "destination_port" => "BRSSZ",
            "departure_date" => "2022-02-16",
            "arrival_date" => "2022-03-14",
            "sailing_code" => "ETRB"
          }
        ]
      end

      it "returns list of indirect sailings" do
        expect(subject.call).to eq([
          [
            { "origin_port" => "CNSHA", "destination_port" => "ESBCN", "departure_date" => "2022-01-29", "arrival_date" => "2022-02-12", "sailing_code" => "ERXQ" },
            { "origin_port" => "ESBCN", "destination_port" => "NLRTM", "departure_date" => "2022-02-16", "arrival_date" => "2022-02-20", "sailing_code" => "ETRG" }
          ],
          [
            { "origin_port" => "CNSHA", "destination_port" => "ESBCN", "departure_date" => "2022-01-29", "arrival_date" => "2022-02-12", "sailing_code" => "ERXQ" },
            { "origin_port" => "ESBCN", "destination_port" => "NLRTM", "departure_date" => "2022-02-15", "arrival_date" => "2022-03-29", "sailing_code" => "ETRF" }
          ]
        ])
      end
    end
  end
end
