class Measurement

  attr_reader :created, :b_time, :o_time, :o_uri, :result, :color
  attr_reader :ssl_issuer, :ssl_algo, :ssl_size, :ssl_from, :ssl_to, :ssl_cipher, :ssl_tls

  def initialize(redis)
    @bastel = 'https://blog.bastelfreak.de'
    @redis = redis
    
  end

  def start o_uri
    @created = Time.now
    @o_time = measure o_uri

    if @redis.get('bastel-time')
      bastel = @redis.get('bastel-time')
      @b_time = bastel
    else
      @b_time = measure URI(@bastel)
      @redis.set_bastel_time(@b_time)
    end
    @o_uri  = o_uri
    @result = calc_result

    if @result < 1
      @color = 'danger'
    elsif @result < 20
      @color = 'warning'
    elsif @result < 500
      @color = 'info'
    else
      @color = 'success'
    end

    @b_time = round @b_time
    @o_time = round @o_time

    parse_ssl
  end


  private

  def round i
    ( i * 1000).round / 1000.0
  end

  def calc_result
    ((@b_time / @o_time) * 100).round / 100.0
  end

  def measure uri
    Benchmark.realtime do
      req uri
     end
  end

  def parse_ssl
      tcp_c = TCPSocket.new(@o_uri.hostname, @o_uri.port)
      ssl_cx = OpenSSL::SSL::SSLContext.new
      ssl_cx.verify_mode = OpenSSL::SSL::VERIFY_NONE
      ssl_c =OpenSSL::SSL::SSLSocket.new(tcp_c, ssl_cx)
      ssl_c.hostname = @o_uri.hostname
      ssl_c.sync = true
      ssl_c.connect

      @ssl_cipher = ssl_c.cipher[0]
      @ssl_tls = ssl_c.cipher[1]

      cert = OpenSSL::X509::Certificate.new(ssl_c.peer_cert)

      ssl_c.sysclose
      tcp_c.close

      certprops = OpenSSL::X509::Name.new(cert.issuer).to_a
      p certprops.inspect
      if certprops.size > 1
        @ssl_issuer = certprops[1][3]
      else
        @ssl_issuer = certprops[0][1]
      end
      @ssl_algo = cert.signature_algorithm
      @ssl_size = cert.public_key.n.num_bytes * 8
      @ssl_from = cert.not_before
      @ssl_to = cert.not_after

  end

  def req uri
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
  end

end
