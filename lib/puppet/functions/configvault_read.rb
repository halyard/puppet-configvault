require 'open3'

Puppet::Functions.create_function(:'configvault_read') do
  dispatch :read do                                                       param 'String', :key
    optional_param 'Boolean', :public
    optional_param 'String', :user
    optional_param 'String', :bucket
    optional_param 'String', :envfile
    optional_param 'String', :binfile
    return_type 'String'
  end

  def read(key, is_public = true, user = nil, bucket = nil, envfile = nil, binfile = nil)
    bucket ||= lookup('configvault::bucket')
    envfile ||= lookup('configvault::envfile')
    binfile ||= lookup('configvault::binfile')

    env = parse_env(envfile)
    args = [binfile, 'read', bucket, key]
    args << '--private' unless is_public
    args << '--user=' + user if user
    stdout, stderr, status = Open3.capture3(env, [args])
    fail('Configvault failed: ' + stderr) if status.value != 0
    stdout
  end

  def lookup(key)
    Puppet::Pops::Lookup.lookup(key, nil, nil, false, nil, Puppet::Pops::Lookup::Invocation.new(closure_scope, {}, {}))
  end

  def parse_env(envfile)
    File.readlines(envfile).map { |x| x.chomp.split('=', 2) }.to_h
  end
end
