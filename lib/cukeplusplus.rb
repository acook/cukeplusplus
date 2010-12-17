require 'fileutils'
require 'cucumber/formatter/console'
require 'cucumber/formatter/io'
require 'gherkin/formatter/escaping'
require 'cucumber/formatter/pretty'

module Cukeplusplus 
  class Base < Cucumber::Formatter::Pretty
    include FileUtils
    include Cucumber::Formatter::Console
    include Cucumber::Formatter::Io
    include Gherkin::Formatter::Escaping
    attr_writer :indent
    attr_reader :step_mother
    attr_accessor :tags, :exception, :source_line

    def initialize(step_mother, path_or_io, options)
      @step_mother, @io, @options = step_mother, ensure_io(path_or_io, "ugly"), options
      @exceptions = []
      @indent = 0
      @prefixes = options[:prefixes] || {}
      @delayed_announcements = []
    end

    def before_feature(*args)
    end

    def tag_name(tag_name)
      @tags << format_string(tag_name, :comment) #.indent(@indent)
      #@io.printf(tag)
      #@io.flush
      @indent = 1
    end

    def after_tags(tags)
      if @indent == 1
        #@io.puts
        #@io.flush
      end
    end

    def feature_name(keyword, name)
      @io.puts
      @io.puts format_string("#{keyword}: #{name}", :outline)
      @io.flush
    end

    def before_feature_element(feature_element)
      @indent = 2
      @scenario_indent = 2
      @tags = Array.new
    end

    def scenario_name(keyword, name, file_colon_line, source_indent)
      print_feature_element_name(keyword, name, file_colon_line, source_indent, @tags)

      @scenario_steps = String.new
    end

    def before_step(step)
      @current_step = step
      @indent = 6
    end

    def before_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background)
      @hide_this_step = false
      if exception
        if @exceptions.include?(exception)
          @hide_this_step = true
          return
        end
        @exceptions << exception
      end
      if status != :failed && @in_background ^ background
        @hide_this_step = true
        return
      end
      @status = status
    end

    def step_name(keyword, step_match, status, source_indent, background)
      return if @hide_this_step
      source_indent = nil unless @options[:source]
      name_to_report = format_step(keyword, step_match, status == :passed ? :pending : status, false)

      #@io.puts
      @scenario_steps << name_to_report.indent(@scenario_indent + 2) + "\n"
      @source_line = format_string((' # ' + step_match.file_colon_line).indent(source_indent), :comment) 
      print_announcements
    end

    def after_step_result(keyword, step_match, multiline_arg, status, exception, source_indent, background)        
      if status == :failed
        @io.puts
        @io.puts @scenario_steps
      end
    end

    def exception(exception, status)
      @exception = format_string(exception, :comment)
    end

    def after_feature_element(feature_element)
      @io.printf "\r  "
      if @status == :passed
        @io.printf "[#{format_string('PASSED', :passed)}]"
      else
        @io.printf "[#{format_string('FAILED', :failed)}]"
      end
      @io.puts @exception ? "  #{@exception} #{format_string(@source_line, :tag)}" : " "
      @exception = nil
      @source_line = nil
    end

    def after_features(features)
      print_summary(features) unless @options[:autoformat]
    end

    private

    def method_missing(m, *args)
      puts m.to_s
    end

    def print_feature_element_name(keyword, name, file_colon_line, source_indent, tags)
      @io.puts if @scenario_indent == 6
      names = name.empty? ? [name] : name.split("\n")
      line = "#{keyword}:#{tags.blank? ? '' : ' ' + tags.join(' ')} #{names[0]}".indent(@scenario_indent)
      @io.print(line)
      #        if @options[:source]
      #          line_comment = " # #{file_colon_line}".indent(source_indent)
      #          @io.print(format_string(line_comment, :comment))
      #        end
      names[1..-1].each {|s| @io.puts "    #{s}"}
      @io.flush        
    end

    def print_summary(features)
      puts
      print_stats(features, @options.custom_profiles)
      print_snippets(@options)
      print_passing_wip(@options)
    end
  end
end
