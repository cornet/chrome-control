#!/usr/bin/env ruby

require 'sinatra'
require 'chrome_remote_debug'
require 'json'

locations = [
  {:ip => '127.0.0.1', :port => 9222},
  {:ip => '127.0.0.1', :port => 9333}
]

get '/' do
  @browsers = []
  locations.each do |location|
    chrome = ChromeRemoteDebug::Client.new(location[:ip], location[:port])
    page = chrome.pages.first
    @browsers << page
  end

 erb :index
end

get '/url' do
  location = locations[params[:id].to_i]
  chrome = ChromeRemoteDebug::Client.new(location[:ip], location[:port])
  page = chrome.pages.first  

  page = chrome.pages.first
  if params[:navigate] 
    page.navigate(params[:url])
  else
    page.reload
  end
end

get '/screenshot' do
  location = locations[params[:id].to_i]
  chrome = ChromeRemoteDebug::Client.new(location[:ip], location[:port])
  page = chrome.pages.first  

  screenshot = page.screenshot(:maxWidth => 100, :maxHeight => 100)
  screenshot[:result][:data]
end

get '/details' do
  location = locations[params[:id].to_i]
  chrome = ChromeRemoteDebug::Client.new(location[:ip], location[:port])
  page = chrome.pages.first  

  details = page.screenshot(:maxWidth => 100, :maxHeight => 100)
  JSON.generate({ :title => details[:title], :url => details[:url] })
end




