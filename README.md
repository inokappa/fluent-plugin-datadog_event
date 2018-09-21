# Fluent::Plugin::DatadogEvent

Generates Datadog events from matching fluent records.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-datadog_event'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-datadog_event

(latter path depending upon acceptance)

## Configuration

### Syntax

```
<match ddevents.info>
  type datadog_event
  # DD api key - mandatory
  api_key MyApIKey110123kjla7
  # all other config parameters are optional
  # datadog specific tags associated with event
  tags fluentevent
  # alert type: info, warning, error, or success
  alert_type info
  # aggregation key - anything with this unique value will be considered an additional instance of the same event
  aggregation_key "my_aggregation_key"
  # Message title 
  msg_title "My app event"
  # Source name - for filtering by event source
  source_type_name "my_app_named"
</match>
```

### Dynamic config

Tag values can be used for configuration, leading to a config style such as:

```
<match ddevents.**>
  type datadog_event
  api_key yOuraPIKeyaaAAAAaA
  tags fluentevent
  alert_type $tag_parts[2]
  aggregation_key $tag_parts[1]
  msg_title "App event: ${tag_parts[1]}"
  source_type_name "fluent-${tag_parts[1])"
</match>
```

With the above config, an event tagged as 'ddevents.myapp.info' would be handled at the level of info, with "myapp" as part of the messahe, source_type, and aggregation key - Use of rewrite-tag-names can make this very flexible.

