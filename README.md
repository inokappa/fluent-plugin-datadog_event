# Fluent::Plugin::DatadogEvent

Generates Datadog events from matching fluent records.

## Installation (from original source)

```
$ gem install fluent-plugin-datadog_event
```

## Configuration

### Syntax

```
<match ddevents.info>
  type datadog_event

  # DD api key - mandatory
  api_key MyApIKey110123kjla7

  # All other config parameters are optional

  # Datadog specific tags associated with event
  tags fluentevent

  # alert type: info, warning, error, or success
  alert_type info

  # aggregation key - anything with this unique value # will be considered an additional instance of the # same event
  aggregation_key "my_aggregation_key"

  # Message title
  msg_title "My app event"

  # Source name - for filtering by event source
  source_type_name "my_app_named"

  # Optional (or add it to record["host"])
  host myhost
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

With the above config, an event tagged as 'ddevents.myapp.info' would be handled at the level of info, with "myapp" as part of the message, source_type, and aggregation key - Use of rewrite-tag-names can make this very flexible.


## Contributing

1. Fork it ( https://github.com/inokappa/fluent-plugin-datadog_event )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
