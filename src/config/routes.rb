Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   root 'dashboard#index'
   get 'greet' => 'dashboard#greet' 
   post 'access-keys' => 'dashboard#save_access_keys'
   get 'access-keys' => 'dashboard#get_access_keys'  

   get 'stacks' => 'dashboard#get_stacks'  
end
