require 'chef'
require 'chef/log'
require 'chef/handler'
require 'signalfx'

class SignalfxReporting < Chef::Handler
  attr_reader :signalfx_token, :dimensions, :node_name

  def initialize(options={})
    Chef::Log.debug('Initializing Chef::Handler::SignalfxReporting')
    @signalfx_token = options[:signalfx_token]
    @dimensions = options[:dimensions]
    @node_name = options[:node_name]
  end

  def report
    Chef::Log.debug("Token: #{@signalfx_token}")
    signalfx = SignalFx.new @signalfx_token
    counters = []
    prefix = 'chef.client_run'
    node = "#{@node_name}"
    event_type = 'chef_client_run'
    timestamp = (Time.now.to_i * 1000).to_i

    if run_status.success?
      run_status_metric = 1
      run_state = "ok"
      run_event_category = SignalFxClient::EVENT_CATEGORIES[:JOB]
    else
      run_status_metric = 0
      run_state = "critical"
      run_event_category = SignalFxClient::EVENT_CATEGORIES[:ALERT]
      run_event_properties = ''
      signalfx.send_event(event_type,event_category: run_event_category,dimensions: @dimensions,properties: run_event_properties)
    end

    # run status
    run_event = Hash.new
    run_event[:metric] = "#{prefix}.#{node}.run_status"
    run_event[:value] = run_status_metric
    run_event[:timestamp] = timestamp
    run_event[:dimensions] = @dimensions
    counters << run_event

    # updated resources
    updated_resources = Hash.new
    updated_resources[:metric] = "#{prefix}.#{node}.updated_resources"
    updated_resources[:value] = run_status.respond_to?(:updated_resources) ? run_status.updated_resources.length : 0
    updated_resources[:timestamp] = timestamp
    updated_resources[:dimensions] = @dimensions
    counters << updated_resources

    # all resources
    all_resources = Hash.new
    all_resources[:metric] = "#{prefix}.#{node}.all_resources"
    all_resources[:value]= run_status.respond_to?(:all_resources) ? run_status.all_resources.length : 0
    all_resources[:timestamp] = timestamp
    all_resources[:dimensions] = @dimensions
    counters << all_resources

    # elapsed time
    elapsed_time = Hash.new
    elapsed_time[:metric] = "#{prefix}.#{node}.elapsed_time"
    elapsed_time[:value]= run_status.elapsed_time
    elapsed_time[:timestamp] = timestamp
    elapsed_time[:dimensions] = @dimensions
    counters << elapsed_time

    # submit events
    Chef::Log.debug("Sending counters #{counters}")
    signalfx.send(counters: counters)
  end
end
