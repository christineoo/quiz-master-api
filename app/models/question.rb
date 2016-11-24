class Question < ActiveRecord::Base

  def next
    Question.where("id > ?", id).first
  end

  def check_answer?(entered_answer)
    #substitute any numbers entered into words and vice versa.
    inputAnswer = entered_answer.gsub(/\d+/) { |num| num.to_i.humanize }
    actualAnswer = Question.find(id).answer.gsub(/\d+/) { |num| num.to_i.humanize }

    #convert input and actual answer to lowercase and remove whitespaces
    #Example:
    #answer = "    This is    an answer       "
    #strip = answer.strip returns "This is    an answer"
    #squeeze = answer.squeeze(' ') returns " This is an answer "
    #answer.downcase.strip.squeeze(' ') returns "this is an answer"
    actualAnswer.downcase.strip.squeeze(' ') == inputAnswer.downcase.strip.squeeze(' ')
  end

end
