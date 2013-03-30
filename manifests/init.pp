# == Class: zabbix-agent
#
# Zabbix agent software
#
# === Parameters
#
# [*server*]
#   String. Hostname of the Zabbix server. Defaults to control.projectzenonline.com
#
# === Variables
#
# none
#
# === Examples
#
# class { 'zabbix_agent': }
# class { 'zabbix_agent': server => 'zabbixserver.mydomain.com' }
#
# === Authors
#
# Eric Floerchinger <eric@pzo.vg>
#
# === Copyright
#
# Copyright 2013 Project Zen Online, LLC, unless otherwise noted.
#
class zabbix_agent ($server = "control.projectzenonline.com") {


  exec { 'apt-update':
    command     => "/usr/bin/apt-get update",
    refreshonly => true,
  }

  file { "zabbix.list":
    path    => "/etc/apt/sources.list.d/zabbix.list",
    content => "deb http://control.projectzenonline.com/apt/ precise contrib\n",
    owner   => root,
    group   => root,
    mode    => 0644,
    notify  => Exec['apt-update'],
   }

   package { "zabbix-agent":
    ensure  => installed,
    require => Exec['apt-update'],
   }

   file { 'zabbix_agentd.conf':
    path    => '/usr/local/etc/zabbix_agentd.conf',
    ensure  => file,
    require => Package['zabbix-agent'],
    content => template("zabbix_agent/zabbix_agentd.conf.erb"),
   }

   file { 'init script':
    path    => '/etc/init/zabbix_agent.conf',
    source  => 'puppet:///modules/zabbix_agent/zabbix-agent.conf',
    ensure  => file,
    require => Package['zabbix-agent'],
   }
}
