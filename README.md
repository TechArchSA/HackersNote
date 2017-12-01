# Gitbook Builder
It's a Ruby script creates a gitbook compatible structure for penetration test and red team projects 
The main target of this script is to make building [gitbook](https://www.gitbook.com/editor) project for a new PT/RT engagement easily.

## Usage

```
ruby gitbook_builder.rb -h

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
                     The Cyber Daemons - TechArch
    
Gitbook Builder - Helps pentesters to build gitbook structure for PT engagements.

Help menu:
   -p, --project PROJECT_NAME       Project Name
   -l, --list TARGET_LIST           The target name or a text file contains list of targets
   -h, --help                       Show this help message

Usage:
  ruby ./gitbook_builder.rb --project <project_name> --list <targetlist.txt>

Example:
  ruby ./gitbook_builder.rb --project PT_CustomerName_WebApp_01-01-2030 --list target_list.txt
  ruby ./gitbook_builder.rb -p PT_CustomerName_WebApp_01-01-2030 -l example.com

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

## Contribution 
Yes!, PR 
## reporting issues
[Report Issues here](https://github.com/TechArchSA/gitbook-builder/issues)


