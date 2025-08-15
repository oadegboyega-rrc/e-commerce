require 'rails_helper'

RSpec.describe "Checkouts", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/checkout/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /address" do
    it "returns http success" do
      get "/checkout/address"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /review" do
    it "returns http success" do
      get "/checkout/review"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /complete" do
    it "returns http success" do
      get "/checkout/complete"
      expect(response).to have_http_status(:success)
    end
  end

end
