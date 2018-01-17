# Hacker's Note

It's a Ruby script creates a gitbook compatible structure for penetration test and red team projects 
The main target of this script is to make building [gitbook](https://www.gitbook.com/editor) project for a new PT/RT engagement easily.

## Installation

    $ gem install hackernote

## Usage

```
$> hackernote -h

                                 ______            ____                                                 ______              ____
     |         |      .'.      .~      ~.|    ..''|          |`````````,         ..'''' |..          |.~      ~.`````|`````|
     |_________|    .''```.   |          |..''    |______    |'''|'''''       .''       |  ``..      |          |    |     |______
     |         |  .'       `. |          |``..    |          |    `.       ..'          |      ``..  |          |    |     |
     |         |.'           `.`.______.'|    ``..|__________|      `....''             |          ``|`.______.'     |     |___________
                                                                                                                                 v1.0.0
      
Hacker's Note - Helps security professionals to organize their notes in a gitbook structure for PT/RT engagements.

Help menu:
   -p, --project PROJECT_NAME       Project Name
   -l, --list TARGET_LIST           The target name or a text file contains list of targets
   -g, --git GIT_REPO_URL           Configure git server URL
   -h, --help                       Show this help message

Usage:
  hackernote --project <project_name> --list <targets[.list]> --git <git server repository URL>

Example:
  hackernote --project PT_CustomerName_WebApp_01-01-2030 --list target_list.txt
  hackernote -p PT_CustomerName_WebApp_01-01-2030 -l example.com
  hackernote -p PT_CustomerName_WebApp_01-01-2030 -l example.com -g https://github.com/[USERNAME]/PT_CustomerName_WebApp_01-01-2030.git
```


## Document Structure
The script create a tree of folders and files for each target 

- Project Name
  - Target1/
    - target1.md
    - scanning_and_enumeration.md
    - critical 
    - high.md
    - medium.md
    - low
    - informational.md
    - notes
  - TargetX/ 
    - target1.md
    - scanning_and_enumeration.md
    - critical 
    - high.md
    - medium.md
    - low
    - informational.md
    - notes
  - README.md
  - book.json

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hackernote.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
