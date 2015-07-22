environment 'production'

pidfile 'puma.pid'

threads 0,5
workers 5

#daemonize true

bind 'tcp://127.0.0.1:4567'
