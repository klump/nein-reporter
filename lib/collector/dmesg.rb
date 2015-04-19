class Collector::Dmesg < Collector
  NAME = 'dmesg'
  
  # Register as a subclass of Collector
  Collector.register(self)

  def initialize
    super
  end

  def run
    command = 'dmesg'

    super(command)
  end

  def report
    super
  end
end
