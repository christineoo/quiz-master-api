class Api::V1::QuestionsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        render json: Question.all
    end

    def create
        render json: Question.create(question_params)
    end

    def update
        question = Question.find(params[:id])
        question.update(question_params)
        render json: {status: "ok", message: "Question with id #{params[:id]} has been updated."}
    end

    def destroy
        question = Question.find(params[:id])
        question.destroy
		render json: {status: "ok", message: "Question with id #{params[:id]} has been deleted."}
    end

    def start_quiz
        first_question = Question.exists?
        if first_question
          render json: {id: first_question.id, content: first_question.content}
        else
          render json: {}
        end
    end

    def check_answer
        answer = Question.find(params[:id]).answer
        if(answer == params[:inputAnswer])
            render json: {status: "ok"}
        else
            render json: {status: "error", expected: answer}
        end
    end

    private

    def question_params
      params.require(:question).permit!
    end

end