# 101-setup_web_static.pp

# Configures a web server for deployment of web_static.

# Nginx configuration file
$nginx_conf = @("EOF"
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    add_header X-Served-By $hostname;
    root   /var/www/html;
    index  index.html index.htm;

    location /hbnb_static {
        alias /data/web_static/current;
        index index.html index.htm;
    }

    location /redirect_me {
        return 301 https://www.google.com;
    }

    error_page 404 /404.html;

    location /404 {
        root /var/www/html;
        internal;
    }
}
"EOF
)

package { 'nginx':
  ensure   => 'present',
  provider => 'apt',
}

file { '/data':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
} ->

file { '/data/web_static':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
} ->

file { '/data/web_static/releases':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
} ->

file { '/data/web_static/releases/test':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
} ->

file { '/data/web_static/shared':
  ensure => 'directory',
  owner  => 'ubuntu',
  group  => 'ubuntu',
} ->

file { '/data/web_static/releases/test/index.html':
  ensure  => 'present',
  content => '<html>
  <head>
  </head>
  <body>
    Holberton School
  </body>
</html>',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  mode    => '0644',
} ->

file { '/data/web_static/current':
  ensure => 'link',
  target => '/data/web_static/releases/test',
  owner  => 'ubuntu',
  group  => 'ubuntu',
}

exec { 'chown -R ubuntu:ubuntu /data/':
  command => '/bin/chown -R ubuntu:ubuntu /data/',
  require => File['/data/web_static/current'],
}

file { '/var/www':
  ensure => 'directory',
} ->

file { '/var/www/html':
  ensure => 'directory',
} ->

file { '/var/www/html/index.html':
  ensure  => 'present',
  content => 'Holberton School Nginx\n',
} ->

file { '/var/www/html/404.html':
  ensure  => 'present',
  content => 'Ceci n\'est pas une page\n',
}

file { '/etc/nginx/sites-available/default':
  ensure  => 'present',
  content => $nginx_conf,
  notify  => Service['nginx'],
}

service { 'nginx':
  ensure    => 'running',
  enable    => true,
  subscribe => File['/etc/nginx/sites-available/default'],
}
