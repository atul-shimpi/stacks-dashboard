require 'aws-sdk'

Aws.use_bundled_cert!

Aws.config.update({
  region: 'us-east-2',
  credentials: Aws::Credentials.new('xxx', 'xxx')
})

cf = Aws::CloudFormation::Client.new()
puts cf.describe_stacks