require 'open3'

#
# The main collector. All other collector are subclasses.
# Use super in the subclasses to call these functions.
# In the subclasses you can do all the funky stuff you want.
#
# In the subclasses you should register the collector with the
# correct asset type, e.g.
#   Asset.add_collector(:computer, 10, self)
# You should also set a name which will be used to identify the
# connector in the data hash of the report.
# These should somehow match the names of the collector and in
# ideal cases even the names of the workers used by NEIN DB.
#
# See Collector::Dmesg or Collector::Cpuinfo for examples.
#
class Collector
  #
  # Initialize the instance variables needed for one collector 
  #
  def initialize
    @output = nil
    @error = nil
    @exitcode = nil
    @starttime = nil
    @endtime = nil
  end

  #
  # Run the given command and record the output to stdout and
  # stderr as well as the exit code.
  # The start and end times will be set as well
  #
  def run(command)
   @starttime = Time.now

   Open3.popen3(command) do |stdin, stdout, stderr, wait_thread|
     @output = stdout.read.chomp
     @error = stderr.read.chomp
     @exitcode = wait_thread.value.exitstatus
   end

   @endtime = Time.now
  end

  #
  # Pack up all instance variables as a hash
  #
  def to_hash
    {
      output: @output,
      error: @error,
      exitcode: @exitcode,
      starttime: @starttime,
      endtime: @endtime
    }
  end
end

#
# After defining the Collector class load its subclasses
#
Dir[File.dirname(__FILE__) + '/collector/*.rb'].each do |file|
  require file
end
