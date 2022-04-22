Puppet::Functions.create_function(:configvault_data) do
  dispatch :configvault_data do
    param 'Hash', :options
    param 'Puppet::LookupContext', :context
  end

  def configvault_data(options, context)
    raw = call_function('configvault_read', 'hiera', false)
    data = Puppet::Util::Yaml.safe_load(raw)
    context.not_found if data.empty? || !data.is_a?(Hash)
    context.cache_all(data)
    data
  end
end
