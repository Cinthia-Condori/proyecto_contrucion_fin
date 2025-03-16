Rails.application.routes.draw do
  resources :productos

    #para que podamos estruccturar el codigo como si fuerean carpetas
  namespace :authentication, path: '', as:'' do
    resources :users, only: [:new, :create],path: '/register', path_names: {new: '/'}
    resources :sessions, only: [:new, :create, :destroy],path: '/login', path_names: {new: '/'}
  end

  resources :carritos, only: [:index, :create, :destroy], param: :producto_id
  resources :favorites, only: [:index, :create, :destroy], param: :producto_id
  resources :users, only: :show, path: '/user', param: :username
  resources :cargos, only: [:index, :new, :create]
  #resources :tallas, except: :show
  resources :tallas, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :categories, except: :show
  # Ruta raíz
  root to: 'productos#index'
  resources :productos, only: [:index, :show, :new, :create] # Agrega `:new` y `:create`
  resources :productitos, only: [] do
    collection do
      get 'index1'
      
      post 'send_to_queue'
      Rails.logger.debug "Categorías obtenidas: #{@categories.inspect}" # 👈 Agrega esta línea
      end
    end

  # Rutas para VentasOnlineController
  get 'ventas_online', to: 'ventas_online#index'
  post 'send_to_queue_ventas_online', to: 'ventas_online#send_to_queue'
  

  
    resources :productos, except: [:destroy]

    resources :productitos do
      collection do
        get 'mensajes', to: 'productitos#mensajes'
        # get 'productitos/mensajes', to: 'productitos#mensajes'

      end
    end
    
    # get 'productitos/mensajes', to: 'productitos#mensajes', as: 'mensajes'
    get 'productitos/mensajes', to: 'productitos#mensajes', as: 'productitos_mensajes'


  


end
