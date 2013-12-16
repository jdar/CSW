require 'capybara/cucumber'
require 'selenium/webdriver'
#require 'fast-selenium' #speedup. requires curl
#require 'parallel'
WebMock.disable_net_connect!(:allow_localhost => true,:allow=>/browserstack/)

browsers = JSON.parse(File.read "features/support/supported_browsers.json")
def open_tunnel!
  Capybara.default_wait_time = 5
  Capybara.server_port = 3000 #TODO
  sleep 3
  `java -jar features/support/BrowserStackTunnel.jar #{ENV['BS_AUTHKEY']} 127.0.0.1,#{Capybara.server_port},0 -v >log/browserstack.log 2>&1 &`
  sleep 3
  #until (`curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:45691`.to_i == 200)
  #  sleep 1
  #end
end
at_exit do
  `ps -ef | awk '/BrowserStackTunnel.*,#{Capybara.server_port},/{print $2}' | xargs kill -9`
end

$capybara_drivers ||= {}
def find_and_register_driver(browser)
  url = "http://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub.browserstack.com/wd/hub"
  browser[:symbol] ||= %w(os os_version browser browser_version).inject([]){|str,k| str << browser[k] }.compact.join("_").to_sym
  $capybara_drivers[browser[:symbol]] ||= begin
    Capybara.register_driver browser[:symbol] do |app|
      capabilities = Selenium::WebDriver::Remote::Capabilities.new
      capabilities['os'] = browser['os']
      capabilities['os_version'] =  browser['os_version']
      capabilities['browser'] =  browser['browser']
      capabilities['browser_version'] =  browser['browser_version']
      capabilities['browserstack.tunnel'] = 'true'
      capabilities['browserstack.debug'] = 'true'

      Selenium::WebDriver.for(:remote, :url => url, :desired_capabilities => capabilities)
    end
  end
  browser[:symbol]
end
=begin
#original capybara example
url = "http://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub.browserstack.com/wd/hub"
capabilities = Selenium::WebDriver::Remote::Capabilities.internet_explorer
capabilities.version = "10.0"
capabilities.platform = :WINDOWS
 
Capybara.register_driver :browser_stack do |app|
Capybara::Selenium::Driver.new(app,
  :browser => :remote, :url => url,
  :desired_capabilities => capabilities)
end
=end
Around("@xbrowser") do |scenario,block|
  orig_driver = Capybara.default_driver
  $only_open_tunnel_once ||= (open_tunnel! || true)
  begin
    browser = browsers[0]
    #Parallel.map(browsers, :in_threads => 1) do |browser|
      #GOTCHA: apparently must assign by symbol.
      Capybara.default_driver = find_and_register_driver(browser)
      block.call
    #end
  ensure
    Capybara.default_driver = orig_driver
  end
end


