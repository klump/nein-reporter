class Collector::Dmesg < Collector
  NAME = 'dmesg'
  
  # This collector is for the computer asset type
  Asset.add_collector(:computer, self)

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
