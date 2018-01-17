# Standard libraries
require 'optparse'
require 'fileutils'
require 'pathname'
require 'find'
require 'mkmf'
require 'readline'

# HackerNote
require "hackernote/version"
require "hackernote/extensions"
require "hackernote/utils"
require "hackernote/gitbook_builder"
require "hackernote/git"


module HackerNote
  String.class_eval do
    include Extensions::String
  end
end
