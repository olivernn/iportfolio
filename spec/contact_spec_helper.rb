require File.dirname(__FILE__) + '/spec_helper.rb'

module ContactSpecHelper
  private

    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/mailers/user_mailer/#{action}")
    end
end