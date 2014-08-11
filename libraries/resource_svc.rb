#
# Cookbook Name:: svc
# Resource:: svc
#
# Author:: John Ko <git@johnko.ca>
# Copyright 2014, John Ko
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class Chef::Resource::Svc < Chef::Resource::Service

  def initialize(name, run_context=nil)
    super
    @resource_name = :svc
    @service_name = name
    @enabled = nil
    @running = nil
    @parameters = nil
    @pattern = service_name
    @start_command = nil
    @stop_command = nil
    @status_command = nil
    @restart_command = nil
    @reload_command = nil
    @init_command = nil
    @priority = nil
    @timeout = nil
    @action = "nothing"
    @supports = { :restart => false, :reload => false, :status => false }
    @allowed_actions.push(:enable, :disable, :start, :stop, :restart, :reload)

    if(run_context && run_context.node[:init_package] == "systemd")
      @provider = Chef::Provider::Service::Systemd
    end
  end
end
