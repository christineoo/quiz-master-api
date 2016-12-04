Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      get '/questions' => 'questions#index'
      get '/questions/:id' => 'questions#show'
      post '/questions' => 'questions#create'
      put '/questions/:id' => 'questions#update'
      delete 'questions/:id' => 'questions#destroy'
      get '/start_quiz' => 'questions#start_quiz'
      post '/check_answer/:id' => 'questions#check_answer'
    end
  end
end
