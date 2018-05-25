# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/rendezvouses/version"

Gem::Specification.new do |s|
  s.version = Decidim::Rendezvouses.version
  s.authors = ["Diego Ramírez"]
  s.email = ["diegocrzt@gmail.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-rendezvouses"
  s.required_ruby_version = ">= 2.3.1"

  s.name = "decidim-rendezvouses"
  s.summary = "A decidim rendezvouses module"
  s.description = "Provide Rendezvous point management for decidim events."

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::Rendezvouses.version
end
