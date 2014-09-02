# coding:utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'mysql2'
require 'sinatra'

#外部との通信を許可
set :environment, :production

# DB設定ファイルの読み込み
ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection('development')

class Practices < ActiveRecord::Base
end

get '/Monday.json' do
  content_type :json, :charset => 'utf-8'
  practices = Practices.all.where("date like '%（月）%'")
  practices.to_json(:root => false)
end

get '/Tuesday.json' do
  content_type :json, :charset => 'utf-8'
  practices = Practices.all.where("date like '%（火）%'")
  practices.to_json(:root => false)
end

get '/Wednesday.json' do
  content_type :json, :charset => 'utf-8'
  practices = Practices.all.where("date like '%（水）%'")
  practices.to_json(:root => false)
end

get '/Thirsday.json' do
  content_type :json, :charset => 'utf-8'
  practices = Practices.all.where("date like '%（木）%'")
  practices.to_json(:root => false)
end

get '/Friday.json' do
  content_type :json, :charset => 'utf-8'
  practices = Practices.all.where("date like '%（金）%'")
  practices.to_json(:root => false)
end

get '/Saturday.json' do
  content_type :json, :charset => 'utf-8'
  practices = Practices.all.where("date like '%（土）%'")
  practices.to_json(:root => false)
end

get '/Sunday.json' do
  content_type :json, :charset => 'utf-8'
  practices = Practices.all.where("date like '%（日）%'")
  practices.to_json(:root => false)
end