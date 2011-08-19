# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
include AuthenticatedTestHelper

@@next_user_login = 11

describe User do
  fixtures :users

  describe 'being created' do
    before do
      @user = nil
      @creating_user = lambda do
        @user = create_user
        violated "#{@user.errors.full_messages.to_sentence}" if @user.new_record?
      end
    end

    it 'increments User#count' do
      @creating_user.should change(User, :count).by(1)
    end

  end

  #
  # Validations
  #

  it 'requires email' do
    lambda do
      u = create_user(:email => nil)
      u.errors[:email].should_not be_empty
    end.should_not change(User, :count)
  end

  describe 'allows legitimate emails:' do
    ['foo@berkeley.edu', 'foo@newskool-tld.lbl.gov', 'foo@calmail.berkeley.edu', 'foo@cory.eecs.berkeley.edu'
    ].each do |email_str|
      it "'#{email_str}'" do
        lambda do
          u = create_user(:email => email_str)
          u.errors[:email].should     be_empty
        end
      end
    end
  end
  describe 'disallows illegitimate emails' do
    ['!!@nobadchars.com', 'foo@no-rep-dots..com', 'failberkeley.edu',
      'my@badberkeleyderp', 'foo@foilblgov', 
	 'foo@toolongtld.abcdefg',
     'Iñtërnâtiônàlizætiøn@hasnt.happened.to.email', 'need.domain.and.tld@de',
     "tab\t", "newline\n",
     'r@.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail2.com',
     # these are technically allowed but not seen in practice:
     'uucp!addr@gmail.com', 'semicolon;@gmail.com', 'quote"@gmail.com', 'tick\'@gmail.com', 'backtick`@gmail.com', 'space @gmail.com', 'bracket<@gmail.com', 'bracket>@gmail.com'
    ].each do |email_str|
      it "'#{email_str}'" do
        lambda do
          u = create_user(:email => email_str)
          u.errors[:email].should_not be_empty
        end.should_not change(User, :count)
      end
    end
  end

  describe 'allows legitimate names:' do
    ['Andrew Andrews',
      'Jane Doe',
    ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = create_user(:name => name_str,
                            :email => "valid@email.com",
                            :login => 9876)
          u.errors[:name].should     be_empty
        end.should change(User, :count).by(1)
      end
    end
  end
  describe "disallows illegitimate names" do
    ["tab\t", "newline\n",
     '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_',
     ].each do |name_str|
      it "'#{name_str}'" do
        lambda do
          u = create_user(:name => name_str)
          u.errors[:name].should_not be_empty
        end.should_not change(User, :count)
      end
    end
  end

  #
  # Authentication
  #

# it 'remembers me until one week' do
#   time = 1.week.from_now.utc
#   users(:quentin).remember_me_until time
#   users(:quentin).remember_token.should_not be_nil
#   users(:quentin).remember_token_expires_at.should_not be_nil
#   users(:quentin).remember_token_expires_at.should == time
# end

# it 'remembers me default two weeks' do
#   before = 2.weeks.from_now.utc
#   users(:quentin).remember_me
#   after = 2.weeks.from_now.utc
#   users(:quentin).remember_token.should_not be_nil
#   users(:quentin).remember_token_expires_at.should_not be_nil
#   users(:quentin).remember_token_expires_at.between?(before, after).should be_true
# end

protected
  def create_user(options = {})
    record = User.new({ :name => 'quire', :email => 'quire' +
      @@next_user_login.to_s + '@berkeley.edu',
      :login => @@next_user_login, :user_type => 0}.merge(options))
    record.save
    @@next_user_login += 1
    record
  end
end
