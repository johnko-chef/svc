Description
===========

Manages FreeBSD services

Requirements
============

Needs FreeBSD.

Why
===

Because on FreeBSD, the built-in chef lib uses `faststart,faststop,fastrestart`. I want to use `start/stop/restart`.
Also try using the command `service -e` to detect enabled services (this method has a known issue: ntpd doesn't detect as enabled).
Also try to set enabled via `sysrc`

Usage
=====

```ruby
depends "svc"

svc 'sshd' do
  service_name node['openssh']['service_name']
  supports value_for_platform(
    'freebsd' => { 'default' => [:restart, :reload, :status] }
  )
  action [ :enable, :start ]
end

```

License and Author
==================

Author:: John Ko <git@johnko.ca>
Copyright:: 2014, John Ko

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
