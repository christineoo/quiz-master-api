class Api::V1::QuestionsController < ApplicationController

    def index
        render json: Question.all
    end

end