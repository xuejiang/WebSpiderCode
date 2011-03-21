# login ganji.com and post jobs
require 'rubygems'
require 'logger'
require 'mechanize'
require 'hpricot'

#change html parser from Nokogiri to Hpricot
Mechanize.html_parser = Hpricot  

#agent
# agent = Mechanize.new {|m| m.log = Logger.new(STDERR)}
  agent = Mechanize.new {|m| m.log = Logger.new('mechanize_log.log')}
  agent.user_agent_alias = 'Linux  Mozilla' #Mechanize::AGENT_ALIASES.keys
#Login
def page_login
  page_login = agent.get("http://www.ganji.com/user/login.php");nil
  #got login form
  form_login = page_login.form_with(:action => '/user/login.php');nil
  #assign text field
  form_login['email'] = 'kenrome@163.com'
  form_login['password'] = '0020010'
  #submit form
  agent.submit(form_login);nil
end

#Post message
page_post = agent.get("http://cd.ganji.com/common/pub.php?category=parttime_wanted&type=20&biz_type=&district_id=3&street_id=-1&re=1");nil
  #got post form
  form_post = page_post.form_with( :enctype => "multipart/form-data")
  #assign value
  form_post['title'] = 'web2.0 web disign, developer'
  form_post['description'] = 'web2.0网络推广专员，为您提供大型社区网站提供自动化网络推广服务，新浪微薄，赶紧，58，豆瓣等。This guide is meant to get you started using Mechanize. By the end of this guide, you should be able to fetch pages, click links'
  form_post.radiobuttons_with(:name => 'agent')[1].check #不是中介
  form_post.radiobuttons_with(:name => 'fee_status')[0].check #不收费
  form_post['person'] = 'Song Sir'
  form_post['phone'] = '15928661802'
  agent.submit(form_post);nil
  