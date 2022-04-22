Puppet::Functions.create_function(:configvault_data) do
  dispatch :configvault_data do
    param 'Hash', :options
    param 'Puppet::LookupContext', :context
  end

  def configvault_data(options, context)
    begin
      raw = call_function(
        'configvault_read',
        'hiera/config.yaml',
        false,
        options['user'],
        options['bucket'],
        options['binfile']
      )
    rescue
      Puppet.warning('configvault hiera failed to load')
      context.not_found
      context.cache_all({})
      return {}
    end
    data = Puppet::Util::Yaml.safe_load(raw)
    context.cache_all(data)
    data
  end
end
