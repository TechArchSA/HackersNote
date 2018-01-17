module HackerNote
  class Git

    def pwd
      Dir.pwd
    end

    # Setup git repo
    def setup(project, git_url='')
      puts '[+] '.bold + 'Git Setup:'.bold.underline
      git = find_executable0 'git'
      git_cmds =
          [
              "git init", "git add *",
              "git commit -m 'Initial #{project} commit'",
              "git remote set-url origin #{git_url}"
          ]
      if git
        puts '[>] '.bold + "Found 'git' installed!"
        puts '[-] '.bold + "Initiating local git repository."
        git_cmds.each do |cmd|
          puts "[>] ".bold + "executing: " + "#{cmd}".dark_green
          `#{cmd}`
        end
      else
        puts '[x] '.red.bold + "git command can't be found."
        puts '[!] '.yellow + "Please install 'git' command then do the following:"
        puts dont_forget(project)
      end

    end


    def dont_forget(project)
      "
        cd #{project}
        git init
        git add *
        git commit -m 'Initial #{project} commit'
        git remote set-url origin https://github.com/[USERNAME]/#{project}.git
        git push origin master
        git checkout -b YourName
        git push origin YourName
    "
    end
  end
end