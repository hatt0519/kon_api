# coding:utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'mysql2'
require './Time_Format.rb'
require './word.rb'

#外部との通信を許可
set :environment, :production

# DB設定ファイルの読み込み
ActiveRecord::Base.configurations = YAML.load_file('database.yml')
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
class PracticesBase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :development
end

class SistersBase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :database2
end

get '/checker.json' do
  month = params['month']
  day = params['day']
  search_type = params['search_type']
  class Practices < PracticesBase
  end
  Practices.connection_pool.with_connection do
    time = Time_Format.new(month, day)
    t_day = time.today_time
    content_type :json, :charset => 'utf-8'
    practice = Practices.find_by(:date => t_day)
    case search_type
    when "holiday"
      checker = {is_holiday: practice['holiday_flg']}
    when "ban"
      checker = {is_ban: practice['ban_flg']}
    end
    checker.to_json(:root => false)
  end
end

get '/available_room.json' do
  month = params['month']
  day = params['day']
  period = params['period']
  search_range = params['search_range']
  class Practices < PracticesBase
  end
  Practices.connection_pool.with_connection do
    time = Time_Format.new(month, day)
    date = time.today_time
    content_type :json, :charset => 'utf-8'
    practices = Practices.select("id, week_id, date, period, room").where("date = ?", date).where("band IS NULL or band = ?",'')
    if period.present?
      check_period = Word.integer_string?(period)
      case search_range
      when "before"
        practices = check_period ? practices.where("period <= ?", period).where("period != ?", "昼") : practices.where("period < ?", period)
      when "after"
        practices = check_period ? practices.where("period >= ?", period).where("period != ?", "昼") : practices.where("period > ?", period)
      else
        practices = practices.where("period = ?", period)
      end
    end
    practices.to_json(:root => false)
  end
end


get '/shift_checker.json' do
  class Sisters < SistersBase
  end
  Sisters.connection_pool.with_connection do
    content_type :json, :charset => 'utf-8'
    sister = Sisters.select("id").where("shift_flg = 1")
    sister.to_json(:root => false)
  end
end
