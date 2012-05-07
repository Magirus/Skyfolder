worker_processes 1
preload_app true

timeout 30000
listen 3000

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on


# Set the path of the log files inside the log folder of the testapp
stderr_path "/media/sf_C_DRIVE/blog/log/unicorn.stderr.log"
stdout_path "/media/sf_C_DRIVE/blog/log/unicorn.stdout.log"

before_fork do |server, worker|
  # ѕеред тем, как создать первый рабочий процесс, мастер отсоедин€етс€ от базы.
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  # ѕосле того как рабочий процесс создан, он устанавливает соединение с базой.
  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
end
