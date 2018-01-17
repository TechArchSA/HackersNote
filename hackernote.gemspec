
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hackernote"

# class String
#   def red; colorize(self, "\e[1m\e[31m"); end
#   def bold; colorize(self, "\e[1m"); end
#   def reset; colorize(self, "\e[0m\e[28m"); end
#   def colorize(text, color_code) "#{color_code}#{text}\e[0m" end
# end
#
# def logo
#   slogan = 'The Cyber Daemons - '.reset + 'TechArch'.bold
#   %Q{
#               ______
#         '!!""""""""""""*!!'
#      .u$"!'            .!!"$"
#      *$!        'z`        ($!
#      +$-       .$$&`       !$!
#      +$-      `$$$$3       !$!
#      +$'   !!  '!$!   !!   !$!
#      +$'  ($$.  !$!  '$$!  !$!
#      +$'  $$$$  !$!  $$$$  !$!
#      +$'  .$"   !$!   3$   !$!
#      ($!  `$%`  !3!  .$%   ($!
#       ($(` '"$!    `*$"` ."$!
#        `($(` '"$!.($". ."$!
#          `($(` !$$%. ."$!
#            `!$%$! !$%$!
#               `     `
#                      #{slogan}
#   }.red.bold
# end

Gem::Specification.new do |spec|
  spec.name          = "hackernote"
  spec.version       = HackerNote::VERSION
  spec.authors       = ["KING SABRI"]
  spec.email         = ["king.sabri@gmail.com"]

  spec.summary       = %q{Hacker's Note - A command-line tool creates gitbook compatible structure for pentest and read team projects.}
  spec.description   = %Q{Hacker's Note - A command-line tool creates gitbook compatible structure for pentest and read team projects.\nHelps security professionals to organize their notes in a gitbook structure for PT/RT engagements.}
  spec.homepage      = "https://github.com/TechArchSA/HackersNote"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/})}
  spec.bindir        = "bin"
  spec.executables   = ['hackernote']
  spec.require_paths = ["lib"]

  spec.post_install_message = HackerNote::Utils.logo
end
