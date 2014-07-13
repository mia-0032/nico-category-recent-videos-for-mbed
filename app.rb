require 'sinatra'
require 'kconv'
require 'json'
require 'net/http'
require 'uri'

set :default_encoding => 'Shift_JIS'

NICO_CATEGORIES = {
  :ent => 'エンターテイメント',
  :music => '音楽',
  :sing => '歌ってみた',
  :play => '演奏してみた',
  :dance => '踊ってみた',
  :vocaloid => 'VOCALOID',
  :nicoindies => 'ニコニコインディーズ',
  :animal => '動物',
  :cooking => '料理',
  :nature => '自然',
  :travel => '旅行',
  :sport => 'スポーツ',
  :lecture => 'ニコニコ動画講座',
  :drive => '車載動画',
  :history => '歴史',
  :science => '科学',
  :tech => 'ニコニコ技術部',
  :handcraft => 'ニコニコ手芸部',
  :make => '作ってみた',
  :politics => '政治',
  :anime => 'アニメ',
  :game => 'ゲーム',
  :toho => '東方',
  :imas => 'アイドルマスター',
  :radio => 'ラジオ',
  :draw => '描いてみた',
  :are => '例のアレ',
  :other => 'その他',
  :diary => '日記',
  :r18 => 'R-18'
}

SEARCH_API_URL = 'http://api.search.nicovideo.jp/api/'

api_query_template = {
  :query => '初音ミク',
  :service => ['video'],
  :search => ['tags'],
  :join => ['cmsid', 'title', 'start_time'],
  :from => 0,
  :size => 1,
  :sort_by => 'start_time',
  :order => 'desc',
  :issuer => 'apiguide',
  :reason => 'mbed festival'
}

get '/' do
  category = '音楽'
  title = '新・豪血寺一族 -煩悩解放 - レッツゴー!陰陽師'
  start_time = '2007-03-06 00:33:00'
  "[sm9,#{category.tosjis},#{start_time},#{title.tosjis}]"
end

get '/:category' do
  if NICO_CATEGORIES.include?(params[:category].to_sym)
    category = NICO_CATEGORIES[params[:category].to_sym]
  else
    raise Sinatra::NotFound
  end

  response = nil
  uri = URI.parse(SEARCH_API_URL)

  request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})

  api_query = api_query_template.clone
  api_query[:query] = category
  request.body = JSON.pretty_generate(api_query)

  http = Net::HTTP.new(uri.host, uri.port)
  http.start do |h|
    response = h.request(request)
  end

  contents = JSON.parse(response.body.split("\n")[2])
  
  cmsid = contents['values'][0]['cmsid']
  title = contents['values'][0]['title']
  start_time = contents['values'][0]['start_time']
  "[#{cmsid},#{category.tosjis},#{start_time},#{title.tosjis}]"
end

