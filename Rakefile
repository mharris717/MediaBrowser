require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "MediaBrowser"
    s.summary = %Q{TODO}
    s.email = "GFunk913@gmail.com"
    s.homepage = "http://github.com/GFunk911/MediaBrowser"
    s.description = "TODO"
    s.authors = ["Mike Harris"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'MediaBrowser'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << 'lib' << 'spec'
  t.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |t|
  t.libs << 'lib' << 'spec'
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
rescue LoadError
  puts "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
end

task :default => :spec

task :save_mocks do
  require "lib/MediaBrowser"
  MediaBrowser::Dir.mock_dir.media.each { |x| x.save! }
end

task :save_actual do
  require "lib/MediaBrowser"
  MediaBrowser::Dir.new(:path => "/Volumes/Drobo/TV").media.each { |x| x.save! }
end

task :link_actual do
  require "lib/MediaBrowser"
  MediaBrowser::Dir.new(:path => "/Volumes/Drobo/TV").media.each { |x| x.make_link!("I:/LinkDir") }
end
