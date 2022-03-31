Puppet::Type.type(:configvault_write).provide(:standard, :parent => Puppet::Provider::Package) do
  def create
  end

  def destroy
    File.unlink(@resource[:name])
  end

  def exists?
    File.exists?(@resource[:name])
  end
end
