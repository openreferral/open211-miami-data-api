require 'rails_helper'

RSpec.describe ApiAccount, type: :model do
  it "generates api_key when created" do
    api_account = ApiAccount.new(api_key: nil)
    api_account.save
    expect(api_account.api_key).not_to be_nil
  end
end
