#!/usr/bin/env ruby
# TechArch: www.techarch.com.sa
# @author : Sabri <@KINGSABRI>, Asim
#
# Gitbook project builder for penetration test projects
#
require 'fileutils'
require 'optparse'
require 'mkmf'
require 'pathname'
require 'find'
require 'readline'
require 'pp'

class String
  def bold; colorize(self, "\e[1m"); end
  def red; colorize(self, "\e[1m\e[31m"); end
  def reset; colorize(self, "\e[0m\e[28m"); end
  def underline; colorize(self, "\e[4m"); end
  def colorize(text, color_code) "#{color_code}#{text}\e[0m" end
  def mv_down(n=1) cursor(self, "\033[#{n}B") end
  def cls_upline; cursor(self, "\e[K") end
  def cursor(text, position)"\r#{position}#{text}" end
end
# Turn off makemakefile logging
module MakeMakefile::Logging
  @logfile = File::NULL
end

def ask(question, expected_answer)
  answer = ''
  until answer.match?(expected_answer)
    answer = Readline.readline(question, true)
  end
  return answer
end



#
# GitbookBuild, the main class
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

    puts
    puts '[+] '.bold + "Done!"
  end

  # set environment requirements
  def set_env
    set_project_dir
    set_targets_list
    Dir.chdir @project_path
  end

  # set the project main directory
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

  # check targets list,
  # if file read each line as a target,
  # if file not exists, consider the given name as a target
  # @return Array of target names
  def set_targets_list
    if File.file? @target_list
      @list_of_targets = File.open(@target_list).each_line(chomp: true).map(&:strip).reject(&:nil?).reject(&:empty?)
    else
      puts "[!] No targets list file, assuming '#{@target_list}' as a target name."
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

  # build project related files
  def build_targets_files
    puts '[-] '.bold + "Creating targets' files and directories."
    target_main_files = %W[scanning_and_enumeration.md critical.md high.md medium.md low.md informational.md notes.md]

    @list_of_targets.each do |target|
      target_files = target_main_files.dup
      target_files.unshift "#{target}.md"
      Dir.mkdir(target)
      # create_summary_record("#{target}/#{target}.md")
      create_summary_record(target)

      target_files.each do |t_file|
        file_path = File.join(target, t_file)
        heading1 = t_file.split('.md').first.capitalize   # Each file's title
        File.write(file_path, "# #{heading1}\n\n")
        create_summary_record(file_path.to_s) unless heading1 =~ /#{target}/i
      end

    end
  end

  # Create summary records @see #build_target_files
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
    sleep 0.02
  end

  # README.md generator
  def build_project_readme
    readme = <<~README
      # #{@project_name}
      ## Customer Requests and Concerns
      1.
      2.
      3.

      | Timeline | Date |
      | :--- | :--- |
      | Project Testing Start | |
      | Project Testing End | 19-October-2017 |

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
  end
end

# TODO
class Git
  def self.need_help?
    help = nil
    until help =~ /[y|n]/i
      puts
      puts '[+] '.bold + 'Git Setup:'.bold.underline
      print '[>] '.bold + 'Do you want me to help you configure the repository? [Y/n]: '
      help = gets.chomp
    end
    if help =~ /y/i
      return true
    else
      return false
    end
  end

  def self.setup(project)
    puts '[+] '.bold + 'Git Setup:'.bold.underline
    git = find_executable0 'git'

    if git
      puts '[>] '.bold + "Found 'git' installed!"
      puts '[-] '.bold + "Initiating local git repository."
      Dir.chdir project
      `git init`
      `git add *`
      `git commit -m 'Initial #{project} commit'`
    else
      puts '[>] '.bold + "git command is not install."
      puts dont_forget(project)
    end

  end

  def dont_forget(project)
    "
    > Create a new project repository. Use naming schema
      example:
      [ServiceTag]_[CustomerName]_[TestType]_[Date]
      PT_AwesomeCustomer_WebApp_01-01-2030
    git remote set-url origin https://github.com/TechArchSA/#{project}.git
    git push origin master
    git checkout -b YourName
    git push origin YourName
    "
  end
end

def banner
    slogan = 'The Cyber Daemons - '.reset + 'TechArch'.bold
    logo = %Q{
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
options = {}
option_parser = OptionParser.new
option_parser.banner = "#{"Gitbook Builder".bold} - Helps pentesters to build gitbook structure for PT engagements."
option_parser.set_summary_indent '   '
option_parser.separator "\nHelp menu:".underline
option_parser.on('-p', '--project PROJECT_NAME', "Project Name") {|v| options[:project] = v}
option_parser.on('-l', '--list TARGET_LIST' , 'The target name or a text file contains list of targets') {|v| options[:list] = v}
option_parser.on('-h', '--help', 'Show this help message') {puts banner , option_parser; exit!}
option_parser.on_tail "\nUsage:\n".underline + "  ruby #{__FILE__} --project <project_name> --list <targetlist.txt>"
option_parser.on_tail "\nExample:\n".underline + "  ruby #{__FILE__} --project PT_CustomerName_WebApp_01-01-2030 --list target_list.txt\n\n"
option_parser.on_tail "\nExample:\n".underline + "  ruby #{__FILE__} -p PT_CustomerName_WebApp_01-01-2030 -l example.com\n\n"

begin
  option_parser.parse!
  gitbook = GitbookBuilder.new
  case
  when options[:project] && options[:list]
    gitbook.build(options[:project], options[:list])
    Git.setup(options[:project]) if Git.need_help?
  when options[:project].nil? && options[:list].nil?
    puts banner
    puts option_parser
  when options[:project].nil?
    puts '[!] '.red + "Missing mandatory switch '-p/--project'"
    puts option_parser
  when options[:list].nil?
    puts '[!] '.red + "Missing mandatory switch '-l/--list'"
    puts option_parser
  end
rescue OptionParser::MissingArgument => e
  e.args.each {|arg| puts '[!] '.red + "#{e.reason.capitalize} for '#{arg}' option."}
  puts option_parser
rescue OptionParser::InvalidOption => e
  puts '[!] '.red + "#{e}"
  puts option_parser
rescue Exception => e
  puts e.backtrace
  puts e.backtrace_locations
  puts e
end
