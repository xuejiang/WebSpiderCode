# == Synopsis
#
# This is a test to extract giving url's data.
#
# == Usage
#
#    ruby mechanize_test_extraction.rb -u <url> -r <reg>
#       -u  url, tell where to get the page. eg. http://www.google.com
#       -r  regular string, tell how to get the main data from the page. eg. '[a-z]+'

# command line argument parsing
require 'optparse'
require 'rdoc/usage'
require 'pp'

# mechanize lib
require 'rubygems'
require 'logger'
require 'mechanize'
require 'hpricot'

# re-use Exception
class Exception
  attr_accessor :method_name
end

class ExtractException < Exception ; end

# define main class
class DataExtractor
  def print_and_exit(msg)
      puts
      puts '*** ERROR ***'
      puts msg
      puts
      exit
  end
  
  def initialize(args)
    print_and_exit($USAGE) if args.length == 0
    
    opt = OptionParser.new
    opt.on('-h', '--help') { RDoc::usage}
    opt.on('-u', '--url url') { |url| @url = url }
    opt.on('-r', '--regular reg') { |reg| @reg = Regexp.new(reg.to_s) }
    opt.parse!(args) rescue RDoc::usage
    print_and_exit('please provide the url with -u <url>') if @url.nil?
  end
  
  # got page
  def get_page(url)
    agent = Mechanize.new {|m| m.log = Logger.new("data_extraction_#{@url}.log")}
    agent.user_agent_alias = 'Linux  Mozilla'
    
  end
  
  def run
    puts "run........."
    puts @url
    pp @reg
    page = get_page(@url)
    exit
  end
end

#run script
DataExtractor.new(ARGV).run if __FILE__ == $0