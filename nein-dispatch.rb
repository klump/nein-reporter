#! /usr/bin/ruby

# Determine the asset type from the kernel command line (specified at boot)
# Settings in the kernel commandline look likethe: neidb.SETTING_NAME=VALUE
settings = {}
`cat /proc/cmdline`.split(/\s+/).each do |argument|
  if argument =~ /^neindb\.(\w+)=(\w+)$/
    settings[$1] = $2
  end
end

# Determine which reporter to run
reporter_script = File.expand_path(File.dirname(__FILE__))
if settings[interactive] =~ /(yes|true)/i
  reporter_script += '/reporter-interactive.rb'
else
  reporter_script += '/reporter.rb'
end

# Run the reporter
system("#{reporter_script} #{settings[asset_type]}")

unless settings[poweroff] =~ /(no|false)/i
  system("poweroff")
end
