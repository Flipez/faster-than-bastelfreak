class Measurement

  attr_reader :created, :b_time, :o_time, :o_uri, :result, :color

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


  def req uri
    Net::HTTP.get_response uri
  end

end
