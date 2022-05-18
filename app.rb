require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require "csv"
require_relative './memo'

get '/' do
  @memos = Memo.all
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memo = Memo.new(title: params[:title], body: params[:body])
  memo.save
  redirect '/'
end

get '/memos/:id' do |id|
  @memo = Memo.find(id)
  erb :show
end

get '/memos/:id/edit' do |id|
  @memo = Memo.find(id)
  erb :edit
end

patch '/memos/:id' do |id|
  Memo.update(id: id, title: params[:title], body: params[:body])
  redirect "/memos/#{id}"
end

delete '/memos/:id' do |id|
  Memo.destory(id)
  redirect '/'
end
