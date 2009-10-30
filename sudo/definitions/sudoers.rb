#
# Cookbook Name:: sudo
# Definition: sudoers
#
# Copyright 2008, OpsCode, Inc.
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

define :sudoers, :rights => "ALL=(ALL) ALL" do
  begin
   r = resource(:template => "/etc/sudoers")
  rescue   
    r = template "/etc/sudoers" do
      cookbook "sudo"
      source "sudoers.erb"
      variables(
	:sudoers_users => [],
	:sudoers_groups => []
      )
    end
  end
  if params[:user]
    # set user sudoers array
    node[:authorization][:sudo][:users][params[:user]] = "#{params[:rights]}"
    users = node[:authorization][:sudo][:users].keys.map { |key| "#{key}\t#{node[:authorization][:sudo][:users][key]}"}
    r.variables[:sudoers_users] = users.sort
  elsif params[:group]
    # set group sudoers array
    node[:authorization][:sudo][:groups][params[:group]] = "#{params[:rights]}"
    groups = node[:authorization][:sudo][:groups].keys.map { |key| "%#{key}\t#{node[:authorization][:sudo][:groups][key]}" }
    r.variables[:sudoers_groups] = groups.sort
  end
end
