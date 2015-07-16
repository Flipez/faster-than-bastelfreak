class Measurement

  attr_reader :created, :b_time, :o_time, :o_uri, :result, :color

  def initialize
    @bastel = URI('https://blog.bastelfreak.de')
  end

  def start o_uri
    @created = Time.now
    @o_time = measure o_uri
    @b_time = measure @bastel
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
