Rails.application.routes.draw do
  root to: "home#top"
  get 'top' => 'home#top'
  get 'contract' => "home#contract"
  get 'contract_new' => "home#contract_new"
  get 'contract_agree' => "home#contract_agree"
  get 'contract_complete' => "home#contract_complete"
  get 'contract_list' => "home#contract_list"
  post "contracts" => "home#createContract"
  post "payments" => "home#createPayment"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
