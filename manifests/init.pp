# Install and configure the KermIT Webui, a dashboard that provides a central
# management solution for IT systems and applications.
# See http://www.kermit.fr

class kermitwebui {

    include redis
    include yum::epel
    include kermit

    # cf puppetlabs-apache
    class { 'apache' : }

    #include apache
    #realize( Package[ 'httpd' ] )
    #realize( Service[ 'httpd' ] )

    if $::operatingsystemrelease =~ /^5\./ {
      $webuireq_packages = [
        'Django', 'uuid', 'python26', 'python26-docutils', 'ordereddict',
        'python26-httplib2', 'python26-redis', 'python26-mod_wsgi',
        'django-celery', 'django-grappelli', 'django-guardian', 'django-kombu',
        'django-picklefield', 'policycoreutils',
      ]
    }

    if $::operatingsystemrelease =~ /^6\./ {
      $webuireq_packages = [
        'Django', 'uuid', 'python-docutils', 'python-ordereddict',
        'python-httplib2', 'python-redis', 'python-dateutil15',
        'python-amqplib', 'mod_wsgi', 'django-celery','django-grappelli',
        'django-guardian', 'django-kombu', 'django-picklefield',
        'policycoreutils-python',
      ]
    }

    package { $webuireq_packages :
        ensure  => present,
        require => Yumrepo[ 'kermit-custom', 'kermit-thirdpart' ],
    }

    package { 'kermit-webui' :
        ensure  => present,
        require => Package [ $webuireq_packages ],
    }

    file { '/etc/httpd/conf.d/kermit-webui.conf' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template( 'kermitwebui/kermit-webui.conf' ),
        require => Package[ 'httpd', 'kermit-webui' ],
    }

    file { '/etc/kermit/kermit-webui.cfg' :
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/kermitwebui/kermit-webui.cfg',
        require => File[ '/etc/kermit/' ],
    }

    file { '/root/kermit' :
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0750',
    }


    file { 'purge-jobs_waiting.sh' :
        ensure  => present,
        path    => '/root/kermit/purge-jobs_waiting.sh',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/kermitwebui/purge-jobs_waiting.sh',
        replace => false,
        require => File[ '/root/kermit' ],
    }

    file { 'purge-redis.sh' :
        ensure  => present,
        path    => '/root/kermit/purge-redis.sh',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/kermitwebui/purge-redis.sh',
        replace => false,
        require => File[ '/root/kermit' ],
    }

    file { 'postconf.sh' :
        ensure  => present,
        path    => '/root/kermit/postconf.sh',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => 'puppet:///modules/kermitwebui/postconf.sh',
        replace => false,
        require => File[ '/root/kermit' ],
    }

}

