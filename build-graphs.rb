#!/usr/bin/env ruby

require 'bundler/setup'
require 'time'
Bundler.require(:default)

countries = {
}


# First gather the data
Dir.glob('public/google-ipv6-by-country-*.json') do |filename|
  data = JSON.parse(File.read(filename))
  date = Time.parse(data['updated_at']).strftime('%Y-%m-%d')
  data['countries'].each do |country|
    code = country['code'].downcase
    countries[code] ||= {:name => country['name'], :code => code, :data => []}
    countries[code][:data] << {:date => date, :value => country['adoption']}
  end
end


# Second, write the HTML files
template = Tilt::ErubiTemplate.new(
  "country.html.erb",
  :escape_html => false
)

countries.values.each do |country|
  country[:data].sort! {|a,b| a[:date] <=> b[:date]}

  File.open("public/#{country[:code]}.html", 'wb') do |file|
    file.write template.render(
      self,
      :name => country[:name],
      :labels => JSON.generate(country[:data].map {|n| n[:date]}),
      :data => JSON.generate(country[:data].map {|n| n[:value]})
    )
  end

end



