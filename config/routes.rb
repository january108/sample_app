Rails.application.routes.draw do
#  get 'static_pages/home'
#  get 'static_pages/help'
#  get 'static_pages/about'
#  get 'static_pages/contact'
  
  get '/home', to:'static_pages#home'
  get '/help', to:'static_pages#help'
  get '/about', to:'static_pages#about'
  get '/contact', to:'static_pages#contact'
  get '/signup', to:'users#new'

#  get '/home', to: redirect('/static_pages/home')
#  get '/help', to: redirect('/static_pages/help')
#  get '/about', to: redirect('/static_pages/about')
#  get '/contact', to: redirect('/static_pages/contact')

  root 'static_pages#home'
end
