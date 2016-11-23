require "rails_helper"

RSpec.describe Api::V1::QuestionsController, :type => :controller do
  describe "GET index" do
    it "response successfully with HTTP 200 status code" do
      # setup
      content = "This is the content"
      answer = "This is an answer"
      Question.create content: content, answer: answer


      # act
      get :index

      # verify
      result_array = JSON(response.body)
      first_item = result_array.first

      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(result_array.count).to eq(1)
      expect(first_item["content"]).to eq(content)
      expect(first_item["answer"]).to eq(answer)

      # teardown handled by rspec
    end
  end
end