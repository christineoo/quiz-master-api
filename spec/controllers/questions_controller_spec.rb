require "rails_helper"

RSpec.describe Api::V1::QuestionsController, :type => :controller do
  describe "GET #index" do
    it "response successfully with HTTP 200 status code" do
      # setup
      FactoryGirl.create_list(:question, 10)

      # act
      get :index

      # verify
      json = JSON(response.body)

      expect(response).to be_success
      expect(json.length).to eq(10)

      # teardown handled by rspec
    end
  end

  describe "GET #show/:id" do
    it "response with question with given id" do
      # setup
      question = FactoryGirl.create(:question)

      # act
      get :show, id: question.id

      # verify
      json = JSON(response.body)
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(json["content"]).to eq(question.content)
    end

  end

  describe "POST #create" do
    it 'response with the newly created question' do
      # setup
      question = FactoryGirl.create(:question)

      # act
      post :create, {:question => {:content => question.content, :answer => question.answer}}

      # verify
      json = JSON(response.body)
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(json["content"]).to eq(question.content)
      expect(json["answer"]).to eq(question.answer)

      # teardown handled by rspec
    end
  end

  describe "POST #create with empty content and answer params" do
    it 'response with the newly created question' do
      # act
      post :create, {:question => {:content => "", :answer => ""}}

      # verify
      json = JSON(response.body)
      expect(response).to have_http_status(400)
      expect(json["errors"]).to eq(["Content can't be blank", "Answer can't be blank"])

      # teardown handled by rspec
    end
  end

  describe "PUT #update/:id" do
    it 'should response with update successful message' do
      # setup
      question = FactoryGirl.create(:question)

      # act
      put :update, {:id => question.id, :question => {:content => "new content", :answer => "new answer"}}

      # verify
      json = JSON(response.body)
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(json["content"]).to eq("new content")
      expect(json["answer"]).to eq("new answer")

      # teardown handled by rspec
    end
  end

  describe "DELETE #destroy/:id" do
    it "should delete the question" do
      # setup
      questions = FactoryGirl.create_list(:question, 10)

      # act
      delete :destroy, id: questions[1].id

      # verify
      json = JSON(response.body)
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(Question.count).to eq(questions.count - 1)

      # teardown handled by rspec
    end
  end

  describe "GET #start_quiz" do
    it "should response with first question" do
      # setup
      FactoryGirl.create_list(:question, 5)

      # act
      get :start_quiz

      # verify
      json = JSON(response.body)
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(json["id"]).to eq(1)

      # teardown handled by rspec
    end

    it "should response empty json if no questions created yet" do
      # act
      get :start_quiz

      # verify
      json = JSON(response.body)
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(json).to eq({})
    end
  end

  describe "POST #check_answer" do
    it "should return correct response" do
      # setup
      id = 3
      FactoryGirl.create_list(:question, 5)
      question = Question.find(id)

      # act
      post :check_answer, {:id => question.id, :inputAnswer => "This is an answer"}

      # verify
      json = JSON(response.body)
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(json["result"]).to eq("ok")
      expect(json["expected"]).to eq("This is an answer")
      expect(json["next_question_id"]).to eq(id+1)
    end

    it "should return incorrect response" do
      # setup
      id = 3
      FactoryGirl.create_list(:question, 5)
      question = Question.find(id)

      # act
      post :check_answer, {:id => question.id, :inputAnswer => "This is not an answer"}

      # verify
      json = JSON(response.body)
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(json["result"]).to eq("error")
      expect(json["expected"]).to eq("This is an answer")
      expect(json["next_question_id"]).to eq(id+1)
    end
  end
end