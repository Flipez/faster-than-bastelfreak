error OpenSSL::SSL::SSLError do
  show_error 'URL does not support HTTPS'
end

error SocketError do
  show_error 'URL is either not reachable or does not exist'
end

error Errno::ENETUNREACH do
  show_error 'Network is unreachable'
end

error do
  show_error 'An unknown error occured'
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

