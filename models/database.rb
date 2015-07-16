require 'redis'
require 'yaml'

class Database

  def initialize
    @redis = Redis.new(:db => 1)
  end

  ##
  # Storing the given object for 24 hours
  def store m
      @redis.set(m.o_uri, m.to_yaml)
    if m.o_uri == 'https://blog.bastelfreak.de'
      @redis.expire(m.o_uri, 600)
    else
      @redis.expire(m.o_uri, 86400)
    end
  end

  def set_bastel_time value
    @redis.set('bastel-time', value)
    @redis.expire('bastel-time', 600)
  end

  def get host
    begin
      YAML::load(@redis.get(host))
    rescue
     nil
    end
  end

  def get_all
    result = Array.new
    keys = @redis.keys('*')
    keys.each do |k|
      result.push get(k) if k=~URI::regexp
    end
    sort(result)
  end

  def count_test
    @redis.incr('test-counter')
  end

  def number_of_tests
    @redis.get('test-counter')
  end

  def sort a
      a.sort_by { |k| -k.result }
  end

end
