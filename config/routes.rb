PhishingFramework::Application.routes.draw do
	devise_for :admins

	# image tracking routes.
	get '/reports/image/:uid.png' => 'reports#image'

	# only allow emails to be send from POST request
	post '/email/preview_email/:id' => 'email#preview', as: 'preview_email'
	post '/email/test_email/:id' =>    'email#test', as: 'test_email'
	post '/email/launch_email/:id' =>  'email#launch', as: 'launch'

	# only allow deletion from POST requests
	get '/campaigns/delete_smtp_entry/:id' => 'campaigns#list'

	get "reports/list"
	get "reports/show"
	get "reports/delete"

	resources :campaigns do
		collection do
			get 'options'
			get 'home'
			get 'list'
			get 'aboutus'
			delete 'destroy'
		end
		member do
			post 'update_settings'
			post 'clear_victims'
		end
	end

	resources :blasts, only: [:show], shallow: true

	resources :templates do
		collection do
			get 'list'
			get 'restore'
			get 'edit_email'
			get 'update_attachment'
			delete 'destroy'
		end
	end

	resources :reports do
		collection do
			get 'list'
			get 'stats'
			get 'results'
			get 'download_logs'
			get 'download_stats'
			get 'apache_logs'
			get 'smtp'
			get 'passwords'
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

	mount LetterOpenerWeb::Engine, at: 'letter_opener'

	match ':controller(/:action(/:id))(.:format)'
end

