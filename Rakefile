#!/usr/bin/env ruby

Rake::FileUtilsExt.verbose_flag = false


desc "Download the current Google data"
file 'worldmap.js' do |task|
  sh 'curl',
     '--fail',
     '--silent',
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
  rm 'worldmap.js', :force => true
end
