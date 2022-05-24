require 'open3'

Puppet::Functions.create_function(:'configvault_read') do
  dispatch :read do
    param 'String', :key
    optional_param 'Boolean', :public
    optional_param 'String', :default
    optional_param 'String', :user
    optional_param 'String', :bucket
    optional_param 'String', :binfile
    return_type 'String'
  end

  def read(key, is_public = true, default = nil, user = nil, bucket = nil, binfile = nil)
    bucket ||= lookup('configvault::bucket')
    binfile ||= lookup('configvault::binfile')
    user ||= lookup('configvault::user')

    args = [binfile, 'read', bucket, key, '--user=' + user]
    args << '--private' unless is_public
    stdout, stderr, status = Open3.capture3(*args)
    return stdout.chomp if status.success?
    return default if default
    fail('Configvault failed: ' + stderr)
  end

  def lookup(key)
    Puppet::Pops::Lookup.lookup(key, nil, nil, false, nil, Puppet::Pops::Lookup::Invocation.new(closure_scope, {}, {}))
  end
end
