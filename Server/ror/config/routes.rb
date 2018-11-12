Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'empty', to: 'application#empty'
  get '2048', to: 'application#s2048'
  get '8192', to: 'application#s8192'
  get '32768', to: 'application#s32768'

  get 'getArgs2048', to: 'application#getArgs2048'
  post 'postArgs2048', to: 'application#postArgs2048'
  post 'postArgsMulti2048', to: 'application#postArgsMulti2048'
end
