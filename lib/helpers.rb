module Helpers
  def h(text)
    Rack::Utils.escape_html(text)
  end
  
  def number_with_delimiter(number, delimiter = ",", separator = ".")
    begin
      Float(number)
    rescue ArgumentError, TypeError
      if options[:raise]
        raise InvalidNumberError, number
      else
        return number
      end
    end

    parts = number.to_s.to_str.split('.')
    parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
    parts.join(separator)
  end
end