require 'rake/testtask'
Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = true
  t.verbose = true
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new

desc 'Run all tests by default'
task default: %w[rubocop test]
