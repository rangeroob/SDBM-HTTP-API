# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

namespace :db do
  desc 'Create database'
  task :create, [:database_name] do |_t, args|
    Dir.mkdir('db') unless File.exist?('db')
    require 'sdbm'
    SDBM.open("db/#{args.database_name}") do |db|
      db['hello'] = 'world'
    end
  end
end

namespace :log do
  desc 'Create empty log directory'
  task :create do |_t, _args|
    Dir.mkdir('log') unless File.exist?('log')
  end
end
