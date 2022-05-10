Puppet::Functions.create_function(:configvault_data) do
  dispatch :configvault_data do
    param 'Hash', :options
    param 'Puppet::LookupContext', :context
  end

  def configvault_data(options, context)
    context.not_found if context.cached_value('__failed__')
    begin
      raw = call_function(
        'configvault_read',
        'hiera/config.yaml',
        false,
        '',
        options['user'],
        options['bucket'],
        options['binfile']
      )
    rescue
      Puppet.info('configvault hiera failed to load')
      context.cache('__failed__', true)
      context.not_found
    end
    data = Puppet::Util::Yaml.safe_load(raw)
    if data.nil? || !data.is_a?(Hash)
      Puppet.warning('configvault hiera failed to parse')
      context.cache('__failed__', true)
      context.not_found
    end
    context.cache_all(data)
    data
  end
end
