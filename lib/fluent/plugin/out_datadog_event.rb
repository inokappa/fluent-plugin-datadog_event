module Fluent
  class OutDatadogEvent < Fluent::Output
    Fluent::Plugin.register_output('datadog_event', self)

    unless method_defined?(:log)
      define_method("log") { $log }
    end

    config_param :api_key, :string
    config_param :app_key, :string, :default => nil
    config_param :msg_title, :string, :default => 'fluentd Datadog Event'
    config_param :priority, :string, :default => nil
    config_param :tags, :string, :default => nil
    config_param :alert_type, :string, :default => nil
    config_param :aggregation_key, :string, :default => nil
    config_param :source_type_name, :string, :default => 'fluentd'

    def initialize
      super
      #
      require "dogapi"
      require "date"
    end

    def start
      @dog = Dogapi::Client.new(@api_key, @app_key)
      @finished = false
    end

    def shutdown
      @finished = true
      @thread.join
    end

    def emit(tag, es, chain)
      chain.next
      es.each do |time,record|
        post_event(time, "record", record)
      end
    end

    def post_event(time, event_key, event_msg)
      res = @dog.emit_event(Dogapi::Event.new(
        "#{event_msg}", 
        :msg_title => @msg_title, 
        :date_happend => time,
        :priority => @priority,
        # :host => @host,
        :tags => @tags,
        :alert_type => @alert_type,
        :aggregation_key => @aggregation_key,
        :source_type_name => @source_type_name
      ))
      # for debug
      #puts "debug_out: #{res}\n"
    end

  end
end
