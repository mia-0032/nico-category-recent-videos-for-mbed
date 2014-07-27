require 'sinatra'
require 'cgi'
require 'json'
require 'kconv'
require 'net/http'
require 'nkf'
require 'uri'

set :default_encoding => 'Shift_JIS'

NICO_CATEGORIES = {
  :ent        => 'エンターテイメント',
  :music      => '音楽',
  :sing       => '歌ってみた',
  :play       => '演奏してみた',
  :dance      => '踊ってみた',
  :vocaloid   => 'VOCALOID',
  :nicoindies => 'ニコニコインディーズ',
  :animal     => '動物',
  :cooking    => '料理',
  :nature     => '自然',
  :travel     => '旅行',
  :sport      => 'スポーツ',
  :lecture    => 'ニコニコ動画講座',
  :drive      => '車載動画',
  :history    => '歴史',
  :science    => '科学',
  :tech       => 'ニコニコ技術部',
  :handcraft  => 'ニコニコ手芸部',
  :make       => '作ってみた',
  :politics   => '政治',
  :anime      => 'アニメ',
  :game       => 'ゲーム',
  :toho       => '東方',
  :imas       => 'アイドルマスター',
  :radio      => 'ラジオ',
  :draw       => '描いてみた',
  :other      => 'その他',
  :diary      => '日記'
}

SEARCH_API_URL = 'http://api.search.nicovideo.jp/api/'

api_query_template = {
  :query   => '',
  :service => ['video'],
  :search  => ['tags'],
  :join    => ['cmsid', 'title', 'start_time'],
  :from    => 0,
  :size    => 1,
  :sort_by => 'start_time',
  :order   => 'desc',
  :issuer  => 'apiguide',
  :reason  => 'mbed festival'
}


def render_response(cmsid, category, title)
  "#{cmsid}|#{NKF.nkf('-s -W -Z4', category)}|#{CGI.unescapeHTML(title).tosjis}"
end

def request_api(url, body)
  response = nil
  uri = URI.parse(url)

  request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
  request.body = body

  http = Net::HTTP.new(uri.host, uri.port)
  http.start do |h|
    response = h.request(request)
  end

  response
end


get '/' do
  cmsid = 'sm0'
  category = 'サンプル'
  title = 'サンプルリクエスト'

  render_response cmsid, category, title
end

get '/:category' do
  if NICO_CATEGORIES.include?(params[:category].to_sym)
    category = NICO_CATEGORIES[params[:category].to_sym]
  else
    raise Sinatra::NotFound
  end

  api_query = api_query_template.clone
  api_query[:query] = category

  response = request_api(SEARCH_API_URL, JSON.pretty_generate(api_query))

  contents = JSON.parse(response.body.split("\n")[2])
  
  cmsid = contents['values'][0]['cmsid']
  title = contents['values'][0]['title']
  render_response cmsid, category, title
end

