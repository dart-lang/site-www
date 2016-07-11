#!/usr/bin/env ruby

require 'html-proofer'

require_relative 'urls/get_all'

puts "===== Checking inbound links and redirects through HTMLProofer ====="

# TODO(filiph) remove when not needed
$LOCALHOST_URLS.delete("#{$LOCALHOST}events/2016/summit/index.html")

puts "Spawning firebase server on localhost"
pid = spawn("firebase serve --port #{$PORT}", :out => "/dev/null")
puts "..."
sleep 5

begin
  puts "Checking links"
  HTMLProofer.check_links($LOCALHOST_URLS, {
    :log_level => :warn
  }).run
  puts "Done"
ensure
  puts "Killing firebase server on localhost"
  Process.kill(:SIGINT, pid)
end