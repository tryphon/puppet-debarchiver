#
# To create debarchiver gpg directory :
# gpg --homedir files/debarchiver --gen-key
# 
# To create public key :
# gpg --homedir files/debarchiver --export -a <keyid>
#
class debarchiver {

  package { debarchiver: }

  # require $debarchiver_gpg_key and $debarchiver_mailtos
  file { "/etc/debarchiver.conf":
    content => template("debarchiver/debarchiver.conf")
  }

  file { "/var/lib/debarchiver/.gnupg":
    ensure => directory,
    owner => "debarchiver", 
    group => "debarchiver",
    mode => 700,
    require => Package[debarchiver]
  }

  file { "/var/lib/debarchiver/.gnupg/passphrase":
    source => "puppet:///files/debarchiver/passphrase",
    owner => "debarchiver",
    group => "debarchiver",
    mode => 600
  }

  file { "/var/lib/debarchiver/.gnupg/pubring.gpg":
    source => "puppet:///files/debarchiver/pubring.gpg",
    owner => "debarchiver",
    group => "debarchiver",
    mode => 600
  }
  file { "/var/lib/debarchiver/.gnupg/secring.gpg":
    source => "puppet:///files/debarchiver/secring.gpg",
    owner => "debarchiver",
    group => "debarchiver",
    mode => 600
  }
  file { "/var/lib/debarchiver/.gnupg/trustdb.gpg":
    source => "puppet:///files/debarchiver/trustdb.gpg",
    owner => "debarchiver",
    group => "debarchiver",
    mode => 600
  }

  define incoming_dir() {
    file { "/var/lib/debarchiver/incoming/$name":
      ensure => directory,
      owner => "root",
      group => "debarchiver",
      mode => 2775,
      require => Package[debarchiver]
    }
  }

  incoming_dir { [ lenny, squeeze, wheezy, sid, karmic, lucid, maverick, natty, oneiric ]: }

  file { "/var/lib/debarchiver/dists/oldstable":
    ensure => "/var/lib/debarchiver/dists/lenny"
  }
  file { "/var/lib/debarchiver/dists/stable":
    ensure => "/var/lib/debarchiver/dists/squeeze"
  }
  file { "/var/lib/debarchiver/dists/testing":
    ensure => "/var/lib/debarchiver/dists/wheezy"
  }
  file { "/var/lib/debarchiver/dists/unstable":
    ensure => "/var/lib/debarchiver/dists/sid"
  }
}
