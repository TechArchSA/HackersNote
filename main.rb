"""

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
        -- critical.md
        -- High.md
        -- etc
      - host 2/
        -- critical.md
        -- scanning and enumeration.md
    SUMMARY.MD
    README.MD
"""

require 'optparse'
require 'fileutils' # for nested directories

PRJ_NAME = "Project1-Q1"
TGT_LST = ["google.com","bing-microsoft.com","yahoo.com","reddit.com"]
FLDRS = ["findings", "assets"]
FILES = ["scanning-and-eumerations.md", "Critical.md", "High.md", "Medium.md", "Low.md"]

options = {}

# parse options and store project name, and target lists
OptionParser.new do |opts|
  opts.banner = "Usage: ruby gitbook_builder.rb (--project | -p <project_name>) (--targets | -t <targetlist.txt>)"

  opts.on("-p", "--project", "Projects name") do |v|
    p v
  end
  opts.on("-t", "--targets", "Text File containint targets list") do |v|
    #p v
  end
end.parse




# create top level folders - assets, findings
FLDRS.each() do |folder|
  FileUtils::mkdir_p folder
end

# create target list and nested folders
Dir.chdir('findings')
TGT_LST.each() do |target|
  FileUtils::mkdir_p target
  Dir.chdir(target)
    # create md file inside each
    FILES.each() do |file|

      File.open(file, "w") do | text|
        text.puts "## #{file}"

      end
    end
  Dir.chdir('..')
end

# create README.md
File.open("README.md", "w") do |text|
  text.puts "## #{PRJ_NAME}"
  text.puts "## Customer Requests and Concers
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


### Point Of Contact
| Name | email | Mobile number | Job title/Role |
| :--- | :--- | :--- | :--- |
| Firstname Lastname | email2@email.com | 0550000000 |  |

### Source IP Addresses log
This list has to be regulary update!

| Engineer 1 | Engineer 2 |
| :--- | :--- |
| x.x.x.x | y.y.y.y |
|  |  |
| |  |

## Scope


**Approache:**

**IP ranges**

**Domains**

**Credetials**

## Leftovers to clean
| Host | URL/Files | discription |
| :--- | :--- | :--- |
|  |  |
"
end