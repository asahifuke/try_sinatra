# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require 'csv'
require_relative './memo'

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
  redirect '/'
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
  @memo.update(title: params[:title], body: params[:body])
  redirect "/memos/#{@memo.id}"
end

delete '/memos/:id' do
  @memo = Memo.find(params[:id])
  @memo.destory
  redirect '/'
end
