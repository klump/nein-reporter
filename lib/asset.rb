class Asset
  # Valid asset types
  TYPES = [ :computer, :cage ]

  @@collectors = {}

  def Asset.add_collector type, collector
    @@collectors[type] = [] if @@collectors[type].nil?
    @@collectors[type] << collector
  end

  def initialize type
    @type = type
    @id = determine_id
  end

  #
  # Run the collectors associated with the asset 
  #
  def inventory
    @report = Report.new determine_id
    if ( @report.asset_id.nil? )
      return nil
    end

    @@collectors[@type].each do |collector|
      c = collector.new
      c.run
      @report.add collector::NAME, c.report
    end

    # End the report and return the results
    @report.finalize
  end

  private
    #
    # Attepmt to identify the ID of the asset
    #
    def determine_id
      id = nil
      case @type
      when :computer
        id = `sudo dmidecode -s system-serial-number`.chomp

        # Check if the id is valid (all word characters)
        return nil unless ( id =~ /^\w+$/ )
      end

      id
    end
end
