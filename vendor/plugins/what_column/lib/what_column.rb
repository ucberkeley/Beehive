module WhatColumn
  class Columnizer

    HEADER = "# === List of columns ==="
    FOOTER = "# ======================="
    INCREMENT = "  "

    def add_column_details_to_models
      remove_column_details_from_models
      Dir[File.join(Rails.root.to_s, 'app', 'models', '**', '*')].each do |dir|
        next if File.directory?(dir)
        add_column_details_to_file(dir)
      end
    end

    def remove_column_details_from_models
      Dir[File.join(Rails.root.to_s, 'app', 'models', '**', '*')].each do |dir|
        next if File.directory?(dir)
        remove_column_details_from_file(dir)
      end
    end

    private
    def add_column_details_to_file(filepath)
      File.open(filepath, "r+") do |file|
        if file.read.match(/class (.*)\</)
          ar_class = $1.strip.constantize

          if class_can_be_columnized?(ar_class)

            max_width = ar_class.columns.map {|c| c.name.length + 1}.max
            # the format string is used to line up the column types correctly
            format_string = "#{INCREMENT}#   %-#{max_width}s: %s \n"

            file.rewind
            read_lines = file.readlines
            output_lines = []
            # find the lines that start with the appropriate class
            read_lines.each do |line|
              output_lines << line
              if line.match(/class (.*)\</)
                class_constant = $1.strip.constantize rescue nil
                if class_constant == ar_class
                  output_lines << "\n" + INCREMENT + HEADER + "\n"
                  ar_class.columns.each do |column|
                    values = [column.name, column.type.to_s]
                    output_lines << format_string % values
                  end
                  output_lines << INCREMENT + FOOTER + "\n\n"
                end
              end
            end

            file.pos = 0
            output_lines.each { |line| file.print line }
            file.truncate(file.pos)

          end
        end
      end
    end

    def remove_column_details_from_file(filepath)
      File.open(filepath, 'r+') do |file|
        lines = file.readlines
        removing_what_columns = false
        out = []
        lines.each_with_index do |line, index|
          if line_has_header?(line)
            removing_what_columns = true
            # And remove previous empty line
            out.pop if out.last == "\n"
          end


          previous_line = index > 0 ? lines[index - 1] : ""
          if should_keep_line?(removing_what_columns, line, previous_line)
            out << line
          end

          if line_has_footer?(line)
            removing_what_columns = false
          end

        end
        file.pos = 0
        file.puts out
        file.truncate(file.pos)
      end
    end

    def should_keep_line?(removing_what_columns, line, previous_line)
      !((removing_what_columns and line.match(/^\s*#/)) or (line_has_footer?(previous_line) and line == "\n"))
    end

    def line_has_header?(line)
      line.match(/^\s*#{HEADER}\s*$/)
    end

    def line_has_footer?(line)
      line.match(/^\s*#{FOOTER}\s*$/)
    end

    def class_can_be_columnized?(class_to_check)
      class_to_check.respond_to?(:table_exists?) and class_to_check.table_exists? and class_to_check.respond_to?(:columns)
    end

  end
end
