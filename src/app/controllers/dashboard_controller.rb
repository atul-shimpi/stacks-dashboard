require 'aws-sdk'
load 'stack_dash.rb'

class DashboardController < ApplicationController
  def index
  end
  
  def get_stacks
    puts get_data_usage('us-east-1', 'MyBB-MyBBWebServerAutoscalingGroup-1RIU05EX08YSR')
    
    render json: { stacks: 'Atul Shmpi' }
  end
  
  def get_stacks_
    Aws.use_bundled_cert!
    
    Aws.config.update({
      region: 'us-east-1',
      credentials: Aws::Credentials.new(ENV['access-key'], ENV['secret-key'])
    })

    stacks = []
    regions.each do |region|
      cf_client = Aws::CloudFormation::Client.new(region: region[:short_name])
      
      stacks_aws = cf_client.describe_stacks.stacks
      
      stacks_aws.each do |stack_aws|
        stack_dash = StackDash.new
        
        stack_dash.stack_id = stack_aws.stack_id
        stack_dash.creation_time = stack_aws.creation_time
        stack_dash.region = region[:name]
        stack_dash.description = stack_aws.description[0..15]
        stack_dash.name = stack_aws.stack_name
                
        stack_aws.outputs.each do |output|
          stack_dash.app_url = output.output_value if output.output_key == 'WebSite'
        end       
        
        stack_dash.stack_status = stack_aws.stack_status
        
        # get metrics
        metrics =  get_metrics(region[:short_name], cf_client, stack_dash.name)
        
        stack_dash.healthy_instances = metrics[:healthy_instances_count]
        stack_dash.cpu_usage = metrics[:cpu_usage]
        stack_dash.data_usage = metrics[:data_usage]
        
        stacks.push(stack_dash)
      end
    end
    
    render json: stacks
  end
  
  def get_metrics(region, cf_client, stack_name)
    # get resources    
    resources = get_resources(region, cf_client, stack_name)
    
    # get metrics
    metrics = {}
    
    # get healthy instances count
    metrics[:healthy_instances_count] = get_healthy_instances_count(region, resources[:elb_name])
    # get cpu usage
    metrics[:cpu_usage] = get_cpu_usage(region, resources[:asg_name])   
    
    metrics
  end
  
  def get_resources(region, cf_client, stack_name)
    resources = {}
    
    # get load balancer name
    begin
      resources[:elb_name] = cf_client.describe_stack_resource({
          stack_name: stack_name,
          logical_resource_id: "PublicElasticLoadBalancer"
        }).stack_resource_detail['physical_resource_id']
    rescue
      resources[:elb_name] = nil
    end
    
    # get asg name
    begin
      resources[:asg_name] = cf_client.describe_stack_resource({
          stack_name: stack_name,
          logical_resource_id: "MyBBWebServerAutoscalingGroup"
        }).stack_resource_detail['physical_resource_id']
    rescue
      resources[:asg_name] = nil
    end
    
    resources
  end
   
  def get_healthy_instances_count(region, elb_name)
    return 'Not Available' if elb_name.nil? 
    
    begin      
      # get load balancer instance details
      instances_health = Aws::ElasticLoadBalancing::Client.new(region: region)
        .describe_instance_health({
          load_balancer_name: elb_name
        })
        .instance_states
    
      healthy_instances_count = 0
      instances_health.each do |instance|       
        healthy_instances_count = healthy_instances_count + 1 if instance[:state] = 'InService'
      end
      
      "#{healthy_instances_count} of #{instances_health.size}"
    rescue
     "Not Available"
   end
  end
  
  def get_cpu_usage(region, asg_name)
    return 'Not Available' if asg_name.nil? 
    
    begin      
      metrics = Aws::CloudWatch::Client.new(region: region)
        .get_metric_statistics({
          namespace: 'AWS/EC2',
          metric_name: 'CPUUtilization',
          dimensions: [{ name: 'AutoScalingGroupName', value: asg_name }],
          start_time: 30.minutes.ago,
          end_time: Time.now,
          statistics: ['Average'],
          period: 30 * 60
        }) 
      
      "#{metrics.datapoints[0][:average].round(2)} %"
    rescue
      'Not Available'
   end   
  end
  
  def get_data_usage(region, asg_name)
    return 'Not Available' if asg_name.nil? 
    
    #begin      
      metrics = Aws::CloudWatch::Client.new(region: region)
        .get_metric_statistics({
          namespace: 'AWS/EC2',
          metric_name: 'NetworkOut',
          dimensions: [{ name: 'AutoScalingGroupName', value: asg_name }],
          start_time: 60.minutes.ago,
          end_time: Time.now,
          statistics: ['Average'],
          period: 60 * 60,
          unit: 'Kilobytes'
        }) 
      
      puts metrics
      "#{metrics.datapoints[0][:average].round(2)}"
    #rescue
     # 'Not Available'
   #end   
  end
  
  def save_access_keys
    puts params
    ENV['access-key'] = params['accesskey']
    ENV['secret-key'] = params['secretkey']
    render :nothing => true, :status => 200
  end
  
  def get_access_keys
    keys = {
    :keys => {
      :accesskey => ENV['access-key'],
      :secretkey => ENV['secret-key']
    }
  }
  
    render json: keys
  end
  
  
  def greet
    ticket_type = {
    :ticket_type => {
      :type_of_ticket => "Configure VPN"
    }
  }
  
  render json: ticket_type
  end
end
