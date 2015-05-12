require 'helper'

class OutDatadogEventTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    api_key API_KEY
    alert_type warn
  ]

  def create_driver(conf = CONFIG, tag='test')
    Fluent::Test::OutputTestDriver.new(Fluent::OutDatadogEvent, tag).configure(conf)
  end

  def test_configure
    d = create_driver(CONFIG)
    assert_equal d.instance.api_key, 'API_KEY'
    assert_equal d.instance.alert_type, 'warn'
  end

  def test_post_event
    record = {
      :msg_text => 'foo',
      :msg_title => 'bar',
      :alert_type => 'warn'
    }
    d = create_driver(CONFIG)
    d.emit(record)
  end

end
