require 'nokogiri'

require_relative 'old_site_urls'

$PORT = 5000
$DOMAIN = 'https://www.dartlang.org/'
$LOCALHOST = "http://localhost:#{$PORT}/"
$FIREBASE_TOKEN = ENV['FIREBASE_TOKEN']
$FIREBASE_PROJECT = ENV['FIREBASE_PROJECT'] || 'default'

puts "Parsing current sitemap.xml for all current URLs"
sitemap = File.open("_site/sitemap.xml") { |f| Nokogiri::XML(f) }
$NEW_URLS = sitemap.xpath("//xmlns:loc").map { |node| node.content }
$NEW_URLS.sort!

puts "Adding old site's sitemap URLs"
$URLS = $NEW_URLS | $OLD_SITE_URLS  # does not add URLs that already exist
$URLS.sort!

# Change dartlang.org to localhost:4000
$LOCALHOST_URLS = $URLS.map { |url| url.sub($DOMAIN, $LOCALHOST) }
$LOCALHOST_NEW_URLS = $NEW_URLS.map { |url| url.sub($DOMAIN, $LOCALHOST) }