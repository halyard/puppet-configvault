# @summary Deploy configvault tool for config loading/sharing
#
# @param bucket sets the default bucket for config data
# @param version sets the release of configvault to use
# @param binfile sets the location of the configvault binary
#
class configvault (
  String $bucket,
  String $version,
  String $binfile,
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

  file { $binfile:
    ensure => file,
    source => $url,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  Configvault_Write {
    bucket  => $configvault::bucket,
    user    => $trusted['hostname'],
    binfile => $configvault::binfile,
  }
}
