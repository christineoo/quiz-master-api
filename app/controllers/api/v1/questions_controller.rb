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
    new_question = Question.create(question_params)
    if new_question.valid?
      render json: new_question
    else
      render :json => {:errors => new_question.errors.full_messages}, :status => 400
    end
  end

  def update
    question = Question.find(params[:id])
    update_question = question.update(question_params)
    if update_question
      render json: question
    else
      render :json => {:errors => question.errors.full_messages}, :status => 400
    end
  end

  def destroy
    question = Question.find(params[:id])
    question.destroy
    render json: {result: "ok", message: "Question with id #{params[:id]} has been deleted."}
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

    is_correct = question.check_answer?(params[:inputAnswer])
    if is_correct
      render json: {result: "ok", expected: question.answer, next_question_id: question.next_id}
    else
      render json: {result: "error", expected: question.answer, next_question_id: question.next_id}
    end
  end

  private

  def question_params
    params.require(:question).permit!
  end

end