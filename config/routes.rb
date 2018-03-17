Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'translate#index'
  post 'translating_nmt', to: 'translate#translate_nmt'
  post 'translating_smt', to: 'translate#translate_smt'
  post 'translating',     to: 'translate#translate'
  post 'clearing',        to: 'translate#clear'
  post 'marking',         to: 'translate#mark'
end
