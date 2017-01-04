#!/usr/bin/env ruby

desc "Download the current Google data"
file 'worldmap.js' do |task|
  sh 'curl',
     '--fail',
     '--output', task.name,
     'https://www.google.com/intl/en_ALL/ipv6/statistics/data/worldmap.js'
end

desc "Create HTML file"
file 'index.html' => ['worldmap.js'] do
  ruby 'build-site.rb'
end

desc "Generate all the files"
task :build => ['index.html']


task :default => [:clean, :build]

task :clean do
  rm 'worldmap.js'
end
