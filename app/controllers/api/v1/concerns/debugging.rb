def log_request_headers(option = nil)
  headers = filter_headers(option)
  filter_string = option ? "*** FILTERED BY: :#{option.to_s} ***" : ""

  puts ""
  puts "*** BEGIN RAW REQUEST HEADERS ***".colorize(:black)
  puts ""
  
  unless filter_string.empty?
    puts filter_string.colorize(:black)
    puts ""
  end

  headers.each do |header|
    puts "#{header[0]}: #{header[1]}".colorize(:black)
  end

  puts ""
  puts "*** END RAW REQUEST HEADERS ***".colorize(:black)
  puts ""
end

def filter_headers (option)
  headers = request.env

  case option
  when :all
  when :caps
    headers.select! { |h| h == h.upcase }
  when :no_caps
    headers.reject! { |h| h == h.upcase }
  end

  return headers
end
