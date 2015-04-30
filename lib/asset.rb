class Asset
  class NoNameError < StandardError; end
  class TypeRequired < StandardError; end

  attr_reader :report, :type

  # Create empty arrays for every asset type
  @@collectors = {
    :computer => {},
    :hard_drive => {}
  }

  def Asset.add_collector type, priority, collector
    @@collectors[type][priority] = [] if @@collectors[type][priority].nil?
    @@collectors[type][priority] << collector
  end

  #
  # Create a new instance of an asset. The type has to match
  # the one of the keys in the collectors hash.
  # Then try to get the ID ofthe asset. 
  #
  def initialize type, options={}
    if ( @@collectors.keys.include?(type) )
      @type = type
    else
      raise TypeRequired
    end

    @name = determine_name
    @id = fetch_id
    @options = options
    @report = {}

    raise NoNameError unless @name
  end

  #
  # Run the collectors associated with the asset 
  #
  def gather_information
    @@collectors[@type].keys.sort.each do |priority|
      @@collectors[@type][priority].each do |collector|
        c = collector.new @options
        c.run
        @report[collector::NAME] = c.to_hash
      end
    end
  end

  private
    #
    # Determine the name of the asset
    #
    def determine_name
      name = nil

      case @type
        when :computer
          name = `sudo dmidecode -s system-serial-number`.chomp
        when :hard_drive
          `sudo smartctl -i #{@options['device']}`.each_line do |line|
            line =~ /^Serial\sNumber:\s+([A-Za-z0-9_-]+)$/
            name = $1
          end
      end

      # Check if the id is valid (all word characters plus dash)
      if ( name =~ /^[A-Za-z0-9_-]+$/ )
        name
      else
        nil
      end
    end
    #
    # Fetch the ID from the inventory
    #
    def fetch_id
      return unless @name

      begin
        response = Inventory.request["assets/#{@name}"].get :content_type => :json, :accept => :json 
        asset = JSON.parse(response)
        asset['id']
      rescue RestClient::ResourceNotFound
        nil
      rescue => exception
        exception.response
        exit 1
      end
    end
end
