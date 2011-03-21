#use $USAGE
$USAGE = <<EOT
 # some info
EOT

#or

#use RDoc::usage 
# == Synopsis
#
# This is a test
#
# == Usage
#
#    ruby <site>_data_extraction.rb -h
#    ruby <site>_data_extraction.rb -i <dik>
#
#         <site>      site name/project name. eg. 'Olive'
#         -h          show help
#         -i <dik>    data import key, eg. '2011.10.31'
#         -e <env>    assign the rails environment, eg. 'test'

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
    opt.on('-h', '--help') { print_and_exit($USAGE)}
    opt.on('-i', '--data-import-key dik') { |dik| @dik = dik }
    opt.on('-e', '--environment env') { |env| @env = env.downcase }
    opt.parse!(args)
    print_and_exit('please provide data import key with -i <dik>') if @dik.nil?
  end
  
  def run
    puts "run........."
    exit
  end
end

#run script
DataExtractor.new(ARGV).run if __FILE__ == $0