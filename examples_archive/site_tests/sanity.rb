require "jekyll"
require "selenium-webdriver"

class SanityTest
  def initialize(base = nil)
    Dir.chdir("src/site")

    if base.nil?
      base = "http://localhost:8081/"
      # Jekyll serve the local copy.
      options = {"watch" => true, "port" => 8081}
      @server, @server_thread = Jekyll::Commands::Serve.spin_off(options)
    end

    @driver = Selenium::WebDriver.for :firefox
    @driver.navigate.to base
  end

  def test
    test_homepage
    test_darrrt

    puts "All sanity checks passed."
  ensure
    @driver.quit
    @server.shutdown if @server
    @server_thread.join if @server_thread
  end

  def expect(expected, actual, description="")
    unless expected == actual
      puts "Error: #{description}"
      puts "  Expected #{expected.inspect} to be equal to #{actual.inspect}"
      raise StandardError
    end
  end

  def expect_text_at(expected, *selector)
    actual = @driver.find_element(*selector).text.strip
    expect(expected, actual, "Text at #{selector} should be expected.")
  end

  def test_homepage
    # Find each navigation link.
    expect_text_at("GET STARTED", :xpath, "//ul[contains(@class,'nav')][1]/li[1]")
    expect_text_at("FUNDAMENTALS", :xpath, "//ul[contains(@class,'nav')][1]/li[2]")
    expect_text_at("BROWSER", :xpath, "//ul[contains(@class,'nav')][1]/li[3]")
    expect_text_at("SERVER", :xpath, "//ul[contains(@class,'nav')][1]/li[4]")
    expect_text_at("MORE", :xpath, "//ul[contains(@class,'nav')][1]/li[5]")

    # Find the download link at the top.
    @driver.find_element(:css, ".downloads a.download-link")

    # Dart is new, yet familiar carousel.
    examples = @driver.find_elements(:css, ".dart-new-language .item")
    expect("block", examples[0].css_value("display"),
           "First new, yet familiar example should be shown.")
    expect("none", examples[1].css_value("display"),
           "Second new, yet familiar example should be hidden.")

    carousel_links = @driver.find_elements(:css, ".dart-new-language .carousel-indicators li")
    carousel_links[1].click

    Selenium::WebDriver::Wait.new.until {
      examples[0].css_value("display") == "none"
    }
    expect("none", examples[0].css_value("display"),
           "First new, yet familiar example should be hidden.")
    expect("block", examples[1].css_value("display"),
           "Second new, yet familiar example should be shown.")
  end

  def test_darrrt
    # Click "Get Started".
    @driver.find_element(:css, ".nav li:first-child a").click
    Selenium::WebDriver::Wait.new.until {
      iframe = @driver.find_element(:css, ".nav li:first-child ul a:first-child")
    }

    # Click "Learn Dart in Minutes".
    @driver.find_element(:css, ".nav li:first-child ul a:first-child").click
    Selenium::WebDriver::Wait.new.until {
      iframe = @driver.find_element(:css, ".running-app-frame")
    }

    # Open the top iframe.
    step_6_src = @driver.find_element(:css, ".running-app-frame").attribute("src")
    @driver.navigate.to step_6_src

    # When I type "Sam", I should see "Sam" in the badge.
    @driver.find_element(:id, "inputName").send_keys("Sam")
    badge_text = @driver.find_element(:id, "badgeName").text
    expect("Sam", badge_text.split(' ')[0], "Pirate badge should write my name")
    sleep 2
  end
end

class Jekyll::Commands::Serve
  class << self
    def spin_off(options)
      # All borrowed from Jekyll::Command::Server.init_with_program and .process
      options["serving"] = true
      options = Jekyll::Command.configuration_from_options(options)
      destination = options["destination"]
      Jekyll::Commands::Build.process(options)
      setup(destination)

      s = WEBrick::HTTPServer.new(webrick_options(options))
      s.unmount("")

      s.mount(
        options['baseurl'],
        WEBrick::HTTPServlet::FileHandler,
        destination,
        file_handler_options
      )

      Jekyll.logger.info "Server address:", server_address(s, options)
      thread = Thread.new { s.start }

      [s, thread]
    end
  end
end

SanityTest.new(ARGV.shift).test
