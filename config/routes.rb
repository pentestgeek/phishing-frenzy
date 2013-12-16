PhishingFramework::Application.routes.draw do
	devise_for :admins

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
