require 'spec_helper'

describe AuthenticateController do

  describe "GET 'login'" do
    it "returns http success" do
      get 'login'
      response.should be_success
    end
  end

end
