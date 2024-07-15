# 101-setup_web_static.pp

# Ensure the nginx package is installed
package { 'nginx':
  ensure => installed,
}

# Ensure the directories exist
file { ['/data', '/data/web_static', '/data/web_static/releases', '/data/web_static/releases/test', '/data/web_static/shared']:
  ensure => directory,
  owner  => 'ubuntu',
  group  => 'ubuntu',
  mode   => '0755',
}

# Create the test index.html file
file { '/data/web_static/releases/test/index.html':
  ensure  => file,
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
}

# Create a symbolic link for the current release
file { '/data/web_static/current':
  ensure => link,
  target => '/data/web_static/releases/test',
  owner  => 'ubuntu',
  group  => 'ubuntu',
}

# Create the nginx site configuration
file { '/etc/nginx/sites-available/hbnb_static':
  ensure  => file,
  content => 'server {
        location /hbnb_static {
                alias /data/web_static/current/;
                index index.html;
        }
}',
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
}

# Remove the default nginx site configuration
file { '/etc/nginx/sites-enabled/default':
  ensure => absent,
}

# Enable the new nginx site configuration
file { '/etc/nginx/sites-enabled/hbnb_static':
  ensure => link,
  target => '/etc/nginx/sites-available/hbnb_static',
}

# Ensure nginx service is running and restarted if necessary
service { 'nginx':
  ensure => running,
  enable => true,
  subscribe => File['/etc/nginx/sites-available/hbnb_static', '/etc/nginx/sites-enabled/hbnb_static'],
}

