require "bundler/gem_tasks"

namespace :docker do
  name = "phpmyadmin-backup"

  desc "Build #{name}"
  task :build do
    sh "docker build -t #{name} ."
  end

  desc "Run shell in #{name}"
  task :shell => :build do
    system "docker run --rm -it --entrypoint=sh #{name}"
  end

  desc "Run #{name} in docker"
  task :run => :build do
    system "docker run --rm -it #{name}"
  end

end
