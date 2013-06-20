Spree::Core::Engine.routes.prepend do
  # Add your extension routes here
  resources :orders do
    resource :checkout, :controller => 'checkout' do
      member do
        get :skrill_cancel
        get :skrill_return
        get :paytrail_cancel
        get :paytrail_return
      end
    end
  end

  match '/paytrail' => 'paytrail_status#update', :via => :get, :as => :paytrail_status_update
  match '/skrill' => 'skrill_status#update', :via => :post, :as => :skrill_status_update
end
