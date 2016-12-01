require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, :type => :model do

  describe "next" do
    it 'returns next question id based on the current question' do
      # setup
      FactoryGirl.create_list(:question, 10)
      id = 9
      question = Question.find(id)
      expect(question.next_id).to eq(id+1)
    end

  end

  describe "check_answer?" do
    it 'return true if answer is correct' do
      question = FactoryGirl.create(:question, content: "What is the result of 2+2?", answer: '4')
      expect(question.check_answer?('4')).to eq(true)
    end

    it 'return false if answer is incorrect' do
      question = FactoryGirl.create(:question, content: "What is the result of 2+2?", answer: '4')
      expect(question.check_answer?('6')).to eq(false)
    end

    it 'should detect number and words as a correct answer' do
      question = FactoryGirl.create(:question, content: "What is the result of 2+2?", answer: 'four')
      expect(question.check_answer?('4')).to eq(true)
    end

    it 'should ignore whitespaces from answer' do
      question = FactoryGirl.create(:question, content: "What is the result of 2+2?", answer: '  This is    4    ')
      expect(question.check_answer?('This     is four')).to eq(true)
    end

    it 'should be case insensitive' do
      question = FactoryGirl.create(:question, content: "What is the result of 2+2?", answer: 'FoUr')
      expect(question.check_answer?('fOuR')).to eq(true)
    end
  end
end