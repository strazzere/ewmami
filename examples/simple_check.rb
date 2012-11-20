#! /usr/bin/env ruby
require 'rubygems'
require 'ewmami'

options = {
  :proxy =>
  {
    :proxy_address => "184.73.170.152",
    :proxy_port => "8888"},
  :androidId => 1,
  :locale => "en_US"
}
api = Ewmami::API.new(options)

file = "phonebeagle_client-201-release.apk"
puts "Attempting to verify " + file
resp = api.verify_file("phonebeagle_client-201-release.apk")
puts "Verdict: " + resp.verdict.to_s
