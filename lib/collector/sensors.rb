class Collector::Sensors < Collector
  NAME = 'sensors'
  
  # This collector is for the computer asset type
  Asset.add_collector(:computer, 10, self)

  def initialize options
    super
  end

  def run
    command = 'sudo sensors -Au'

    super(command)
  end

  def to_hash
    super
  end
end
