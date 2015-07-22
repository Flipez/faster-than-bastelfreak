error OpenSSL::SSL::SSLError do
  show_error 'URL does not support HTTPS'
end

error SocketError do
  show_error 'URL is either not reachable or does not exist'
end

error do
  show_error 'An unknown error occured'
  print env['sinatra.error']
  print env['sinatra.error'].message
end

def show_error e
  respond_to do |type|
    type.html do
      halt  haml :error, locals: {errormsg: e, o_uri: default_host, tests: number_of_tests}
    end
    type.json do
      result = {error: e}
      halt result.to_json
    end
  end
end

