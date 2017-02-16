class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  
  def regions
    [ 
      {name: 'US East (N. Virginia)', short_name: 'us-east-1'}
    ]
  end
  
  def regions_    
    [ 
      {name: 'US East (N. Virginia)', short_name: 'us-east-1'},
      {name: 'US East (Ohio)', short_name: 'us-east-2'},
      {name: 'US West (N. California))', short_name: 'us-west-1'},
      {name: 'US West (Oregon)', short_name: 'us-west-2'},
      {name: 'Canada (Central)', short_name: 'ca-central-1'},
      {name: 'Asia Pacific (Mumbai)', short_name: 'ap-south-1'},
      {name: 'Asia Pacific (Seoul)', short_name: 'ap-northeast-2'},
      {name: 'Asia Pacific (Singapore)', short_name: 'ap-southeast-1'},
      {name: 'Asia Pacific (Sydney)', short_name: 'ap-southeast-2'},
      {name: 'Asia Pacific (Tokyo)', short_name: 'ap-northeast-1'},
      {name: 'EU (Frankfurt)', short_name: 'eu-central-1'},
      {name: 'EU (Ireland)', short_name: 'eu-west-1'},
      {name: 'EU (London)', short_name: 'eu-west-2'},
      {name: 'South America (São Paulo)', short_name: 'sa-east-1'}
    ]
  end
end
