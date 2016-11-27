class Api::V1::QuestionsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        render json: Question.all
    end

    def show
      question = Question.find(params[:id])
      render json: {id: question.id, content: question.content}
    end

    def create
        render json: Question.create(question_params)
    end

    def update
        question = Question.find(params[:id])
        question.update(question_params)
        render json: question
    end

    def destroy
        question = Question.find(params[:id])
        question.destroy
		render json: {status: "ok", message: "Question with id #{params[:id]} has been deleted."}
    end

    def start_quiz
        if Question.exists?
            first_question = Question.first
            render json: {id: first_question.id, content: first_question.content}
        else
          render json: {}
        end
    end

    def check_answer
        question = Question.find(params[:id])
        next_question_id = !question.next.nil? ? question.next.id : nil

        isCorrect = question.check_answer?(params[:inputAnswer])

        if isCorrect
          render json: {result: "ok", expected: question.answer, next_question_id: next_question_id}
        else
          render json: {result: "error", expected: question.answer, next_question_id: next_question_id}
        end
    end

    private

    def question_params
      params.require(:question).permit!
    end

end