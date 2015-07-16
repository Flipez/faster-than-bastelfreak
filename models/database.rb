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
    @redis.expire(m.o_uri, 86400)
  end

  def get host
    YAML::load(@redis.get(host))
  end

  def get_all
    result = Array.new
    keys = @redis.keys('*')
    keys.each do |k|
      result.push get(k)
    end
    sort(result)
  end

  def sort a
    a.sort_by { |k| -k.result }
  end

end
