PhishingFramework::Application.routes.draw do
	devise_for :admins

	# image tracking routes.
	get '/reports/image/:uid.png' => 'reports#image'

	# only allow emails to be send from POST request
	get '/email/send_email/:id' => 'campaigns#list'
	get '/email/launch_email/:id' => 'campaigns#list'

	# only allow deletion from POST requests
	get '/campaigns/delete_smtp_entry/:id' => 'campaigns#list'

	get "reports/list"
	get "reports/show"
	get "reports/delete"

	resources :campaigns do
		collection do
			get 'home'
			get 'list'
			get 'aboutus'
			delete 'destroy'
		end
		member do
			post 'update_settings'
		end
	end

	resources :templates do
		collection do
			get 'list'
			get 'restore'
			get 'edit_email'
			delete 'destroy'
		end
	end

	resources :reports do
		collection do
			get 'list'
			get 'stats'
			get 'results'
			post 'results'
		end
	end

	resources :admin do
		collection do
			get 'list'
			get 'global_settings'
			put 'update_global_settings'
		end
		member do
			get 'logins'
			post 'approve'
			post 'revoke'
			delete 'destroy'
		end
	end

	root :to => 'campaigns#home'

	match 'access', :to => 'access#menu', as: 'access'

  require 'sidekiq/web'

  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end

  require 'sidekiq/api'
  match "queue-status" => proc { [200, {"Content-Type" => "text/plain"}, [Sidekiq::Queue.new.size < 100 ? "OK" : "UHOH" ]] }

	# The priority is based upon order of creation:
	# first created -> highest priority.

	# Sample of regular route:
	#   match 'products/:id' => 'catalog#view'
	# Keep in mind you can assign values other than :controller and :action

	# Sample of named route:
	#   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
	# This route can be invoked with purchase_url(:id => product.id)

	# Sample resource route (maps HTTP verbs to controller actions automatically):
	#   resources :products

	# Sample resource route with options:
	#   resources :products do
	#     member do
	#       get 'short'
	#       post 'toggle'
	#     end
	#
	#     collection do
	#       get 'sold'
	#     end
	#   end

	# Sample resource route with sub-resources:
	#   resources :products do
	#     resources :comments, :sales
	#     resource :seller
	#   end

	# Sample resource route with more complex sub-resources
	#   resources :products do
	#     resources :comments
	#     resources :sales do
	#       get 'recent', :on => :collection
	#     end
	#   end

	# Sample resource route within a namespace:
	#   namespace :admin do
	#     # Directs /admin/products/* to Admin::ProductsController
	#     # (app/controllers/admin/products_controller.rb)
	#     resources :products
	#   end

	# You can have the root of your site routed with "root"
	# just remember to delete public/index.html.
	# root :to => 'welcome#index'

	# See how all your routes lay out with "rake routes"

	# This is a legacy wild controller route that's not recommended for RESTful applications.
	# Note: This route will make all actions in every controller accessible via GET requests.
	match ':controller(/:action(/:id))(.:format)'
end

