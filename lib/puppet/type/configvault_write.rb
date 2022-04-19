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

  newparam :user do
    desc 'User to write file for'

    validate do |value|
      unless value =~ /^[a-zA-Z0-9_=]+$/ || value.nil
        raise ArgumentError, '%s is not a valid user % value'
      end
    end

    defaultto do
      nil
    end
  end

  newparam :bucket do
    desc 'Bucket to write file to'

    validate do |value|
      unless value =~ /^[a-zA-Z0-9_=]+$/ || value.nil
        raise ArgumentError, '%s is not a valid bucket' % value
      end
    end

    defaultto do
      nil
    end
  end

  newparam :binfile do
    desc 'Path for configvault binary'

    validate do |value|
      unless Pathname.new(value).absolute? || value.nil
        raise ArgumentError, '%s is not an absolute path' % value
      end
    end

    defaultto do
      nil
    end
  end

  autorequire :file do
    [self[:source], self[:binfile]]
  end
end
