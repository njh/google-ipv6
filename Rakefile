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

desc "Create index HTML file"
file 'public/index.html' => ['worldmap.js'] do
  ruby 'build-index.rb'
end

desc "Create country graph HTML files"
task :build_graphs do
  ruby 'build-graphs.rb'
end

desc "Generate all the HTML files"
task :build => ['public/index.html', :build_graphs]


task :default => [:clean, :build]

task :clean do
  rm Dir.glob('public/*.html'), :force => true
  rm 'worldmap.js', :force => true
end
