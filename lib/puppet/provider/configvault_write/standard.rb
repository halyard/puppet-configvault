Puppet::Type.type(:configvault_write).provide(:standard, :parent => Puppet::Provider::Package) do
  def create
  end

  def destroy
  end

  def exists?
  end
end
