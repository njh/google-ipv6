#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require(:default)

data = []
File.open('worldmap.js') do |file|

  file.each do |line|
    if line =~ /(\["\w\w", .+\]),/
      row = JSON.parse($1)
      data << {
        :code => row[0],
        :name => row[1],
        :adoption => row[2],
        :latency => row[3],
        :impact => row[4],
        :color => row[5]
      }
    end
  end

end

data.sort! {|a,b| b[:adoption] <=> a[:adoption] }

File.open("google-ipv6-by-country-#{Date.today}.json", 'wb') do |file|
  file.write JSON.pretty_generate(data)
end



template = Tilt::ErubisTemplate.new(
  "index.html.erb",
  :escape_html => true
)

File.open('index.html', 'wb') do |file|
  file.write template.render(self, :data => data)
end

