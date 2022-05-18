require 'sinatra'
require 'sinatra/reloader'

class Memo
  def initialize(title:, body:)
    @title = title
    @body  = body
  end

  def save
    puts @title
    puts @body
  end

  def self.all
    [
      {id: 1, title: "title1", body: "body1"},
      {id: 2, title: "title2", body: "body2"}
    ]
  end

  def self.find(id)
    {id: 1, title: "title1", body: "body1"}
  end
end

get '/' do
  @memos = Memo.all
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  @memo = Memo.new(title: params[:title], body: params[:body])
  @memo.save
  # showにリダイレクト
end

get '/memos/:id' do
  @memo = Memo.find(params[:id])
  erb :show
end

get '/memos/:id/edit' do
  @memo = Memo.find(params[:id])
  erb :edit
end

patch '/memos/:id' do
  @memo = Memo.find(params[:id])
  @memo.update(memo_params)
  # showにリダイレクト
end

delete '/memos/:id' do
  @memo = Memo.find(params[:id])
  @memo.destory
  # indexにリダイレクト
end
