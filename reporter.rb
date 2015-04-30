#! /usr/bin/ruby

require_relative './lib/asset.rb'
require_relative './lib/report.rb'
require_relative './lib/inventory.rb'
require_relative './lib/collector.rb'

# Connect to the Inventory API
Inventory.configure

asset = Asset.new :computer
report = Report.new asset

# tell the inventory we are working on a report
report.create

begin
  # gather the data
  asset.gather_information
  report.add asset.report
  report.status = :sucess
rescue Asset::NoNameError
  # if no identifier for the asset can be found the report is useless
  report.add { reporter: { error: 'No identifier/ name found for asset.' } }
  report.status = :failed
ensure
  # submit the final report to the database
  report.update
end
