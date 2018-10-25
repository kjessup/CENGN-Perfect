Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'empty', to: 'application#empty'
  get '1024', to: 'application#s1024'
  get '2048', to: 'application#s2048'
  get '4096', to: 'application#s4096'
  get '8192', to: 'application#s8192'
end
