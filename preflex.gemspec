require_relative "lib/preflex/version"

Gem::Specification.new do |spec|
  spec.name        = "preflex"
  spec.version     = Preflex::VERSION
  spec.authors     = ["Owais"]
  spec.email       = ["owaiswiz@gmail.com"]
  spec.homepage    = "https://github.com/owaiswiz/preflex"
  spec.summary     = "A simple but powerful Rails engine for storing preferences, feature flags, etc. With support for reading/writing values client-side!"
  spec.description = "A simple but powerful Rails engine for storing preferences, feature flags, etc. With support for reading/writing values client-side! "
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/owaiswiz/preflex"
  spec.metadata["changelog_uri"] = "https://github.com/owaiswiz/preflex/releases"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.3"
end
