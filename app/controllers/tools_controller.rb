class ToolsController < ApplicationController
  require 'searchbing'
  require 'timeout'
  require 'open_uri_redirections'

  def emails
    # warn user if bing api key is not configured
    if GlobalSettings.first.bing_api.to_s.empty?
      flash.now[:warning] = "Bing API Key Required for Email Enumeration"
    end

    @email_searches = EmailSearch.includes(:harvested_emails).page(params[:page]).per(25).reverse_order
  end

  def show_emails
    @emails_found = EmailSearch.find(params[:id]).harvested_emails.page(params[:page]).per(100)
  end

  def destroy_email
    EmailSearch.destroy(params[:id])
    redirect_to tools_emails_path, notice: 'Email Search Destroyed'
  end

  def download_emails
    emails = String.new
    email_search = EmailSearch.find(params[:id])
    email_search.harvested_emails.each {|email| emails << "#{email.email}\n" }
    send_data(emails, :filename => "#{email_search.domain}-#{params[:id]}.txt".parameterize)
  end

  def import_emails
    campaign = Campaign.find(params[:campaign])
    email_search = EmailSearch.find(params[:search_id])
    emails = email_search.first.harvested_emails.map {|email| email.email}
    emails.each do |email| 
      newvictim = Victim.new(email_address: email)
      campaign.victims << newvictim
    end
    redirect_to victims_campaigns_path(id: campaign.id), notice: 'Emails Imported'
  end

  def enumerate_emails
    # ensure bing api key is entered
    bing_api = GlobalSettings.first.bing_api
    if bing_api.to_s.empty?
      redirect_to tools_emails_path, notice: "Unable to perform Operation without Bing API Key"
      return
    end

    # ensure domain to search has been entered
    if params[:domain].empty?
      redirect_to tools_emails_path, notice: 'Must enter a Domain'
      return
    end

    # create offset counter and urls array
    offset = 0
    urls = []
    number = (params[:crawls].to_i/50)

    # bing search to list first 50 urls and place in array
    bing_web = Bing.new(bing_api, 50, "Web")
    number.times.each do |search|
      begin
        bing_results = bing_web.search("\@#{params[:domain]}", offset)
      rescue => e
        redirect_to tools_emails_path, notice: 'Invalid Bing API Key'
        return
      end
      bing_results[0][:Web].each {|result| urls << result[:Url]}
      offset += 50
    end

    # only unique urls
    urls.uniq!

    # iterate through links and store unique emails to database
    found_emails = []
    contents = ""

    # create new search record
    email_search = EmailSearch.create(domain: params[:domain], crawls: params[:crawls].to_i)

    urls.each do |url|
      begin
        Timeout::timeout(10) {
          contents = open(url, :allow_redirections => :all).read.force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
        }
      rescue
        next
      end
      emails = contents.scan(/(\w{1,20}\b(@|\[at\]|<at>|\(at\))\b#{params[:domain].gsub('.', '\.')})/)
      next if emails.empty?
      emails.each {|email| email_search.harvested_emails << HarvestedEmail.new(email: email, url: url)}
    end

    redirect_to tools_emails_path, notice: 'Email Enumeration Completed'
  end
end
