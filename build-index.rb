#!/usr/bin/env ruby

require 'bundler/setup'
require 'time'
Bundler.require(:default)

data = {
  :countries => []
}

File.open('worldmap.js') do |file|

  file.each do |line|
    if line =~ /Per country IPv6 data, as of (.+)\./
      data[:updated_at] = Time.parse($1)
    elsif line =~ /(\["\w\w", .+\]),/
      row = JSON.parse($1)
      data[:countries] << {
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

data[:countries].sort! {|a,b| b[:adoption] <=> a[:adoption] }

File.open("public/google-ipv6-by-country-#{Date.today}.json", 'wb') do |file|
  file.write JSON.pretty_generate(data)
end



def flag_img(code)
  png_file = "flags/#{code.downcase}.png"
  png_file = "flags/zz.png" unless File.exist?("public/#{png_file}")
  "<a href='https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2##{code}' title='#{code}'>"+
  "<img class='flag' src='#{png_file}' width='16' height='11' alt='Flag for #{code}' />"+
  "</a>"
end


template = Tilt::ErubisTemplate.new(
  "index.html.erb",
  :escape_html => true
)

File.open('public/index.html', 'wb') do |file|
  file.write template.render(self, :data => data)
end

