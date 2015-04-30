class Collector::Dmesg < Collector
  NAME = 'dmesg'
  
  # This collector is for the computer asset type
  Asset.add_collector(:computer, 10, self)

  def initialize options
    super
  end

  def run
    command = 'dmesg'

    super(command)
  end

  def to_hash
    super
  end
end
