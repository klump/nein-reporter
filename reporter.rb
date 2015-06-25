#! /usr/bin/ruby

require_relative './lib/asset.rb'
require_relative './lib/report.rb'
require_relative './lib/inventory.rb'
require_relative './lib/collector.rb'

# Connect to the Inventory API
Inventory.configure

# Create an asset with the type specified
asset = Asset.new ARGV[0].to_sym 
report = Report.new asset

# Tell the inventory we are working on a report
report.create

begin
  # Gather the data
  asset.gather_information
  report.add asset.report
  report.status = :success
rescue Asset::NoNameError
  # If no identifier for the asset can be found the report is useless
  report.add( { reporter: { error: 'No identifier/ name found for asset.' } } )
  report.status = :failure
ensure
  # Submit the final report to the database
  report.update
end
