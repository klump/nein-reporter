#! /usr/bin/ruby

require_relative './lib/asset.rb'
require_relative './lib/report.rb'
require_relative './lib/inventory.rb'
require_relative './lib/collector.rb'

# Connect to the Inventory API
Inventory.connect

asset = Asset.new :computer
asset.inventory
