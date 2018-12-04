RailsAdmin.config do |config|

  config.authorize_with do
    authenticate_or_request_with_http_basic('Site Message') do |username, password|
      username == 'admin@example.com' && password == 'password'
    end
  end

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true

  config.model Tag do
    list do
      scopes [:popular, :popular_today, :popular_last_48_hours, :popular_last_7_days, :popular_last_30_days]
    end
  end

  config.model Post do
    edit do
      field :user
      field :description
      field :products
    end
  end

  config.model 'Category' do
    edit do
      field :name
      field :position
      field :products
      field :image
         # multiple_active_storage
    end
    list do
      configure :image
    end
  end 

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    import

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
  
end
