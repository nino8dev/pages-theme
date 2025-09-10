Gem::Specification.new do |s|
  s.name        = "pages-theme"
  s.version     = "0.1.0"
  s.summary     = "nino8dev local dev theme"
  s.authors     = ["nino8dev"]
  s.license     = "MIT"
  s.files       = Dir["**/*", "!**/*.gem", "!Gemfile.lock"]
  s.add_runtime_dependency "jekyll", ">= 4.0", "< 5.0"
end
