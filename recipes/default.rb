#
# Cookbook Name:: signalfx_handler
# Recipe:: default
#
# Copyright (C) 2017 Drew Hamilton
#
# All rights reserved - Do Not Redistribute

include_recipe "chef_handler"

chef_gem "signalfx"

cookbook_file "#{node['chef_handler']['handler_path']}/signalfx_handler.rb" do
  source 'signalfx_handler.rb'
end

chef_handler "SignalfxReporting" do
  source "#{node['chef_handler']['handler_path']}/signalfx_handler.rb"
  arguments [
    :signalfx_token => node["chef_signalfx"]["token"],
    :dimensions => node["chef_signalfx"]["dimensions"],
    :node_name => node["hostname"]
  ]
  supports :report => true
  action :enable
end
