Rails.application.routes.draw do
  root to: "home#top"
  get 'top' => 'home#top'
  get 'contract' => "home#contract"
  get 'contract_new' => "home#contract_new"
  get 'contract_list' => "home#contract_list"
  get 'payback_new' => "home#payback_new"
  get 'payback_agree' => "home#payback_agree"
  get 'friend_new' => "home#friend_new"
  get 'friend' => "home#friend"
  get 'friend_list' => "home#friend_list"
  post "friends" => "home#addFriend"
  post "payments" => "home#createPayment"
  post "contracts" => "home#createContract"
  post "agreePayment" => "home#agreePayment"
  post "disagreePayment" => "home#disagreePayment"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
