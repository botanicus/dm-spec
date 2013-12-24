begin
  require "rubygems/specification"
rescue SecurityError
  # http://gems.github.com
end

VERSION  = "0.9.10"
SPECIFICATION = ::Gem::Specification.new do |s|
  s.name = "dm-spec"
  # s.version = Rango::VERSION
  s.version = VERSION
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/dm-spec"
  s.summary = "Some rSpec matchers for DataMapper"
  # s.description = "" # TODO: long description
  s.cert_chain = nil
  s.email = Base64.decode64("c3Rhc3RueUAxMDFpZGVhcy5jeg==\n")
  s.files = `git ls-files`.split("\n")

  s.add_dependency "dm-core"
  s.require_paths = ["lib"]
  # s.required_ruby_version = ::Gem::Requirement.new(">= 1.9.1")
  # s.rubyforge_project = "rango"
end
