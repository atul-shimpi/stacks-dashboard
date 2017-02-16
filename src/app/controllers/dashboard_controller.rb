require 'aws-sdk'

class DashboardController < ApplicationController
  def index
  end
  
  def get_stacks
    Aws.use_bundled_cert!

    Aws.config.update({
      region: 'us-east-1',
      credentials: Aws::Credentials.new('xxx', 'xxx')
    })

    cf = Aws::CloudFormation::Client.new()
    stacks =  cf.describe_stacks
    
    response = []
    stacks.each do |stack|
    end
    
    render json: response
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
