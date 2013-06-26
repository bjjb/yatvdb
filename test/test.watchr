#!/usr/bin/env watchr
watch('^test/(.*)_test\.rb') { |m| ruby m[0] }
watch('^lib/(.*)\.rb') { |m| ruby "test/#{m[1]}_test.rb" }
watch('^test/test_helper\.rb') { ruby Dir['test/**/*_test.rb'] }

Signal.trap('QUIT') { ruby Dir['test/**/*_test.rb'] }
Signal.trap('INT') { abort("\n") }

def ruby(*paths)
  paths.flatten.each { |path| run "ruby -I.:lib:test #{path}" }
end

def run(cmd)
  system cmd
end
# vi:ft=ruby
