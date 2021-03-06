#
# Cookbook Name:: nginx_ssl_proxy
# Recipe:: default
#
# Copyright 2012, Coroutine LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "nginx::default"



defaults_ssl_listen = { "ssl_listen" => "443" }

# Create directory for Certs
directory "#{node[:nginx][:dir]}/#{node[:nginx][:ssldir]}" do
  mode 0755
  owner node[:nginx][:user]
  action :create
  recursive true
end

# Write the new nginx config file
template "#{node[:nginx][:dir]}/nginx.conf" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
    :ssl_server_declarations => node[:nginx][:servers]
  )
  notifies :reload, "service[nginx]"
end
