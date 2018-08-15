Rails.application.routes.draw do
  get 'top' => 'home#top'
  get 'contract' => "home#contract"
  get 'contract_new' => "home#contract_new"
  get 'contract_list' => "home#contract_list"
  get 'payback_new' => "home#payback_new"
  get 'payback_complete' => "home#payback_complete"
  get 'friend_new' => "home#friend_new"
  get 'friend_list' => "home#friend_list"
  post "payments" => "home#createPayment"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
