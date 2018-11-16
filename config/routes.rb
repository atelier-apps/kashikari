Rails.application.routes.draw do

  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }
  root to: "home#top"
  get 'pages/index'
  get 'pages/show'
  get 'top' => 'home#top'
  get 'maintenance' => 'home#maintenance'
  get 'contract' => "home#contract"
  get 'contract_new' => "home#contract_new"
  get 'c' => "home#contract_agree"
  get 'contract_complete' => "home#contract_complete"
  get 'contract_list' => "home#contract_list"
  post "contracts" => "home#createContract"
  post "deleteContract" => "home#deleteContract"
  post "payments" => "home#createPayment"
  post "createFriend" => "home#createFriend"
  post "editFriend" => "home#editFriend"
  post "sendAgreement" => "home#sendAgreement"
  post "goBackList" => "home#goBackList"
  get 'friend_list' => "home#friend_list"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
