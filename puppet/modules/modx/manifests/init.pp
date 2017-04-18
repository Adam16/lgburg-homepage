class modx {

	mysql::db { 'modx':
		ensure   => 'present',
		user     => 'modx',
		password => 'password',
		host     => 'localhost',
		grant    => ['all'],
		charset  => 'utf8',
	}

	mysql_user { "modx@%":
		ensure        => present,
		password_hash => mysql_password("password"),
		require       => [Mysql::Db['modx']],
	}

	mysql_grant { 'modx@%/modx.*':
		ensure     => 'present',
		options    => ['GRANT'],
		privileges => ['ALL'],
		table      => 'modx.*',
		user       => 'modx@%',
		require    => [Mysql::Db['modx']],
	}

	mysql_user { "root@%":
		ensure        => present,
		password_hash => mysql_password("password"),
		require       => [Mysql::Db['modx']],
	}

	mysql_grant { "root@%/*.*":
		user       => 'root@%',
		privileges => "all",
		table      => '*.*',
		require    => Mysql_user["root@%"],
	}

	file { '/var/www/config.xml':
		content => template('modx/config.xml')
	}

	exec { 'installModx':
		cwd     => "${document_root}",
		command => "php ${document_root}/html/setup/index.php --installmode=new --config=${document_root}/config.xml --core_path=${document_root}/core/;
			rm ${document_root}/setup.lock",
		require => [Mysql_user["modx@%"], Mysql_grant["modx@%/modx.*"]],
		onlyif  => 'test -e setup.lock',
	}

	exec { 'installGitify':
		cwd     => "${document_root}",
		command => "git clone https://github.com/modmore/Gitify.git Gitify;
			cd Gitify;
			composer install;
			chmod +x Gitify",
		require => [Mysql_user["modx@%"], Mysql_grant["modx@%/modx.*"]],
		onlyif  => 'test -e setup.lock',
	}
}
