def default_host
  "#{request.scheme}://#{request.host}"
end

def number_of_tests
  settings.db.number_of_tests
end

def validate_url url
  uri = URI.parse(url)
  if uri.instance_of? URI::HTTPS
    uri 
  else
    false
  end
end

def start_test uri
  m = Measurement.new settings.db

    m.start uri

    settings.db.count_test
    settings.db.store m

    return m
end

def show_result result
  respond_to do |type|
    type.html do
      haml :result, :locals => {m: result, o_uri: result.o_uri, tests: number_of_tests}
    end
    type.json do
      show_json result
    end
  end
end
