class roundcubemail (
    String $db_host               = 'db4.miraheze.org',
    String $db_name               = 'roundcubemail',
    String $db_user_name          = 'roundcubemail',
    String $db_user_password      = undef,
    String $roundcubemail_des_key = undef,
) {

    include ::nodejs

    ensure_resource_duplicate('class', 'php::php_fpm', {
        'config'  => {
            'display_errors'            => 'Off',
            'error_log'                 => '/var/log/php/php.log',
            'error_reporting'           => 'E_ALL & ~E_DEPRECATED & ~E_STRICT',
            'log_errors'                => 'On',
            'max_execution_time'        => 70,
            'opcache'                   => {
                'enable'                  => 1,
                'memory_consumption'      => 256,
                'interned_strings_buffer' => 64,
                'max_accelerated_files'   => 32531,
                'revalidate_freq'         => 60,
            },
            'post_max_size'       => '35M',
            'register_argc_argv'  => 'Off',
            'request_order'       => 'GP',
            'track_errors'        => 'Off',
            'upload_max_filesize' => '100M',
            'variables_order'     => 'GPCS',
        },
        'version' => hiera('php::php_version', '7.2'),
    })

    require_package('php7.2-pspell')

    git::clone { 'roundcubemail':
        directory          => '/srv/roundcubemail',
        origin             => 'https://github.com/roundcube/roundcubemail',
        branch             => '1.4-beta', # we are using the beta for the new skin
        recurse_submodules => true,
        owner              => 'www-data',
        group              => 'www-data',
    }

    file { '/srv/roundcubemail/config/config.inc.php':
        ensure => present,
        content => template('roundcubemail/config.inc.php.erb'),
        owner  => 'www-data',
        group  => 'www-data',
        require => Git::Clone['roundcubemail'],
    }

    include ssl::wildcard

    nginx::site { 'mail':
        ensure      => present,
        source      => 'puppet:///modules/roundcubemail/mail.miraheze.org.conf',
        notify_site => Exec['nginx-syntax-roundcubemail'],
    }

    nginx::site { 'roundcubemail':
        ensure      => present,
        source      => 'puppet:///modules/roundcubemail/roundcubemail.conf',
        notify_site => Exec['nginx-syntax-roundcubemail'],
    }

    exec { 'nginx-syntax-roundcubemail':
        command     => '/usr/sbin/nginx -t',
        notify      => Exec['nginx-reload-roundcubemail'],
        refreshonly => true,
    }

    exec { 'nginx-reload-roundcubemail':
        command     => '/usr/sbin/service nginx reload',
        refreshonly => true,
        require     => Exec['nginx-syntax-roundcubemail'],
    }

    monitoring::services { 'webmail.miraheze.org HTTPS':
        check_command  => 'check_http',
        vars           => {
            http_expect => 'HTTP/1.1 401 Unauthorized',
            http_ssl   => true,
            http_vhost => 'webmail.miraheze.org',
        },
     }
}
