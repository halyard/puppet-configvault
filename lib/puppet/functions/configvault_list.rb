require 'open3'

Puppet::Functions.create_function(:'configvault_list') do
  dispatch :list do
    param 'String', :key
    optional_param 'Boolean', :public
    optional_param 'String', :bucket
    optional_param 'String', :binfile
    return_type 'Array'
  end

  def list(key, is_public = true, user = nil, bucket = nil, binfile = nil)
    bucket ||= lookup('configvault::bucket')
    binfile ||= lookup('configvault::binfile')

    args = [binfile, 'list', bucket, key]
    args << '--private' unless is_public
    stdout, stderr, status = Open3.capture3(*args)
    fail('Configvault failed: ' + stderr) unless status.success?
    stdout.split("\n")
  end

  def lookup(key)
    Puppet::Pops::Lookup.lookup(key, nil, nil, false, nil, Puppet::Pops::Lookup::Invocation.new(closure_scope, {}, {}))
  end
end
