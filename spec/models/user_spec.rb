# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
include AuthenticatedTestHelper

@@next_user_login = 11

describe User do
  fixtures :users

  before :all do
    User.destroy_all
  end

  describe 'being created' do
    before do
      @user = nil
      @creating_user = lambda do
        @user = create_user
        fail "#{@user.errors.full_messages.to_sentence}" if @user.new_record?
      end
    end

    it 'increments User#count' do
      @creating_user.should change(User, :count).by(1)
    end

  end

  #
  # Validations
  #

  describe 'email' do
    it 'should be required' do
      lambda do
        u = create_user(:email => nil)
        u.errors_on(:email).should_not be_empty
      end.should_not change(User, :count)
    end

    describe 'should be allowed:' do
      ['foo@berkeley.edu', 'foo@newskool-tld.lbl.gov', 'foo@calmail.berkeley.edu', 'foo@cory.eecs.berkeley.edu'
      ].each do |email_str|
        it "'#{email_str}'" do
          lambda do
            u = create_user(:email => email_str)
            u.errors_on(:email).should     be_empty
          end
        end
      end
    end

    describe 'should be disallowed:' do
      ['!!@nobadchars.com', 'foo@no-rep-dots..com', 'failberkeley.edu',
        'my@badberkeleyderp', 'foo@foilblgov',
           'foo@toolongtld.abcdefg',
       'Iñtërnâtiônàlizætiøn@hasnt.happened.to.email', 'need.domain.and.tld@de',
       "tab\t", "newline\n",
       'r@.wk', '1234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890-234567890@gmail2.com',
       # these are technically allowed but not seen in practice:
       'uucp!addr@gmail.com', 'semicolon;@gmail.com', 'quote"@gmail.com', 'backtick`@gmail.com', 'space @gmail.com', 'bracket<@gmail.com', 'bracket>@gmail.com'
      ].each do |email_str|
        it "'#{email_str}'" do
          lambda do
            u = create_user(:email => email_str)
            u.errors_on(:email).should_not be_empty
          end.should_not change(User, :count)
        end
      end
    end
  end # email

  describe 'name' do
    describe 'should be allowed:' do
      ['Andrew Andrews',
        'Jane Doe',
      ].each do |name_str|
        it "'#{name_str}'" do
          lambda do
            u = create_user(:name => name_str,
                              :email => "valid@email.com",
                              :login => 9876)
            u.errors_on(:name).should     be_empty
          end.should change(User, :count).by(1)
        end
      end
    end
    describe 'should be disallowed' do
      ["tab\t", "newline\n",
       '1234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_234567890_',
       ].each do |name_str|
        it "'#{name_str}'" do
          lambda do
            u = create_user(:name => name_str)
            u.errors_on(:name).should_not be_empty
          end.should_not change(User, :count)
        end
      end
    end
  end # name

  describe 'type' do
    describe 'undergrad' do
      pending
    end

    describe 'grad' do
      pending
    end

    describe 'faculty' do
      pending
    end

    describe 'admin' do
      pending
    end

    describe 'outside valid range' do
      it 'should be rejected' do
        [User::Types::All.min - 1, User::Types::All.max + 1].each do |utype|
          u = create_user(:save => false, :user_type => utype)
          u.user_type.should == utype
          u.errors_on(:user_type).should_not be_empty and u.should_not be_valid
        end
      end
    end

  end # user type

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
    record = User.new
    {
      :name => 'quire',
      :email => "quire#{@@next_user_login}@berkeley.edu",
      :login => @@next_user_login,
      :user_type => User::Types::Undergrad
    }.merge(options).each_pair do |attr,val|
      record[attr] = val
    end
    record.save if record.valid? && options[:save] != false
    @@next_user_login += 1
    record
  end
end

