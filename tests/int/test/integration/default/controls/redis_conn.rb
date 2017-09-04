# encoding: utf-8
# copyright: 2017, The Authors
# license: All rights reserved

title 'Check Redis Cache connection'


control 'azure-rediscache-conn' do
  impact 1.0
  title ' Check that we can connect to Redis'
  desc 'TODO: test will only work after peering between Management and Application vnets will be implemented'

  only_if do
    true == false
  end

  json_obj = json('.kitchen/kitchen-terraform/default-azure/terraform.tfstate')

  random_prefix = json_obj['modules'][0]['outputs']['random_name']['value']
  rgName = random_prefix+ '-cache-int'
  redisName = random_prefix+ '-int'

  # redis_url = attribute('url', default: redisName+'.redis.cache.windows.net', description: 'Redis Url')
  # redis_port = attribute('port', default: 6379, description: 'Tested Redis Port')
  # redis_pass = attribute('pass', description: 'Pass for tested Redis instance')

  describe host(redisName+'.redis.cache.windows.net', port:6379, protocol: 'tcp') do
    it { should be_resolvable }
    it { should be_reachable }
  end

  describe host(redisName+'.redis.cache.windows.net', port:6380, protocol: 'tcp') do
    it { should be_resolvable }
    it { should be_reachable }
  end

  #TODO: Leverage Redis module for even more useful tests on redis instance
  # https://github.com/redis/redis-rb
  # redis = Redis.new(url: "redis://:redis_pass@redis_url:redis_port/15")
  # redis = Redis.new(host: redisName, port: 6379, db: 15)
  # describe redis do
  #   it {should_not be nil}
  # end
end
