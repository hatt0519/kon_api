# coding:utf-8
require 'sinatra'
require 'sinatra/reloader' 
require 'active_record'
require 'mysql2'
require 'sinatra'
require './Time_Format.class.rb'
#外部との通信を許可
set :environment, :production

# DB設定ファイルの読み込み
ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection('development')

ActiveRecord::Base.logger = Logger.new("./log/production.log")
ActiveRecord::Base.logger.level = 0

#active_recordのタイムゾーンを日本時間に設定
Time.zone_default =  Time.find_zone! 'Tokyo'

configure do
  # logging is enabled by default in classic style applications,
  # so `enable :logging` is not needed
  file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

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

get '/holiday_checker.json' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :json, :charset => 'utf-8'
  practices = Practices.select("date,period").where("date = ?",t_day).where("period = ?","0")
  practices.to_json(:root => false)
end

get '/holiday_checker.xml' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :xml, :charset => 'utf-8'
  practices = Practices.select("date,period").where("date = ?",t_day).where("period = ?","0")
  practices.to_xml(:root => false)
end

get '/ban_checker.json' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :json, :charset => 'utf-8'
  practices = Practices.find_by(:date => t_day)
  practices.to_json(:root => false)
end

get '/ban_checker_next_day.json' do
  time = Time_Format.new()
  n_day = time.nextday_time
  content_type :json, :charset => 'utf-8'
  practices = Practices.find_by(:date => n_day)
  practices.to_json(:root => false)
end

get '/ban_checker.xml' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :xml, :charset => 'utf-8'
  practices = Practices.find_by(:date => t_day)
  practices.to_xml(:root => false)
end

get '/next_day_schedule.json' do
  time = Time_Format.new()
  n_day = time.nextday_time
  content_type :json, :charset => 'utf-8'
  practices = Practices.select("id,week_id,date,period,room,ban_flg").where("date = ?",n_day).where("band IS NULL or band = ?",'')
  practices.to_json(:root => false)
end

get '/available_room.json' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :json, :charset => 'utf-8'
  practices = Practices.select("id,week_id,date,period,room").where("date = ?",t_day).where("band IS NULL or band = ?",'')
  practices.to_json(:root => false)
end

get '/available_room_12_10.json' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :json, :charset => 'utf-8'
  practices = Practices.select("id,week_id,date,period,room").where("date = ?",t_day).where("band IS NULL or band = ?",'').where("period > 2")
  practices.to_json(:root => false)
end

get '/available_room_14_30.json' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :json, :charset => 'utf-8'
  practices = Practices.select("id,week_id,date,period,room").where("date = ?",t_day).where("band IS NULL or band = ?",'').where("period > 3")
  practices.to_json(:root => false)
end

get '/available_room_16_10.json' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :json, :charset => 'utf-8'
  practices = Practices.select("id,week_id,date,period,room").where("date = ?",t_day).where("band IS NULL or band = ?",'').where("period > 4")
  practices.to_json(:root => false)
end

get '/available_room_17_50.json' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :json, :charset => 'utf-8'
  practices = Practices.select("id,week_id,date,period,room").where("date = ?",t_day).where("band IS NULL or band = ?",'').where("period > 5")
  practices.to_json(:root => false)
end
get '/available_room.xml' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :xml, :charset => 'utf-8'
  practices = Practices.select("id,week_id,date,period,room").where("date = ?",t_day).where("band IS NULL or band = ?", '')
  practices.to_xml(:root => false)
end