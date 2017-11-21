
=begin
1- take cli arguments, store them in variables
2- create folders, and files
3- edit summary.md
4- clean up

ruby gitbook_builder.rb --project [project_name] --targetlist targetlist.txt


projectname/
    - assets/
      -- files/
    - findings/
      - host 1/
        - host1
        - scanning_and_enumeration.md
        - critical.md
        - high.md
        - medium.md
        - low.md
        - informational.md
        - notes
      - host 2/
        - README.md
        - scanning_and_enumeration.md
        - critical.md
        - high.md
        - medium.md
        - low.md
        - informational.md
        - notes
    book.json
    SUMMARY.MD
    README.MD
=end
require 'fileutils'
require 'optparse'

options = {}
option_parser = OptionParser.new
option_parser.on("-p", "--project=MANDATORY <PROJECT_NAME>", "Project Name") {|v| options[:project] = v}
option_parser.on("-l", "--list=MANDATORY <TARGET LIST>" , "Text file containing list of targets") {|v| options[:list] = v}
option_parser.banner = "Usage: #{__FILE__} --project <project_name> --list <targetlist.txt>"

begin
  option_parser.parse!
  case
    when options[:project] && options[:list]
      FileUtils.rm_rf(options[:project]) if Dir.exist?(options[:project])
      Dir.mkdir options[:project]

      if File.file? options[:list]
        @list = File.read(options[:list]).split("\n")
      end

      %w[book.json SUMMARY.MD README.MD].each do |file|
        File.write( File.join(options[:project], file), "##{file.split('.').first.capitalize}")
      end

      prj_files = %W[critical.md hight.md medium.md low.md informational.md scanning_and_enumeration.md notes.md]
      @list.each do |folder|
        FileUtils.mkdir_p(File.join(options[:project], 'findings', folder))
        prj_files << "#{folder}.md"
        prj_files.each do |file|
          File.write File.join(options[:project], 'findings', folder, file), "##{file.split('.').first.capitalize}"
        end
      end
    # else
    #   puts option_parser
    #   exit
  end
rescue OptionParser::MissingArgument => e
  e.args.each {|arg| puts "[!] #{e.reason.capitalize} for '#{arg}' option"}
rescue Exception => e
  puts e
  puts option_parser
  exit
end