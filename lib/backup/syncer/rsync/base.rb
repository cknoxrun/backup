# encoding: utf-8

module Backup
  module Syncer
    module RSync
      class Base < Syncer::Base

        ##
        # Path to store the synced files/directories to
        attr_accessor :path

        ##
        # Directories to sync
        attr_writer :directories

        ##
        # Flag for mirroring the files/directories
        attr_accessor :mirror

        ##
        # Additional options for the rsync cli
        attr_accessor :additional_options

        ##
        # Instantiates a new RSync Syncer object
        # and sets the default configuration
        def initialize
          load_defaults!

          @path               ||= 'backups'
          @directories          = Array.new
          @mirror             ||= false
          @additional_options ||= Array.new
        end

        ##
        # Syntactical suger for the DSL for adding directories
        def directories(&block)
          return @directories unless block_given?
          instance_eval(&block)
        end

        ##
        # Adds a path to the @directories array
        def add(path)
          @directories << path
        end

        private

        ##
        # Returns the @directories as a space-delimited string of
        # single-quoted values for use in the `rsync` command line.
        # Each path is expanded, since these refer to local paths
        # for both RSync::Local and RSync::Push.
        # RSync::Pull does not use this method.
        def directories_option
          @directories.map do |directory|
            "'#{ File.expand_path(directory) }'"
          end.join(' ')
        end

        ##
        # Returns Rsync syntax for enabling mirroring
        def mirror_option
          '--delete' if @mirror
        end

        ##
        # Returns Rsync syntax for invoking "archive" mode
        def archive_option
          '--archive'
        end

      end
    end
  end
end
