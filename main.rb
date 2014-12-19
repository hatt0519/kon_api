# coding:utf-8
require 'sinatra'
require 'sinatra/reloader' 
require 'active_record'
require 'mysql2'
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
  before{
    env["rack.errors"] = file
  }
  #use Rack::CommonLogger, file
end

class Practices < ActiveRecord::Base
end

class SistersBase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :database2
end

class Sisters < SistersBase
end

after do
  ActiveRecord::Base.connection.close
end


get '/holiday_checker.json' do
  time = Time_Format.new()
  t_day = time.today_time
  content_type :json, :charset => 'utf-8'
  practices = Practices.select("date,period").where("date = ?",t_day).where("period = ?","0")
  practices.to_json(:root => false)
end

get '/holiday_checker_nextday.json' do
  time = Time_Format.new()
  n_day = time.nextday_time
  content_type :json, :charset => 'utf-8'
  practices = Practices.select("date,period").where("date = ?",n_day).where("period = ?","0")
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

get '/shift_checker.json' do
  ActiveRecord::Base.connection_pool.with_connection do
        begin
          content_type :json, :charset => 'utf-8'
          sister = Sisters.select("id").where("shift_flg = 1")
          sister.to_json(:root => false)
        end
  end
end
