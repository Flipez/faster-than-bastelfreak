require'benchmark';require'net/http';u=URI('https://blog.bastelfreak.de')
def n u;r=Net::HTTP.get_response(u);end;def m u;Benchmark.realtime do;n u
end;end;z=ARGV[0];if z=~URI::regexp;t=(((m u)/(m URI(z)))*100).round/
100.0;p"#{z} is #{t} times faster than #{u.to_s}";else;p'invalid URL';end
