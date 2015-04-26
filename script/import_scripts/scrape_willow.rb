#!/usr/bin/env ruby
#
# This script scrapes research listings from the Willow site.
# Deprecated
#
@options = {:listings_page => "jobs.html", :verbose => true}

# Helpers
class String
  def unescape
    CGI.unescapeHTML(URI.unescape(self))
  end
  def like(s) # is one string a substring of the other?
    (self =~ /#{s}/i) || (s =~ /#{self}/i)
  end
end


# Scraper
class WillowScraper
  def initialize
    @doc
  end

  def set_sponsor
     sponsor = Faculty.find_by_name(@current_fields[:primary_contact][:name]) || Faculty.create(@current_fields[:primary_contact].merge({:department=>"EECS"}))
     @current_job.sponsorships << Sponsorship.create(:faculty_id => sponsor.id)
  end

  def end_current_job
    return unless @current_job

    # params
    @current_job.desc = @current_job.desc.join("\n\n")
    @current_job.department = Department.find_or_create_by_name("EECS")
    @current_job.active = true
    @current_job.categories << @current_category

    # check and save
    unless @current_job.valid?
      puts "*** error validating job #{@current_job.inspect}"
    else
     set_sponsor
     @current_job.save ? puts("Parsed job: #{@current_job.inspect}\n#{@current_job.desc}\n") : puts("*** error saving job #{@current_job.inspect}")
    end
    
    puts '-'*80

    # reset for next job
    @current_job = nil
    @current_fields = {:primary_contact=>{}, :alternate_contact=>{}}
  end

  # extract info from footer of job listing
  def parse_strong(p)
    # structure is like: [ field, ... ]
    kids = p.children.to_ary
    field = kids.shift.inner_text().to_s.unescape
    puts "  field: #{field}"
    case field.downcase
    when 'primary contact'
      # structure is like:
      # [ ": Contact Name -", "<a>email@address</a>" ]
      contact = kids.shift.inner_text().to_s.unescape.scan(/(\w[\w\s\.]+)\s+-/).to_s.titleize
      email = kids.shift.inner_text().to_s.unescape
      puts "  Primary Contact: '#{contact}' [email: #{email}]"
      @current_fields[:primary_contact] = {:name=>contact, :email=>email}
    when 'alternate contact'
      # structure is like:
      # [ ": Contact Name (title) -", "<a>email@address</a>" ]
      #                                                            [  name   ]   [  title        ]
      contact, title = kids.shift.inner_text().to_s.unescape.scan(/(\w[\w\s\.]+)\s+(?:\(([^\)]+)\))?/).first
      title ||= ''
      contact = contact.to_s.titleize
      email = kids.shift.inner_text().to_s.unescape
      @current_fields[:alternate_contact] = {:name=>contact, :email=>email}
      @current_fields[:alternate_contact][:type] = case
      when title =~ /grad/i
        puts "  Grad contact: #{contact} [email: #{email}]"
        :grad
      when title =~ /faculty/i
        puts "  Faculty contact: '#{contact}' [email: #{email}]"
        if contact.like(@current_fields[:primary_contact][:name]) && email.like(@current_fields[:primary_contact][:email])
          # everything went better than expected 8)
        else
          # wat? two faculties?
          puts "*** Conflict: #{@current_fields[:primary_contact].inspect}\n              #{@current_fields[:alternate_contact].inspect}"
        end
        :faculty
      else
        puts "*** Unknown alternate contact type #{title}: #{contact} [#{email}]"
        nil
      end
    when 'submit student application'
      # discard this
    else
      # unknown field, just add it onto the description so we don't lose information
      @current_job.desc << p.children.to_ary.flatten.collect(&:inner_text).join(' ')
    end
  end

  def scrape!(page)
    open(page) do |f|
      @doc = Nokogiri::HTML(open(page))

      content = @doc.xpath('//div[@id="content"]')
      elms = content.xpath('h3 | h4 | p')

      @current_category = nil
      @current_job = nil
      @current_fields = {}
      @current_instructor = nil

      elms.each do |elm|
        text = elm.xpath('text()').to_s.unescape
        case elm.name
	when 'h3' # category
          end_current_job
	  @current_category = Category.find_or_create_by_name(text)
          puts "Category: #{text}"
	when 'h4' # job title, indicates new job
          end_current_job
	  @current_job = Job.find_or_initialize_by_title(text)
          @current_job.desc = [] # temporarily build info as array of paragraphs
          puts "Job.title: #{text}"
	when 'p' # job content
          next unless @current_job
          if elm.children.first && elm.children.first.name.downcase.eql?('strong')  # info (like contact info)
            parse_strong elm
          else  # just a content para
            @current_job.desc << text
          end
	else
	  puts "idk what to do with #{elm.name}"
	end # case elm.name
      end # elms.each

    end # open(page)
  end
end


# main
puts "Warming up..."
require 'rubygems'
require 'nokogiri'
require 'pp'
require File.join(File.dirname(__FILE__), '..', '..', 'config', 'environment')

puts '*'*80
w = WillowScraper.new
w.scrape!(@options[:listings_page])
# end main

