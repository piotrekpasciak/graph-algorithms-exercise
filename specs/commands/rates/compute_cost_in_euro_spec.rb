require_relative "../../spec_helper.rb"

RSpec.describe Rates::ComputeCostInEuro do
  subject { described_class.new(rate: rate, departure_date: departure_date, exchange_rates: exchange_rates) }

  let(:departure_date) { "2022-02-01" }
  let(:exchange_rates) do
    {
      "2022-02-01" => {
        "usd" => 1.126,
        "jpy" => 130.15
      }
    }
  end

  describe "#call" do
    context "when rate is already in EUR currency" do
      let(:rate) do
        {
          "sailing_code" => "ERXQ",
          "rate" => "261.96",
          "rate_currency" => "EUR"
        }
      end

      it "returns rate value" do
        expect(subject.call).to eq 261.96
      end
    end

    context "when there is no matching exchange rate" do
      let(:rate) do
        {
          "sailing_code" => "ABCD",
          "rate" => "2589.30",
          "rate_currency" => "PLN"
        }
      end

      it "returns nil" do
        expect(subject.call).to eq nil
      end
    end

    context "when rate is in USD currency" do
      let(:rate) do
        {
          "sailing_code" => "ABCD",
          "rate" => "589.30",
          "rate_currency" => "USD"
        }
      end

      it "returns rate value after conversion" do
        expect(subject.call).to eq 523.36
      end
    end

    context "when rate is in JPY currency" do
      let(:rate) do
        {
          "sailing_code" => "IJKL",
          "rate" => "97453",
          "rate_currency" => "JPY"
        }
      end

      it "returns rate value after conversion" do
        expect(subject.call).to eq 748.77
      end
    end
  end
end
