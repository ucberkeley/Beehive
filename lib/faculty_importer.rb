class FacultyImporter

  class ImportError < StandardError
    class ParseError < StandardError
    end
  end

  attr_accessor :url, :debug
  attr_reader   :faculties

  def initialize(options={}, *args)
    @url       = options[:url] ||
                 'http://www.eecs.berkeley.edu/Faculty/Lists/list.shtml'
    @faculties = []
    @has_run   = false
    @debug     = (Rails.env == 'development')
  end

  def run
    return true if @has_run

    check_options!

    begin
      import
    rescue => e
      @has_run = false
      raise
    end

    @has_run = true
  end

  def save!
    run || raise(ImportError)

    raise(ImportError.new("No EECS dept")) unless eecs = Department.eecs

    Faculty.transaction do
      @faculties.each do |h|
        f = Faculty.new
        f.name = h[:name]
        f.email = h[:email]
        f.department = eecs
        f.save || raise(ImportError.new(f.errors.inspect))
      end
    end

    true
  end

private

  def check_options!
    raise ArgumentError unless @url
  end

  def debug(msg, d_indent=0)
    return unless @debug
    @indent_level ||= 0
    puts "#{'  '*@indent_level}#{msg}" if msg
    @indent_level = [0, @indent_level+d_indent].max
  end

  def import
    require 'nokogiri'
    require 'open-uri'

    doc = Nokogiri::HTML(open(@url)) || raise(ImportError("Failed to open #{@url}"))

    # As of 2011-10-16
    # The faculty page is structured in a table.
    # Each entry consists of three <tr>s:
    #   <tr> : divider (garbage)
    #   <tr> : name
    #       <td> spacer (garbage)
    #       <td>
    #           <a> homepage
    #               <text> name
    #           <text> title
    #   <tr> : other info
    #       <td> spacer (garbage)
    #       <td> portrait
    #       <td>
    #           <text> office, phone; email
    #           <strong> "Research Interests"
    #           <a> link to research area landing page
    #            :  <text> interest name
    #            :
    #            :
    #           <strong> "Teaching Schedule"

    state = :start   # Expected look-ahead
    # Valid states are :divider, :name, :info

    faculty = {}   # current faculty
    error = false  # if true, quit parsing current prof

    doc.xpath('//div[@id="content"]//tr').each do |tr|
      1.times do  # to get 'redo' behavior
        debug "-- entering state #{state}"
        case state
        when :start
          faculty = {}
          error = false

          debug "New prof", 1

          state = :divider
          redo

        when :divider
          # Discard this element
          state = :name
          break if error

        when :name
          state = :info
          break if error

          td = tr.at_xpath('td[2]')
          raise(ImportError::ParseError.new('Could not find name')) unless td

          fullname = td.at_xpath('.//a/text()').text
          raise(ImportError::ParseError.new('Could not find name')) unless fullname

          faculty[:name] = fullname

        when :info
          state = :done
          redo if error

          td = tr.at_xpath('td[3]')
          raise(ImportError::ParseError.new('Could not find info')) unless td

          # Office, phone, email
          begin
            info = td.at_xpath('text()').text.strip
            faculty[:office], faculty[:phone], faculty[:email] =
              info.scan( /(?:([^,]+), )?(?:([^;]+); )?(.*)/ ).first
            debug faculty.inspect
            raise(ImportError::ParseError.new('Could not find email')) unless faculty[:email]
          end

          redo

        when :done
          debug nil, -1
          state = :start

          if error
            $stderr.puts "Record not saved due to errors: #{faculty}"
            break
          end

          debug "Saving #{faculty.inspect}"

          @faculties << faculty

        else
          raise ImportError::ParseError
        end
      end
    end
  end

end
