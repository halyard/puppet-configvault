require 'pathname'
require 'puppet/parameter/boolean'

Puppet::Type.newtype :configvault_write do

  ensurable

  newparam :key, :namevar => true do
    desc 'The key for the entry'

    validate do |value|
      unless value =~ /^\w+$/
        raise ArgumentError, '%s is not a valid key' % value
      end
    end
  end

  newparam :source do
    desc 'The filepath to the value of the entry'

    validate do |value|
      unless Pathname.new(value).absolute?
        raise ArgumentError, '%s is not an absolute path' % value
      end
    end
  end

  newparam(:public, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    desc 'Whether or not the entry is public'

    defaultto do
      false
    end
  end

  newparam :bucket do
    validate do |value|
      unless value =~ /^\w+$/
        raise ArgumentError, '%s is not a valid bucket' % value
      end
    end
  end

  newparam :envfile do
    desc 'The filepath to the credentials envfile'

    validate do |value|
      unless Pathname.new(value).absolute?
        raise ArgumentError, '%s is not an absolute path' % value
      end
    end
  end

  autorequire :file do
    [self[:path], self[:envfile], '/usr/local/bin/configvault']
  end
end
