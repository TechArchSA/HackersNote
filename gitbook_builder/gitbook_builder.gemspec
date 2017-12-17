
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gitbook_builder/version"

Gem::Specification.new do |spec|
  spec.name          = "gitbook_builder"
  spec.version       = GitbookBuilder::VERSION
  spec.authors       = ["KING SABRI"]
  spec.email         = ["king.sabri@gmail.com"]

  description = "gitbook_builder is a commandline tool that helps pentesters/redteamers to build gitbook structure for PT/RT engagements with complete and organized structure.
This make your technical documentation more professional and easier than just writing in some random text files

Structure example:
ProjectX/
  projectx.md
  scanning_and_enumeration.md
  critical.md
  high.md
  medium.md
  low.md
  informational.md
  notes.md

All what you need is to import it using gitbook desktop editor(https://www.gitbook.com/editor)"
  spec.summary       = %q{Gitbook project builder for penetration test and redteam projects.}
  spec.description   = description
  spec.homepage      = "https://github.com/TechArchSA/gitbook-builder/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
