#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.require(:default)

countries = {
}


# First gather the data
Dir.glob('google-ipv6-by-country-*.json') do |filename|
  data = JSON.parse(File.read(filename))
  date = Time.parse(data['updated_at']).strftime('%Y-%m-%d')
  data['countries'].each do |country|
    code = country['code'].downcase
    countries[code] ||= {'name' => country['name'], 'data' => {}}
    countries[code]['data'][date] = country['adoption']
  end
end


# Second, write the HTML files
template = Tilt::ErubisTemplate.new(
  "country.html.erb",
  :escape_html => false
)

countries.each_pair do |country,data|

  File.open("#{country}.html", 'wb') do |file|
    file.write template.render(
      self,
      :name => data['name'],
      :labels => JSON.generate(data['data'].keys),
      :data => JSON.generate(data['data'].values)
    )
  end

end



