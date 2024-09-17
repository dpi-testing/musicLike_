require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

get("/") do
  erb(:homepage)
end

get("/results") do
  @query = params.fetch("query").strip

  if @query.empty?
    redirect "/"
  end

  api_key = ENV["TASTE_DIVE_KEY"]

  url = "https://tastedive.com/api/similar?q=#{@query}&type=music&limit=10&info=1&k=#{api_key}"

  raw_response = HTTP.get(url)

  parsed_response = JSON.parse(raw_response)

  @recommendations = parsed_response.dig("similar", "results")
  
  erb(:results)
end
