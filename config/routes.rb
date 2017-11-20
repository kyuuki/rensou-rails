# -*- coding: utf-8 -*-
Rails.application.routes.draw do
  # iOS 版 API に合わせるためちょっといびつ
  # rensous 系が被っているので、管理画面より前に置く必要がある
  post 'user' => 'users#create'
  put 'user' => 'users#update'  # 通知のために準備

  get 'rensou' => 'rensous#latest'
  post 'rensou' => 'rensous#create'

  post 'rensous/:id/like' => 'rensous#like'
  delete 'rensous/:id/like' => 'rensous#dislike'

  get 'rensous/ranking' => 'rensous#ranking'

  # 管理画面
  root to: 'rensous#index'
  resources :apps
  resources :users
  resources :rensous

  # 今後、管理画面系はこちらに移行していく
  #namespace 'admin' do  # admin ディレクトリを作ったらこっちに移行
  scope 'admin' do
    resources :rensous do
      member do
        patch 'like', to: 'rensous#admin_like'  # コントローラも将来的に別に作る
      end
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
