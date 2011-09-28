# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
require 'rspec/core/rake_task'

Massgameshvz::Application.load_tasks

Rake::Task[:default].clear

namespace :rspec do
  RSpec::Core::RakeTask.new(:coverage => ['db:test:prepare']) do |t|
    t.pattern = "spec/**/*_spec.rb"
    t.ruby_opts = '-Ilib -Ispec -I.'
    t.rcov = true 
    t.verbose = false
    t.rcov_opts = %[-Ilib -Ispec --exclude "spec/*,gems/*,db/*,.ruby_versions/*,config/*,.bundle/*,.rvm/*,(erb),(__FORWARDABLE__),(eval),yaml/tag" --rails --sort coverage --text-summar]
  end
end