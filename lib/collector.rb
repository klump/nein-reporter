require 'open3'

class Collector
  def initialize
    @report = {}
  end

  def run(command)
   @report[:starttime] = Time.now

   Open3.popen3(command) do |stdin, stdout, stderr, wait_thread|
     @report[:output] = stdout.read.chomp
     @report[:error] = stderr.read.chomp
     @report[:exitcode] = wait_thread.value.exitstatus
   end

   @report[:endtime] = Time.now
  end

  def report
    @report
  end
end

# After defining the Collector class load its subclasses
Dir[File.dirname(__FILE__) + '/collector/*.rb'].each do |file|
  require file
end
