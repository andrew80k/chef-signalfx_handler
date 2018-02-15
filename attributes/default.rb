default["chef_signalfx"]["token"] = 'YOUR_TOKEN_NUMBER_HERE'
default["chef_signalfx"]["dimensions"] = [
  {:key => 'environment', :value => node.chef_environment}
]
