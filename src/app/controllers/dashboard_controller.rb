require 'aws-sdk'
load 'stack_dash.rb'

class DashboardController < ApplicationController
  def index
  end
  
  def get_stacks     
    Aws.use_bundled_cert!
    
    Aws.config.update({
      region: 'us-east-1',
      credentials: Aws::Credentials.new(ENV['access-key'], ENV['secret-key'])
    })

    stacks = []
    regions.each do |region|
      stacks_aws = Aws::CloudFormation::Client.new(region: region[:short_name]).describe_stacks.stacks 
          
      stacks_aws.each do |stack_aws|
        stack_dash = StackDash.new
        
        stack_dash.stack_id = stack_aws.stack_id
        stack_dash.creation_time = stack_aws.creation_time
        stack_dash.region = region[:name]
        stack_dash.description = stack_aws.description
        stack_dash.name = stack_aws.stack_name
        
        stack_aws.outputs.each do |output|
          stack_dash.app_url = output.output_value if output.output_key == 'WebSite'
        end
        
        stacks.push(stack_dash)
      end
    end
    
    render json: stacks
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
