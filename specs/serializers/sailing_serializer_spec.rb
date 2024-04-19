require_relative "../spec_helper.rb"

RSpec.describe SailingSerializer do
  subject { described_class.new(sailing: sailing) }

  let(:sailing) do
    {
      "origin_port" => "CNSHA",
      "destination_port" => "NLRTM",
      "departure_date" => "2022-02-01",
      "arrival_date" => "2022-03-01",
      "sailing_code" => "ABCD",
      "rate" => rate
    }
  end
  let(:rate) do
    {
      "sailing_code" => "ABCD",
      "rate" => "589.30",
      "rate_currency" => "USD"
    }
  end

  describe "#serialize" do
    it "returns serialized hash" do
      expect(subject.serialize).to eq({
        origin_port: "CNSHA",
        destination_port: "NLRTM",
        departure_date: "2022-02-01",
        arrival_date: "2022-03-01",
        sailing_code: "ABCD",
        rate: "589.30",
        rate_currency: "USD"
      })
    end
  end
end
