module HackerNote
  class Git

    attr_accessor :git
    def initialize
      # Find git command in the system
      @git = find_executable0 'git'
    end

    # Setup git repository
    #
    # @param project [String] the project name
    # @param git_url [String] the remote git repository URL
    def setup(project, git_url='')
      puts '[+] '.bold + 'Git Setup:'.bold.underline

      git_cmds =
          [
              "git init",
              "git add -A",
              "git commit -m 'Initial #{project} commit'",
              "git remote add origin #{git_url}",
              "git push origin master",
              "git checkout -b YourName",
              "git push origin YourName"
          ]
      if @git
        puts '[>] '.bold + "Found 'git' installed!"
        puts '[-] '.bold + "Initiating local git repository."
        git_cmds.first(4).each do |cmd|
          puts "[>] ".bold + "executing: " + "#{cmd}".dark_green
          `#{cmd}`
        end
        puts "[!] ".yellow + "Please do not forget to:".underline
        git_cmds.last(3).each {|cmd| puts "$ ".bold + "#{cmd}".dark_green}
      else
        puts '[x] '.red.bold + "git command can't be found (or you didn't use '--git' switch)."
        puts '[!] '.yellow + "Please install 'git' command then do the following (or use --git switch if git is installed):"
        git_cmds.each {|cmd| puts "$> ".bold + "#{cmd}".dark_green}
      end

    end

  end
end