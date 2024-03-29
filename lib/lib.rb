#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'yaml'
require 'time'
require 'uri'
require File.dirname(__FILE__)+'/weibo'

class VboTest
  def initialize(save_file='/tmp/vbo-test.yml')
    @save_file = save_file
    @vbo = Vbo::Weibo.new
    @vbo.set_app_config '1211688234', 'de8316eba41cefcc86b768417c96de3e', 'http://tools.lunae.cc/vbo/callback.php'
  end

  def set_access_token
    if File.exists?(@save_file)
      access_token = YAML.load_file(@save_file)
      time_now = Time.now.to_i
      #如果过期了返回false
      if access_token['expires_when'].to_i < time_now
        return false
      end
      @uid = access_token['uid']
      @vbo.set_access_token access_token
      true
    else
      false
    end
  end

  def get_access_token(access_code)
    @vbo.set_access_code access_code.to_s
    access_token = @vbo.get_access_token
    time_now = Time.now.to_i
    access_token['expires_when'] = time_now + access_token['expires_in'].to_i
    File.open @save_file, 'w' do |f|
      f.write access_token.to_yaml
    end
    access_token
  end

  def get_auth_url
    @vbo.get_authorize_url
  end

  def get_uid
    @uid
  end

  alias :uid :get_uid

  def get_public_timeline
    @vbo.get__statuses__public_timeline
  end

  def user_timeline(uid, screen_name=nil, count=30, page=1, base_app=0, feature=0)
    data = {'count'=>count, 'page'=>page, 'base_app'=>base_app, 'feature'=>feature}
    if uid.nil? && (not screen_name.nil?)
      odata = {'screen_name'=>screen_name}
    else
      odata = {'uid'=>uid}
    end
    data.merge! odata
    @vbo.get__statuses__user_timeline data
  end

  def home_timeline(count=30, page=1, base_app=0, feature=0)
    data = {'count'=>count, 'page'=>page, 'base_app'=>base_app, 'feature'=>feature}
    @vbo.get__statuses__home_timeline data
  end

  def statuses_update(status, anno=nil)
    data = {'status'=>status}
    if not anno.nil?
      data.push({'annotations'=>anno})
    end
    @vbo.post__statuses__update data
  end

  def statuses_repost(id, status=nil)
    data = {'id'=>id}
    data['status'] = status unless status.nil?
    @vbo.post__statuses__repost data
  end

  def statuses_destroy(id)
    data = {'id'=>id}
    @vbo.post__statuses__destroy data
  end

  def comments_create(id, comment)
    data = {'id'=>id, 'comment'=>comment}
    @vbo.post__comments__create data
  end

end

