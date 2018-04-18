require 'spec_helper'
require 'money-rails/helpers/string_parser'

describe StringParser, :helper do

  locales = %i(en fr nl)

  Money.use_i18n = true

  locales.each do |locale|
    describe "works with normalized string inputs for #{locale}" do

      around(:each) do |example|
        I18n.with_locale(locale) do
          example.run
        end
      end

      string_input_permutations = [
        "1 000 456.50",
        "1 000 456,50",
        "1,000,456.50",
        "1.000.456,50",
        "1 000 456.5",
        "1 000 456,5",
        "1,000,456.5",
        "1.000.456,5",
        "1.000.456,50 €",
        "€ 1,000,456.50",
      ]

      string_input_permutations.each do |permutation|
        it "parses #{permutation} to 1000456.50" do

          puts "Current locale = #{I18n.locale}"
          result = StringParser.new(permutation).parse
          expect(result).to eq("1000456.50")
        end
      end
    end
  end

  describe ".strip_unwanted_chars" do
    it "strips everything except digits, points commas and spaces" do
      parser = StringParser.new("123 456.7x8_9,4!@0")
      parser.strip_unwanted_chars!
      expect(parser.raw_value).to eq("123 456.789,40")
    end

    it "strips everything except digits, points commas and spaces" do
      parser = StringParser.new("1.000.456,50 €")
      parser.strip_unwanted_chars!
      expect(parser.raw_value).to eq("1.000.456,50")
    end
  end
end
