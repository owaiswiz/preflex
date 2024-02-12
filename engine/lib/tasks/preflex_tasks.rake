desc "Configure preflex"
task :preflex do
  system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../template/install.rb",  __dir__)}"
end
