require 'spec_helper'

describe MongoidUser do
  
  before do
    @user = MongoidUser.new
  end
  
  subject {@user}
  
  it{ should respond_to(:user_name) }
  it{ should respond_to(:role_name) }
end