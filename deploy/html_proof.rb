#!/usr/bin/env ruby

require 'html-proofer'
require 'net/http'
require 'tempfile'

require_relative 'urls/get_all'

if !$FIREBASE_TOKEN
  puts "#{$PROGRAM_NAME}: FIREBASE_TOKEN environment variable isn't defined. Skipping checks."
  exit(0)
end

puts "===== Checking HTML and outbound links through HTMLProofer ====="

# TODO(filiph) remove when not needed
$LOCALHOST_NEW_URLS.delete("#{$LOCALHOST}events/2016/summit/index.html")

puts "Spawning firebase server on localhost"
pid = spawn("firebase serve --port #{$PORT} --token '#{$FIREBASE_TOKEN}' --project #{$FIREBASE_PROJECT}", :out => "/dev/null")
puts "..."
sleep 5

begin
  puts "Checking contents"
  errors = 0
  $LOCALHOST_NEW_URLS.each do |url|
    uri = URI(url)
    # Show the jekyll port (instead of the firebase one) for easier
    # click-throughs.
    puts "- #{url.sub(":#{$PORT}", ":4000")}"
    source = Net::HTTP.get(uri)
    file = Tempfile.new([uri.path.gsub(/\//, '___') + '_____', '.html'])
    begin
      file.write(source)
    ensure
      file.close
    end

    begin
      HTMLProofer.check_file(file.path, {
        :url_swap => {
            # HTMLProofer expects files in the same directory.
            # Swap all "/..." (absolute) links to "http://localhost.../..."
            /^\/(.*)/ => "#{$LOCALHOST}\\1",
            # Swap all relative "path/to/subdir" (relative) links to
            # "{{current_uri}}/path/to/subdir"
            /^(?!(\/|#|https?:\/\/))(.+)/ => "#{uri}/\\1"
        },
        :check_external_hash => true,
        # :check_favicon => true,
        :check_html => true,
        :validation => {
          # :report_missing_names => true
        },
        :cache => {
          :timeframe => '7d'
        },
        :log_level => :warn
      }).run
    rescue RuntimeError => e
      errors += 1
    ensure
       file.unlink  # deletes the temp file
    end
  end
  if errors > 0 then
    raise "There were #{errors} URLs with errors"
  else
    puts "No errors!"
  end
ensure
  puts "Killing firebase server on localhost"
  Process.kill(:SIGINT, pid)
end