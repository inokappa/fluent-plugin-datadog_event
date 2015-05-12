module Fluent
  class InDatadogEvent < Fluent::Input
    #Fluent::Plugin.register_input('in_datadog_event', self)
    Fluent::Plugin.register_input('datadog_event', self)

    unless method_defined?(:log)
      define_method("log") { $log }
    end

    unless method_defined?(:router)
      define_method("router") { Fluent::Engine }
    end

    config_param :api_key, :string
    config_param :app_key, :string, :default => nil
    config_param :priority, :string, :default => nil
    config_param :interval, :integer, :default => 60
    config_param :period, :integer, :default => 60
    config_param :tag, :string, :default => nil
    config_param :state_file, :string

    def initialize
      super
      #
      require "dogapi"
    end

    def start
      @dog = Dogapi::Client.new(@api_key, @app_key)
      @finished = false
      @thread = Thread.new(&method(:run))
    end

    def shutdown
      @finished = true
      @thread.join
    end

    private

    def read_id(event_id)
      return nil unless File.exist?(@state_file)
      ids = File.read(@state_file).chomp
      ids.include?(event_id.to_s)
    end

    def store_read_id(event_id)
      open(@state_file, 'a') do |f|
        f.write event_id
      end
    end

    def reset_state_file
      open(@state_file, 'w').close()
    end

    def run
      loop do
        sleep @interval
        #
        response = get_stream_events[1]["events"]
        #
        response.reverse_each do |e|
          event_id = e["id"]
          unless read_id(event_id) then
            time = e["date_happened"]
            router.emit(@tag, time, e)
            store_read_id(event_id)
          end
        end
      end
    end

    def get_stream_events
      reset_state_file
      options = {}
      options[:priority] = @priority
      options[:tags] = @tags

      start_time = Time.now.to_i - @period
      end_time = Time.now.to_i 

      res = @dog.stream(start_time, end_time, options)
      # for debug
      #puts "debug_out: #{res}\n"
    end
  end
end
