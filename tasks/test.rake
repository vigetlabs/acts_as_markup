require 'rake/testtask'
if HAVE_RCOV
  require 'rcov/rcovtask'
end

namespace :test do

  Rake::TestTask.new(:run) do |t|
    t.libs = PROJ.libs
    t.test_files = if test(?f, PROJ.test.file) then [PROJ.test.file]
                   else PROJ.test.files end
    t.ruby_opts += PROJ.ruby_opts
    t.ruby_opts += PROJ.test.opts
  end

  if HAVE_RCOV
    desc 'Run rcov on the unit tests'
    Rcov::RcovTask.new do |t|
      t.pattern = PROJ.rcov.pattern
      t.rcov_opts = PROJ.rcov.opts
    end
  end

end  # namespace :test

desc 'Alias to test:run'
task :test => 'test:run'

task :clobber => 'test:clobber_rcov' if HAVE_RCOV
