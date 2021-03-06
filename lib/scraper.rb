require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  attr_accessor :student

  #links = doc.search('a').map { |a| [['href'],a.content]}

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = []
    doc.css("div.student-card").each do |student|
      students << {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.children[1].attributes["href"].value
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student = {}
    social_media = doc.css(".social-icon-container").css("a").collect{|e|e.attributes["href"].value}
    social_media.detect do |element|
      student[:twitter] = element if element.include?("twitter")
      student[:linkedin] = element if element.include?("linkedin")
      student[:github] = element if element.include?("github")
    end
    student[:blog] = social_media[3] if social_media[3] != nil
    student[:profile_quote] = doc.css(".profile-quote")[0].text
    student[:bio] = doc.css(".description-holder").css('p')[0].text
    student
  end
end

