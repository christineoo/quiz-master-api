class Question < ActiveRecord::Base

  def next_id
    next_question = Question.where("id > ?", id).first
    next_question.nil? ? nil: next_question.id
  end

  def check_answer?(entered_answer)
    #substitute any numbers entered into words and vice versa.
    input_answer = entered_answer.gsub(/\d+/) { |num| num.to_i.humanize }
    actual_answer = Question.find(id).answer.gsub(/\d+/) { |num| num.to_i.humanize }

    #convert input and actual answer to lowercase and remove whitespaces
    #Example:
    #answer = "    This is    an answer       "
    #strip = answer.strip returns "This is    an answer"
    #squeeze = answer.squeeze(' ') returns " This is an answer "
    #answer.downcase.strip.squeeze(' ') returns "this is an answer"
    actual_answer.downcase.strip.squeeze(' ') == input_answer.downcase.strip.squeeze(' ')
  end

end
