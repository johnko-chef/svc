#
# Cookbook Name:: svc
# Provider:: svc
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

class Chef::Provider::Svc < Chef::Provider::Service::Freebsd

  def load_current_resource
    @current_resource = Chef::Resource::Service.new(@new_resource.name)
    @current_resource.service_name(@new_resource.service_name)
    @rcd_script_found = true
    @enabled_state_found = false
    # Determine if we're talking about /etc/rc.d or /usr/local/etc/rc.d
    if ::File.exists?("/etc/rc.d/#{current_resource.service_name}")
      @init_command = "/etc/rc.d/#{current_resource.service_name}"
    elsif ::File.exists?("/usr/local/etc/rc.d/#{current_resource.service_name}")
      @init_command = "/usr/local/etc/rc.d/#{current_resource.service_name}"
    else
      @rcd_script_found = false
      return
    end
    Chef::Log.debug("#{@current_resource} found at #{@init_command}")
    determine_current_status!
    # Default to disabled if the service doesn't currently exist
    # at all
    #var_name = service_enable_variable_name
    checkcmd = 'service -e '
    check = Mixlib::ShellOut.new(checkcmd, :cwd => '/tmp')
    check.run_command
    Chef::Log.debug('sysrc: check.stdout: '+check.stdout)
    check.stdout.each_line do |line|
      case line
      when /#{@init_command}/
        @enabled_state_found = true
        @current_resource.enabled true
      end
    end
    unless @current_resource.enabled
      Chef::Log.debug("#{@new_resource.name} enable/disable state not defined")
      @current_resource.enabled false
    end

    @current_resource
  end


  def start_service
    if @new_resource.start_command
      super
    else
      shell_out!("#{@init_command} start")
    end
  end

  def stop_service
    if @new_resource.stop_command
      super
    else
      shell_out!("#{@init_command} stop")
    end
  end

  def restart_service
    if @new_resource.restart_command

      super
    elsif @new_resource.supports[:restart]
      shell_out!("#{@init_command} restart")
    else
      stop_service
      sleep 1
      start_service
    end
  end

  def set_service_enable(value)
    command = 'sysrc '
    command += '-f /etc/rc.conf '
    command += "#{service_enable_variable_name}" + '="' + value + '" '
    Chef::Log.debug('svc: command: '+command)
    execute command do
      #not_if checkcmd
    end
  end

end
