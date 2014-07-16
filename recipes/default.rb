#
# Cookbook Name:: sudo
# Recipe:: default
#
# Copyright 2008-2011, Opscode, Inc.
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

package "sudo" do
  action platform?("freebsd") ? :install : :upgrade
end

template "/etc/sudoers.d/chef-sudoers" do
  path "/usr/local/etc/sudoers" if platform?("freebsd")
  source "sudoers-chef.erb"
  mode 0440
  owner "root"
  group platform?("freebsd") ? "wheel" : "root"
  variables(
    :sudoers_groups => node['authorization']['sudo']['groups'],
    :sudoers_users => node['authorization']['sudo']['users'],
    :passwordless => node['authorization']['sudo']['passwordless']
  )
end

template "/etc/sudo.conf" do
  source "sudo.erb"
  mode 0644
  owner "root"
  group platform?("freebsd") ? "wheel" : "root"
end

template "/etc/sudoers" do
  path "/usr/local/etc/sudoers" if platform?("freebsd")
  source "sudoers.erb"
  mode 0440
  owner "root"
  group platform?("freebsd") ? "wheel" : "root"
end

