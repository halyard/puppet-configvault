require 'open3'

Puppet::Type.type(:configvault_write).provide(:standard, :parent => Puppet::Provider::Package) do
  def create
    run_cmd('write', false, expected)
  end

  def destroy
    run_cmd('delete')
  end

  def exists?
    current = run_cmd('read', true)
    return false if current.nil?
    return current == expected
  end

  def expected
    @expected ||= File.read(@resource[:source])
  end

  def build_cmd(action)
    user = @resource[:user] || defaults[:user]

    args = [
      @resource[:binfile] || defaults[:binfile],
      action,
      @resource[:bucket] || defaults[:bucket],
      @resource[:key],
      '--user=' + user
    ]
    if !@resource[:public] && (action == 'read' || action == 'list')
      args << '--private'
    elsif @resource[:public] && (action == 'write' || action == 'delete')
      args << '--public'
    end
    args
  end

  def run_cmd(action, missing_ok = false, stdin_data = nil)
    cmd = build_cmd(action)

    stdout, stderr, status = Open3.capture3(*cmd, stdin_data: stdin_data)
    unless status.success?
      return nil if missing_ok && stderr =~ /https response error StatusCode: 404/
      fail('Configvault failed: ' + stderr)
    end
    stdout
  end

  def defaults
    @defaults ||= @resource.parent.catalog.resources.find { |x| x.parameters[:name] && x.parameters[:name].value == 'Configvault' }.original_parameters
  end

  def self.instances
    []
  end
end
