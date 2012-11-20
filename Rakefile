# encoding: utf-8

task :default => :test

desc "Run only unit tests by default"
task :test => 'test:unit'

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'
include Rake::DSL

namespace :test do
  Rake::TestTask.new(:unit) do |test|
    test.libs << %w{ lib test }
    test.pattern = 'test/unit/*_test.rb'
    test.verbose = true
  end
  
  Rake::TestTask.new(:integration) do |test|
    test.libs << %w{ lib test }
    test.pattern = 'test/integration/*_test.rb'
    test.verbose = true
  end
  
  desc "Run all tests, including integration tests"
  task :all => [ :unit, :integration ]
end

require 'yard'
require 'yard/rake/yardoc_task'

desc "Generate documentation"
task :doc => 'doc:generate'

namespace :doc do
  GEM_ROOT = File.dirname(__FILE__)
  RDOC_ROOT = File.join(GEM_ROOT, 'doc')

  YARD::Rake::YardocTask.new(:generate) do |rdoc|
    rdoc.files = Dir.glob(File.join(GEM_ROOT, 'lib', '**', '*.rb')) +
      [ File.join(GEM_ROOT, 'README.markdown') ]
    rdoc.options = ['--output-dir', RDOC_ROOT, '--readme', 'README.markdown']
  end

  desc "Remove generated documentation"
  task :clobber do
    FileUtils.rm_rf(RDOC_ROOT) if File.exists?(RDOC_ROOT)
  end
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |t|
  t.libs << "test"
  t.pattern = 'test/unit/*_test.rb'
  # exclude loaded libraries from code analysis
  t.rcov_opts << '--exclude /gems/'
end
