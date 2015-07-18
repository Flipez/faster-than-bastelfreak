require 'json'

def show_json r
  result = {test: {created: r.created,
                   b_time: r.b_time,
                   o_time: r.o_time,
                   o_uri: r.o_uri,
                   result: r.result,
                   color: r.color,
                   ssl_issuer: r.ssl_issuer,
                   ssl_algo: r.ssl_algo,
                   ssl_size: r.ssl_size,
                   ssl_from: r.ssl_from,
                   ssl_to: r.ssl_to,
                   ssl_cipher: r.ssl_cipher,
                   ssl_tls: r.ssl_tls}}
  result.to_json
end

