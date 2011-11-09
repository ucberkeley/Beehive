require File.dirname(__FILE__) + '/../spec_helper'

#
# A test controller with and without access controls
#
class AccessControlTestController < ApplicationController
  before_filter :rm_login_required, :only => :login_is_required
  def login_is_required
    respond_to do |format|
      @foo = { 'success' => params[:format]||'no fmt given'}
      format.html do render :text => "success"             end
      format.xml  do render :xml  => @foo, :status => :ok  end
      format.json do render :json => @foo, :status => :ok  end
    end
  end
  def login_not_required
    respond_to do |format|
      @foo = { 'success' => params[:format]||'no fmt given'}
      format.html do render :text => "success"             end
      format.xml  do render :xml  => @foo, :status => :ok  end
      format.json do render :json => @foo, :status => :ok  end
    end
  end
end

#
# Access Control
#

ACCESS_CONTROL_FORMATS = [
  ['',     "success"],
  ['xml',  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<hash>\n  <success>xml</success>\n</hash>\n"],
  ['json', "{\"success\":\"json\"}"],]
ACCESS_CONTROL_AM_I_LOGGED_IN = [
  [:i_am_logged_in,     :quentin],
  [:i_am_not_logged_in, nil],]
ACCESS_CONTROL_IS_LOGIN_REQD = [
  :login_not_required,
  :login_is_required,]

describe AccessControlTestController do
  fixtures        :users
  before do
#    TODO this breaks everything
#    Rails.application.routes.draw do |map|
#      match '/login_is_required'  => 'access_control_test#login_is_required'
#      match '/login_not_required' => 'access_control_test#login_not_required'
#    end
  end

  ACCESS_CONTROL_FORMATS.each do |format, success_text|
    ACCESS_CONTROL_AM_I_LOGGED_IN.each do |logged_in_status, user_login|
      ACCESS_CONTROL_IS_LOGIN_REQD.each do |login_reqd_status|
        describe "requesting #{format.blank? ? 'html' : format}; #{logged_in_status.to_s.humanize} and #{login_reqd_status.to_s.humanize}" do
          before do
            logout
            if user_login.present?
              @user = users(user_login)
              login_user(@user)
            end
            get login_reqd_status.to_s, :format => format
          end

          if ((login_reqd_status == :login_not_required) ||
              (login_reqd_status == :login_is_required && logged_in_status == :i_am_logged_in))
            it "succeeds" do
              #response.should have_text(success_text)
              #response.code.to_s.should == '200'
            end

          elsif (login_reqd_status == :login_is_required && logged_in_status == :i_am_not_logged_in)
            if ['html', ''].include? format
              it "redirects me to the log in page" do
                response.should redirect_to('/session/new')
              end
            else
              it "returns 'Access denied' and a 406 (Access Denied) status code" do
                response.code.to_s.should == '401'
              end
            end

          else
            warn "Oops no case for #{format} and #{logged_in_status.to_s.humanize} and #{login_reqd_status.to_s.humanize}"
          end
        end # describe

      end
    end
  end # cases

end
