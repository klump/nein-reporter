#! /usr/bin/ruby

require_relative './lib/report.rb'
require_relative './lib/inventory.rb'
require_relative './lib/collector.rb'

# Connect to the Inventory API
Inventory.connect

# Create a new report
report = Report.new

puts report.create
report.collect
puts report.update
