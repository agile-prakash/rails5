# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'webmock/rspec'
require_relative '../lib/spec/api_constraints_spec.rb'
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
#Delayed::Worker.delay_jobs = false

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Request::JsonHelpers, :type => :controller
  config.include Request::HeadersHelpers, :type => :controller
  config.include Devise::Test::ControllerHelpers, :type => :controller
  config.include FactoryBot::Syntax::Methods
  config.include ActiveJob::TestHelper, type: :job
  config.include AbstractController::Translation

  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  # if Bullet.enable?
  #   config.before(:each) do
  #     Bullet.start_request
  #   end
  #
  #   config.after(:each) do
  #     Bullet.perform_out_of_channel_notifications if Bullet.notification?
  #     Bullet.end_request
  #   end
  # end

  config.before :each do
    stub_request(:get, "https://graph.facebook.com/me?access_token=badtoken&fields=id,name,first_name,last_name,email,friends").to_return(:status => 200, :body => "", :headers => {})
    stub_request(:get, "https://graph.facebook.com/me?access_token=goodtoken&fields=id,name,first_name,last_name,email,friends").to_return(:status => 200, :body => "{\"id\":\"904260\",\"name\":\"Tyler Horan\",\"first_name\":\"Tyler\",\"last_name\":\"Horan\",\"email\":\"thebestemail@gmail.com\",\"friends\":{\"data\":[{\"name\":\"James Ioannidis\",\"id\":\"429246\"},{\"name\":\"Ben Dodson\",\"id\":\"601344\"},{\"name\":\"Jonathan Fung\",\"id\":\"927586\"},{\"name\":\"Brian Amanatullah\",\"id\":\"3407156\"},{\"name\":\"Matthias Wagner\",\"id\":\"1334702731\"}],\"paging\":{\"cursors\":{\"before\":\"QVFIUlpIUm5mSFJfQkNwdWo0TG01VnMxMmh5VHdJRzk0dmdnSUhPbDhPakozWUxuelFWNlJVRFZAfU2Q5aXZAQWW5idk0ZD\",\"after\":\"QVFIUklOWkNnMHZAmOEVrRGR5VXVPamg4UDBxei1yeXhjU3E0Y0JPREVYQlR6MDFma09GZA3FoMnczQlFQb25aRXM3eloZD\"}},\"summary\":{\"total_count\":613}},\"picture\":{\"data\":{\"is_silhouette\":false,\"url\":\"https://scontent.xx.fbcdn.net/v/t1.0-1/p50x50/1012444_10102453937950480_8626389580104630560_n.jpg?oh=be020691d9037c598569ecf28f9ed98a&oe=57F42A97\"}}}", :headers => {})
    stub_request(:get, "https://graph.facebook.com/me?access_token=goodtokenemail&fields=id,name,first_name,last_name,email,friends").to_return(:status => 200, :body => "{\"id\":\"904260\",\"bio\":\"I should put something here.\",\"birthday\":\"01/01/1967\",\"first_name\":\"Test\",\"gender\":\"male\",\"last_name\":\"User\",\"link\":\"http://www.facebook.com/839203\",\"locale\":\"en_GB\",\"name\":\"Test User\",\"timezone\":-7,\"updated_time\":\"2015-06-05T20:24:58+0000\",\"verified\":true}", :headers => {})
    stub_request(:get, "https://graph.facebook.com/me?access_token=missingemail&fields=id,name,first_name,last_name,email,friends").to_return(:status => 200, :body => "{\"id\":\"904260\",\"bio\":\"I should put something here.\",\"birthday\":\"01/01/1967\",\"first_name\":\"Test\",\"gender\":\"male\",\"last_name\":\"User\",\"link\":\"http://www.facebook.com/839203\",\"locale\":\"en_GB\",\"name\":\"Test User\",\"timezone\":-7,\"updated_time\":\"2015-06-05T20:24:58+0000\",\"verified\":true}", :headers => {})
    stub_request(:get, "https://scontent.xx.fbcdn.net/v/t1.0-1/p50x50/1012444_10102453937950480_8626389580104630560_n.jpg?oe=57F42A97&oh=be020691d9037c598569ecf28f9ed98a").to_return(:status => 200, :body => File.read('spec/images/purple.gif'), :headers => {})
    stub_request(:get, "https://robohash.org/commodiquiasunt.png?set=set123&size=300x300").to_return(:status => 200, :body => File.read('spec/images/purple.gif'), :headers => {})
    stub_request(:post, "https://graph.facebook.com/oauth/access_token").to_return(:status => 200, :body => "{\"access_token\":\"EAADdkKReIS0BAH2SlIQu5a8j4fMs5yYO5ffJwjqkSJYWptxr7lVU30TgGlQYaa3lUX5oZBx60LM40QUIm6Av0GQfbpXbYvd6hRTuUbqJ2ZA9pTvwufKI3em1nSAXNCR2KF5XWKmAYlbevh2fBi1yyTq735XIwZD\", \"expires\":\"5184000\"}", :headers => {})
    stub_request(:get, "https://api.instagram.com/v1/users/self.json?access_token=goodtoken").to_return(:status => 200, :body => "{ \"data\": { \"id\": \"1574083\", \"username\": \"snoopdogg\", \"full_name\": \"Snoop Dogg\", \"profile_picture\": \"http://distillery.s3.amazonaws.com/profiles/profile_1574083_75sq_1295469061.jpg\", \"bio\": \"This is my bio\", \"website\": \"http://snoopdogg.com\", \"counts\": { \"media\": 1320,\"follows\": 420, \"followed_by\": 3410 }}}", :headers => {})
    stub_request(:get, "https://api.instagram.com/v1/users/self.json?access_token=badtoken").to_return(:status => 200, :body => "", :headers => {})
    stub_request(:get, /http:\/\/maps\.googleapis\.com\/maps\/api\/geocode.{1,}/).to_return(status: 200, body: "{\"results\":[{\"address_components\":[{\"long_name\":\"1200\",\"short_name\":\"1200\",\"types\":[\"street_number\"]},{\"long_name\":\"Ocean Avenue\",\"short_name\":\"Ocean Ave\",\"types\":[\"route\"]},{\"long_name\":\"Westwood Park\",\"short_name\":\"Westwood Park\",\"types\":[\"neighborhood\",\"political\"]},{\"long_name\":\"San Francisco\",\"short_name\":\"SF\",\"types\":[\"locality\",\"political\"]},{\"long_name\":\"San Francisco County\",\"short_name\":\"San Francisco County\",\"types\":[\"administrative_area_level_2\",\"political\"]},{\"long_name\":\"California\",\"short_name\":\"CA\",\"types\":[\"administrative_area_level_1\",\"political\"]},{\"long_name\":\"United States\",\"short_name\":\"US\",\"types\":[\"country\",\"political\"]},{\"long_name\":\"94112\",\"short_name\":\"94112\",\"types\":[\"postal_code\"]},{\"long_name\":\"1831\",\"short_name\":\"1831\",\"types\":[\"postal_code_suffix\"]}],\"formatted_address\":\"1200 Ocean Ave, San Francisco, CA 94112, USA\",\"geometry\":{\"location\":{\"lat\":37.7239842,\"lng\":-122.4556294},\"location_type\":\"ROOFTOP\",\"viewport\":{\"northeast\":{\"lat\":37.7253331802915,\"lng\":-122.4542804197085},\"southwest\":{\"lat\":37.7226352197085,\"lng\":-122.4569783802915}}},\"place_id\":\"ChIJ1zju3dJ9j4AR-QaMiI2zWIo\",\"types\":[\"street_address\"]}],\"status\":\"OK\"}")
    stub_request(:post, "https://api.cloudinary.com/v1_1/www-hairfolioapp-com/image/upload").to_return(:status => 200, :body => "", :headers => {})
    end

end
