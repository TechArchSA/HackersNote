module HackerNote
#
# GitbookBuild class
#
  class GitbookBuilder

    # Builder wrapper
    def build(project_name, target_list)
      @project_name = project_name
      @target_list  = target_list

      puts '[+] '.bold + 'Gitbook Setup:'.bold.underline
      set_env
      build_gitbook_files
      build_targets_files
      build_project_readme
      general_fixes
    end

    # set environment requirements
    def set_env
      set_project_dir
      set_targets_list
      Dir.chdir @project_path
    end

    # set the project main directory @see #set_env
    def set_project_dir
      @project_path = Pathname.new(@project_name).basename

      if Dir.exist?(@project_path)
        rename = "#{@project_path}_#{Time.now.to_i}"
        puts '[-] '.bold + "Renaming Existing directory '#{@project_path}' to '#{rename}'"
        FileUtils.mv(@project_path, rename)
      end

      puts '[-] '.bold + "Creating #{@project_name} directory"
      Dir.mkdir @project_name
    end

    # check targets list, @see #set_env
    # if file read each line as a target,
    # if file not exists, consider the given name as a target
    #
    # @return Array of target names
    def set_targets_list
      if File.file? @target_list
        @list_of_targets = File.open(@target_list).each_line(chomp: true).map(&:strip).reject(&:nil?).reject(&:empty?)
      else
        puts "[!] ".yellow + "No targets list file, assuming '#{@target_list}' as a target name."
        @list_of_targets = [@target_list]
      end
    end

    # build gitbook's main files such as book.json, SUMMARY.md and README.md
    def build_gitbook_files
      puts '[-] '.bold + "Creating gitbook's main files.'"
      prj_files = %w[book.json SUMMARY.md README.md]
      prj_files.each do |file|
        File.write(file, "# #{file.split('.').first.capitalize}\n\n")
      end
    end

    # build_targets_files builds project related files
    #
    # @example:
    #   targetX/
    #     scanning_and_enumeration.md
    #     critical.md
    #     high.md
    #     medium.md
    #     low.md
    #     informational.md
    #     notes.md
    def build_targets_files
      puts '[-] '.bold + "Creating targets' files and directories."
      target_main_files = %W[scanning_and_enumeration.md critical.md high.md medium.md low.md informational.md notes.md]

      @list_of_targets.each do |target|
        target = fix_project_naming(target)
        target_files = target_main_files.dup
        target_files.unshift "#{target}.md"
        Dir.mkdir(target)
        create_summary_record(target)
        target_files.each do |t_file|
          file_path = File.join(target, t_file)
          heading1 = t_file.split('.md').first.capitalize   # Each file's title
          File.write(file_path, "# #{heading1}\n\n")
          open(file_path, 'a') do |file|
            file.puts "# #{heading1}\n\n"
            file.puts build_target_notes if heading1.include? 'Notes'
          end
          create_summary_record(file_path.to_s) unless heading1 =~ /#{target}/i
        end

      end
    end

    # build_target_notes builds the content of notes file
    def build_target_notes
    <<~NOTES
    ## To Be Checked
    
    
    ## To Be Deleted

    * Users
      * user1
      * user2
    * Files/Directories/URL
      * filepath1
      * filepath1

      NOTES
    end

    # Create summary records @see #build_targets_files
    def create_summary_record(file_path)
      record = File.open('SUMMARY.md', 'a+')
      path = File.split file_path
      title = path.last.split('.md').first.capitalize
      path.delete_if {|p| p == '.'}
      align = "#{'  ' * path.index(path.last)}* "
      file_path = "#{file_path}/#{file_path}.md" if File.directory? file_path
      the_record = "#{align}[#{title}](#{file_path})"
      record.puts the_record
      print "\r#{the_record}".cls_upline
      sleep 0.1
    end

    # README.md generator
    def build_project_readme
      readme = <<~README
      # #{@project_name}
      ## Customer Requests and Concerns
      1. No DoS Attacks
      2.
      3.

      | Timeline | Date |
      | :--- | :--- |
      | Project Testing Start | 1/1/2030 |
      | Project Testing End | 1/1/2030 |

      ## Applications progress

      | Host/IP | # of issues | Progress % | Issues | Notes | misc. |
      | :--- | :--- | :--- | :--- | :--- | :--- |
      #{@list_of_targets.map {|host| "|#{host}  |  |  |  |  |  |" }.join("\n")}

      ### Point Of Contact
      | Name | email | Mobile number | Job title/Role |
      | :--- | :--- | :--- | :--- |
      | Firstname Lastname | email2@email.com | 0550000000 |  |

      ### Source IP Addresses log
      This list has to be regularly update!

      | Engineer 1 | Engineer 2 |
      | :--- | :--- |
      | x.x.x.x | y.y.y.y |
      | x.x.x.x | y.y.y.y |
      | x.x.x.x | y.y.y.y |

      ## Scope

      **Approach:**

      **IP ranges**

      **Domains**

      **Credentials**

      ## Clean up
      | Host | URL/Files | Description |
      | :--- | :--- | :--- |
      |  |  |
      README
      File.write('README.md', readme)
    end

    # general fixes
    def general_fixes
      # fix for book.json
      File.write('book.json', '{ }')
      # Create 'files' directory, general place for project related files and scripts
      Dir.mkdir 'files'
    end
  end

end