default["chef_signalfx"]["token"] = 'NdRd2daQungsXmALu3-uGA'
default["chef_signalfx"]["dimensions"] = [
  {:key => 'environment', :value => node.chef_environment}
]
