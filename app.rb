require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require "dotenv/load"

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

  response_body = raw_response.to_s

  parsed_response = JSON.parse(response_body)

  # Safely dig into the response to avoid nil values
  @recommendations = parsed_response.dig("Similar", "Results") || []

  erb(:results)
end
