# signalfx_handler-cookbook

TODO: Enter the cookbook description here.

## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['signalfx_handler']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### signalfx_handler::default

Include `signalfx_handler` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[signalfx_handler::default]"
  ]
}
```

## License and Authors

Author:: Drew Hamilton (<ahamilton@aligntech.com>)
