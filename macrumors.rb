require 'rubygems'
require 'sinatra'
require 'builder'
require 'open-uri'
require 'hpricot'

get '/' do
  @h = open 'http://www.macrumors.com' do |f| Hpricot f end

  content_type 'application/xml', :charset => 'utf-8'
  builder :index
end

__END__
@@ index
xml.instruct!
xml.rss :version => 0.91 do
  xml.channel do
    xml.title 'MacRumors : Mac News and Rumors'
    xml.link 'http://www.macrumors.com'
    xml.description 'the mac news you care about'
    (@h / '.story').each do |s|
      xml.item do
        xml.title s.at('h3').inner_text
        xml.pubDate s.at('.datetag').inner_html.sub(/<br.*/, '')
        xml.link s.at('h3 a')['href']
        xml.description s.at('.storybody').inner_html
      end
    end
  end
end
