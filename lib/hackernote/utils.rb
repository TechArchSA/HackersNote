module HackerNote
  module Utils

    # fix target/project name if the target is a URL (eg. http://example.com/app1/route2/)
    # @return [String]
    def fix_project_naming(project)
      project.gsub(/http[:|s]+\/\//, '').gsub('/', '-').gsub(/-*$/, '')
    end

    def self.logo
      slogan = 'The Cyber Daemons - '.reset + 'TechArch'.bold
      %Q{
              ______
        '!!""""""""""""*!!'
     .u$"!'            .!!"$"
     *$!        'z`        ($!
     +$-       .$$&`       !$!
     +$-      `$$$$3       !$!
     +$'   !!  '!$!   !!   !$!
     +$'  ($$.  !$!  '$$!  !$!
     +$'  $$$$  !$!  $$$$  !$!
     +$'  .$"   !$!   3$   !$!
     ($!  `$%`  !3!  .$%   ($!
      ($(` '"$!    `*$"` ."$!
       `($(` '"$!.($". ."$!
         `($(` !$$%. ."$!
           `!$%$! !$%$!
              `     `
                     #{slogan}
      }.red.bold
    end

    # banner
    def self.banner
      version = "v#{HackerNote::VERSION}".underline.reset
      %Q{
                                 ______            ____                                                 ______              ____
     |         |      .'.      .~      ~.|    ..''|          |`````````,         ..'''' |..          |.~      ~.`````|`````|
     |_________|    .''```.   |          |..''    |______    |'''|'''''       .''       |  ``..      |          |    |     |______
     |         |  .'       `. |          |``..    |          |    `.       ..'          |      ``..  |          |    |     |
     |         |.'           `.`.______.'|    ``..|__________|      `....''             |          ``|`.______.'     |     |___________
                                                                                                                                 #{version}
      }.bold
    end

    # ask method for interactive session with user
    def ask(question, expected_answer)
      answer = ''
      until answer.match?(expected_answer)
        answer = Readline.readline(question, true)
      end

      answer
    end
  end
end