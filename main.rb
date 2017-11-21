
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
require 'optparse'
require 'fileutils' # for nested directories




projectname, targetlist  = ARGV

if File.file? targetlist
  # list = File.readlines(targetlist).map(&:chomp)
  @list = File.read(targetlist).split("\n")
end

# projectname
# Dir.mkdir projectname

# main files


# def create(name, content)
#   File.write name, "##{content.split('.').first}")
# end

prj_name = 'project1'

%w[book.json SUMMARY.MD README.MD].each do |file|
  # Dir.rm_f(file) if File.exist?(file)
  File.write ( File.join(prj_name, file), "##{file.split('.').first}")
end


prj_files = %W[critical.md hight.md medium.md low.md informational.md scanning_and_enumeration.md notes.md]
@list.each do |folder|
  FileUtils.mkdir_p(File.join(prj_name, 'findings', folder))
  prj_files << "#{folder}.md"
  prj_files.each do |file|
    File.write File.join(prj_name, 'findings', folder, file), "##{file.split('.').first}"
  end
end
