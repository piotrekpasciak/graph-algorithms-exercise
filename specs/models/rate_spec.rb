require_relative "../spec_helper.rb"

RSpec.describe Rate do
  describe ".find_by_sailing_code" do
    subject { described_class.find_by_sailing_code(rates, sailing_code) }

    let(:rates) do
      [
        {
          "sailing_code" => "ABCD",
          "rate" => "589.30",
          "rate_currency" => "USD"
        },
        {
          "sailing_code" => "EFGH",
          "rate" => "890.32",
          "rate_currency" => "EUR"
        },
        {
          "sailing_code" => "IJKL",
          "rate" => "97453",
          "rate_currency" => "JPY"
        }
      ]
    end

    context "when rate does not exist" do
      let(:sailing_code) { "UNKNOWN" }

      it "returns nil" do
        expect(subject).to eq nil
      end
    end

    context "when rate can be found in collection" do
      let(:sailing_code) { "EFGH" }

      it "returns rate" do
        expect(subject).to eq({
          "sailing_code" => "EFGH",
          "rate" => "890.32",
          "rate_currency" => "EUR"
        })
      end
    end
  end
end
