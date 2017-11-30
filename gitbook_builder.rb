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
class GitbookBuilder  # TODO - write README

  # Builder wrapper
  def self.build(project_name, target_list)
    puts '[+] '.bold + 'Gitbook Setup:'.bold.underline
    target_list = set_env(project_name, target_list)

    build_gitbook_files(project_name)
    build_project_files(project_name, target_list)
    build_summary(project_name)
    general_fixes(project_name)

    puts '[+] '.bold + 'Done!'
  end

  # set environment requirements
  def self.set_env(project_name, target_list)
    if Dir.exist?(project_name)
      rename = "#{project_name}_#{Time.now.to_i}"
      puts '[-] '.bold + "Renaming Existing directory '#{project_name}' to '#{rename}'"
      FileUtils.mv(project_name, rename)
    end
    puts "[-]".bold + " Creating #{project_name} directory"
    Dir.mkdir project_name

    if File.file? target_list
      # @list = File.open(target_list).split("\n")
      # @list = File.open(target_list).each_line(chomp: true).reject(&:nil?)
      @list = File.open(target_list).each_line(chomp: true).reject(&:nil?)
      return @list
    else
      puts '[!] Please enter a proper file, wtf!'
      FileUtils.rm_rf(project_name)
      exit!
    end
  end

  # build the main files
  def self.build_gitbook_files(project_name)
    puts '[-] '.bold + 'Creating main files.'
    prj_files = %w[book.json SUMMARY.md README.md]
    prj_files.each do |file|
      new_file = File.join(project_name, file)
      File.write(new_file, "# #{file.split('.').first.capitalize}")
    end
  end

  # build project related files
  def self.build_project_files(project_name, target_list)
    puts '[-] '.bold + "Creating target's files and directories."
    trgt_files = %W[scanning_and_enumeration.md critical.md high.md medium.md low.md informational.md notes.md]
    target_list.each do |folder|
      new_dir = File.join(project_name, folder)
      FileUtils.mkdir_p(new_dir)
      trgt_files.unshift "#{folder}.md"

      trgt_files.each do |file|
        file_path = File.join(project_name, folder, file)
        File.write(file_path, "# #{file.split('.').first.capitalize}")
      end
    end
  end

  # SUMMARY structure
  #
  # * [Introduction](README.md)
  # * [Findings](findings/findings.md)
  #   * [Host 1](findings/host1/host1.md)
  #     * [Scanning & Enumeration](findings/host1/scanning-and-enumeration.md)
  #     * [Critical](findings/host1/critical.md)
  #     * [High](findings/host1/high.md)
  #     * [Medium](findings/host1/medium.md)
  #     * [Notes](notes.md)
  #   * [Host 2](findings/host2/host2.md)
  #     * ....
  def self.build_summary(project)
    root_path = Pathname.new(project).basename
    puts '[-] '.bold + "Changing directory to #{root_path}."
    summary_path = File.join(root_path, 'SUMMARY.md')
    file_list = Find.find("#{root_path}/")
    sorted    = file_list.sort_by {|file| File.mtime(file)}.map {|path| path.split('/')}  # Sort fy by creation as its been created by #build
    pos = '  '

    puts '[-] '.bold + "Generating 'SUMMARY.md' file's records."
    File.open(summary_path, 'a+') do |record|
      record.puts "\n\n"

      # we don't need to index these files
      # remove them from the array
      sorted.each do |path|
        if path.first == project
          path.shift
          exception = ['SUMMARY.md', 'book.json', nil]
          next if exception.include? path.first
        end

        index = "#{pos * path.index(path.last)}* "  # just calculates how many spaces needed for the current file in summary file
        title = path.last.split('.').first.capitalize
        uri   = path.join('/')
        print "\r#{index}[#{title}](#{uri})".cls_upline

        record.puts "#{index}[#{title}](#{uri})" #index + "[#{title}]" + "(#{uri})"
        sleep 0.1
      end
      print ''.mv_down.cls_upline

    end
  end

  # TODO
  # fix book.json
  #
  def self.general_fixes(project)
    File.write("#{project}/book.json", '{ }')
    readme = <<~README
    # #{project}
    ## Customer Requests and Concerns
    1.
    2.
    3.
    
    | Timeline | Date |
    | :--- | :--- |
    | Project Testing Start | |
    | Project Testing End | 19-October-2017 |
    
    ## Applications progress
    
    | Host/IP | number of issues | Progress % | Issues | Notes | misc. |
    | :--- | :--- | :--- | :--- | :--- | :--- |
    |  |  |  |  |   |  |
    #{@list.map {|host| "|#{host}  |  |  |  |  |  |" }.join("\n")}
    
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
    File.write("#{project}/README.md", readme)
  end
end

# TODO
class Git
  def self.need_help?
    help = nil
    until help =~ /[y|n]/i
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
option_parser.on('-l', '--list TARGET_LIST' , 'Text file contains list of targets') {|v| options[:list] = v}
option_parser.on('-h', '--help', 'Show this help message') {puts banner , option_parser; exit!}
option_parser.on_tail "\nUsage:\n".underline + "  ruby #{__FILE__} --project <project_name> --list <targetlist.txt>"
option_parser.on_tail "\nExample:\n".underline + "  ruby #{__FILE__} --project PT_CustomerName_WebApp_01-01-2030 --list target_list.txt\n\n"

begin
  option_parser.parse!
  case
  when options[:project] && options[:list]
    GitbookBuilder.build(options[:project], options[:list])
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
