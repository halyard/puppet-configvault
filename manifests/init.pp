# @summary Deploy configvault tool for config loading/sharing
#
# @param version sets the release of configvault to use
#
class configvault (
  String $bucket,
  String $version = '0.0.1',
  String $envfile = '/etc/configvault'
) {
  $kernel = downcase($facts['kernel'])
  $arch = $facts['os']['architecture'] ? {
    'x86_64' => 'amd64',
    'arm64'  => 'arm64',
    'arm'    => 'arm',
    default  => 'error',
  }

  $filename = "configvault_${kernel}_${arch}"
  $url = "https://github.com/akerl/configvault/releases/download/${version}/${filename}"


  file { '/usr/local/bin/configvault':
    ensure => file,
    source => $url,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  ConfigvaultWrite {
    bucket => $configvault::bucket
  }
}
