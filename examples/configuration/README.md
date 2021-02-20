# Configuration

taida can be configured using json and yaml files
The following uses yaml syntax to show the hierachy and dart types for typing.
You can also inject environment variables using `%env(VARIABLE_NAME)%` within the configuration.
It uses the null-safe syntax where String? means (String or null).
All file paths have to be relative to this file.

```yaml
taida:                      # Object
  output_dir: public        # String (default=build)
  enable_cache_buster: true # bool (default=false)
  log_file: null            # String? (default=null). 
                            # Null means file logging is disabled

  module_config:            # Object
    copy:                   # List<Object>? (default=null)
      - from:               # List<String>
          - copy
          - res/files
        to: assets/res      # String

    scss:                   # List<Object>? (default=null)
      - entry: app.scss     # String
        output: app.css     # String
        media: "(preferes-color-scheme: dark)" # String? (default=null)

    dart:                   # List<Object>? (default=null)
      - entry: app.dart     # String
        output: app.dart.js # String

    html:                   # Object
      templates_directory: templates    # String
      pages_directory: pages            # String (RELATIVE TO templates_directory!)
      partials_directory: _partials     # String (RELATIVE TO templates_directory!)

    meta:                   # Object
      tilecolor: black      # String
      short_name: taida     # String
      start_url: '.'        # String
      display: standalone   # String
      favicon_image: favicon.svg # String
      preview_image: preview.jpg # String
      keywords:             # List<String>
        - a
        - b
        - c
      twitter:              # Object
        type: summary       # String
        creator: '@glassp'  # String
        site: '@github'     # String

      open_graph:           # Object
        type: website       # String
        site: Github.com    # String

      related_applications: # List<Object>
        - platform: play    # String
          url: https://play.google.com/app/gdt8trg78w2  # String
```
