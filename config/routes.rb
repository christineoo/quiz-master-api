Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :questions
      get '/start_quiz' => 'questions#start_quiz'
      get '/next_question/:id' => 'questions#next_question'
      post '/check_answer/:id' => 'questions#check_answer'
    end
  end
end
