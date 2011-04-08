# == Synopsis
#
# This is a test to extract giving url's data.
# http://www.flickr.com/explore/interesting/7days/
# To do: extract 7days's one pic everyday.
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
# file write lib
require 'open-uri'

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
    
    #init agent
    init_mechanize
  end
  
  def init_mechanize
    @agent = Mechanize.new {|m| m.log = Logger.new("data_extraction_1.log")}
    @agent.user_agent_alias = 'Linux Mozilla'
    @agent.open_timeout = 30
  end
  
  # get page
  def get_page(url)
    begin
      return @agent.get(url)
    rescue ExtractException => ex
      puts ex.message
      return nil
    end
  end
  
  def run
    puts "....start...."
    puts @url
    puts @reg
    #- list page
    # http://www.flickr.com/explore/interesting/7days/
    page = get_page(@url)
    print_and_exit('load page error, please check your giving url.') if page.nil?
    #- picture page
    doc = Hpricot(page.body)
    #test
    File.new("page.html", "w").write(page.body)
    
    pic_list = doc.search("//table.TwentyFour/tr/td.Photo")
    pic_page = @agent.click(pic_list.first.at("//a"))  #only got first
    doc = Hpricot(pic_page.body)
    #test
    File.new("pic_page.html", "w").write(pic_page.body)
    pic_url = doc.at("//div.photo-div/img")[:src]
    extend_type = pic_url.split('.').pop
    pic_title = doc.at("//h1.photo-title").inner_text
    puts pic_url
    puts pic_title
    
    save_picture_to_file(pic_url, pic_title, extend_type)
  end
  
  def save_picture_to_file(pic_url, pic_title, extend_type)
    pic_name = pic_title.to_s + rand.to_s + '.' + extend_type
    unless File.exist?(format_file_name(pic_name))
      File.open(pic_name, 'wb') do |output|
        output << open(pic_url).read
      end
    end
  end
  
  def format_file_name(file_name)
    file_name.gsub(/[^a-z0-9.-]/i, '')
  end
end

#run script
DataExtractor.new(ARGV).run if __FILE__ == $0