# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.

require 'resque/server'

Rails.application.routes.draw do
  # Devise routes
  # We don't skip anything because registration and recovery
  # are disabled in devise (see the migration and the user model)
  devise_for :users

  # Authenticated routes
  authenticate :user do
    mount Resque::Server, at: '/jobs'
    mount DpnSwaggerEngine::Engine, at: '/api-docs'
  end

  scope "/api-v#{VERSION}" do
    resources :nodes, only: [:index, :show, :create, :update, :destroy], path: :node, param: :namespace
    put "/node/:namespace/auth_credential", controller: :nodes, action: :update_auth_credential
    resources :bags, only: [:index, :show, :create, :update, :destroy], path: :bag, param: :uuid
    resources :replication_transfers, only: [:index, :show, :create, :update, :destroy], path: :replicate, param: :replication_id
    resources :restore_transfers, only: [:index, :show, :create, :update, :destroy], path: :restore, param: :restore_id
    resources :members, only: [:index, :show, :create, :update, :destroy], path: :member, param: :member_id
    get "/member/:member/bags", controller: :bags, action: :index

    get   "/digest",                      controller: :message_digests, action: :index
    get   "/bag/:bag/digest",             controller: :message_digests, action: :index
    post  "/bag/:bag/digest",             controller: :message_digests, action: :create
    get   "/bag/:bag/digest/:algorithm",  controller: :message_digests, action: :show

    get   "/fixity_check",                controller: :fixity_checks, action: :index
    post  "/fixity_check",                controller: :fixity_checks, action: :create

    get   "/ingest",                      controller: :ingests, action: :index
    post  "/ingest",                      controller: :ingests, action: :create

    get   "/version", controller: :version, action: :show
  end
end
