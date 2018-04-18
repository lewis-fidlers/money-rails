class StringParser
  attr_reader :raw_value, :normalized_raw_value

  def initialize(unparsed_amount)
    raise "Only takes string as input" unless unparsed_amount.is_a? String
    @raw_value = unparsed_amount
    @normalized_raw_value = nil
  end

  # returns a number in this format: 12000.00
  def parse
    strip_unwanted_chars!
    normalize_raw_value
  end

  # Leaves only numbers and known separators
  def strip_unwanted_chars!
    @raw_value = @raw_value
      .gsub(/[^\d\.\, ]/, "")
      .strip

  end

  def normalize_raw_value
    normalized_integer_part = integer_part.gsub(/(\.|,)/, '')
    normalized_decimal_part = decimal_part.gsub(/(\.|,)/, '.')

    normalized_decimal_part.concat('0') if normalized_decimal_part.length == 2

    @normalized_raw_value = "%s%s" % [normalized_integer_part, normalized_decimal_part]
    @normalized_raw_value.gsub!(/[\s_]/, '')
    @normalized_raw_value
  end

  def decimal_part
    @raw_value.match(/(\.|,)\d{1,2}$/).to_s
  end

  def integer_part
    @raw_value.match(/.+?(?=#{Regexp.escape(decimal_part)})/).to_s
  end
end
