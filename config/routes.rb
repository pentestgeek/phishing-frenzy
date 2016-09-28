PhishingFramework::Application.routes.draw do

	get 'system_logs' => 'system_logs#show'

	devise_for :admins



	# only allow emails to be sent from POST request
	post '/email/preview_email/:id' => 'email#preview', as: 'preview_email'
	post '/email/test_email/:id' =>    'email#test', as: 'test_email'
	post '/email/launch_email/:id' =>  'email#launch', as: 'launch'

	# only allow deletion from POST requests
	get '/campaigns/delete_smtp_entry/:id' => 'campaigns#list'

	get "reports/list"
	get "reports/show"
	get "reports/delete"

	get "tools/emails" => "tools#emails"
	get "tools/show_emails/:id" => "tools#show_emails", as: 'show_emails'
	post "tools/enumerate_emails" => "tools#enumerate_emails"
	delete "tools/emails/:id" => "tools#destroy_email", as: 'destroy_email'
	get "tools/download_emails/:id" => "tools#download_emails", as: "download_emails"
	get "tools/import_emails" => "tools#import_emails"

	resources :campaigns do
		collection do
			get 'options'
			get 'home'
			get 'list'
			get 'aboutus'
			get 'victims'
			get 'activity'
			delete 'destroy'
		end
		member do
			post 'clear_victims'
		end
	end

  # Custom Route for viewing Campaigns template files directly...
  get 'site_delivery/view/:id/:filename', to: 'site_delivery#view', constraints: { filename: /[^\/]+/ }
  post 'site_delivery/view/:id/:filename', to: 'site_delivery#view', constraints: { filename: /[^\/]+/ }

  # image tracking routes.
  get 'site_delivery/tracking_image/:id/:uid.png' => 'site_delivery#tracking_image'


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
			delete 'clear'
		end
		member do
			get 'download_excel'
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

	resources :clones do
		member do
			get 'download'
			get 'preview'
		end
	end

	resources :tools

	root :to => 'campaigns#home'

	match 'access', :to => 'access#menu', as: 'access', via: :get

	require 'sidekiq/web'

	authenticate :admin do
		mount Sidekiq::Web => '/sidekiq'
		mount LetterOpenerWeb::Engine, at: 'letter_opener'
	end

	require 'sidekiq/api'
	match "queue-status" => proc { [200, {"Content-Type" => "text/plain"}, [Sidekiq::Queue.new.size < 100 ? "OK" : "UHOH" ]] }, via: :get

	match ':controller(/:action(/:id))(.:format)', via: [:get, :post]
end

