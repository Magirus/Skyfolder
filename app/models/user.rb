# encoding: utf-8
class User < ActiveRecord::Base

    acts_as_authentic do |config|
      config.crypto_provider = Authlogic::CryptoProviders::MD5
      config.logged_in_timeout = 240.minutes
      config.validate_login_field = false
      config.validate_password_field = false
      config.validate_email_field = false
    end

    validates :login, :presence => {:message => "не має бути пустим"},
        :uniqueness => {:message => "вже є користувач з таким логіном"},
              :length => {:minimum   => 3,
                      :maximum   => 20,
                      :too_short => "має бути на менше %{count} символів",
                      :too_long  => "має бути не більше %{count} символів" }
    validates :password, :presence => {:message => "не має бути пустим"},
        :confirmation => {:message => "не співпадає"},
              :length => {:minimum   => 3,
                                  :maximum   => 30,
                                  :too_short => "має бути на менше %{count} символів",
                                  :too_long  => "має бути не більше %{count} символів" }


    validates :email, :presence => {:message => "не має бути пустим"},
              :uniqueness => {:message => "вже є користувач з таким емейлом"},
              :format => {
                  :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
                  :message => "не корректний"}

end

