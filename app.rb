require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do
  erb(:homepage)
end

get("/results") do
  @query = params.fetch("query").strip

  if @query.empty?
    redirect "/"
  end

  @api_key = ENV.fetch("TASTE_DIVE_KEY", nil)
  if @api_key.nil? || @api_key.empty?
    halt 500, "API key is missing. Please set the TASTE_DIVE_KEY environment variable."
  end

 # @api_key = ENV.fetch['TASTE_DIVE_KEY']

  @url = "https://tastedive.com/api/similar?q=#{@query}&type=music&limit=10&info=1&k=#{@api_key}"

  @raw_response = HTTP.get(@url)

  @parsed_response = JSON.parse(@raw_response.to_s)

  @recommendations = @parsed_response.fetch("similar").fetch("results")

  erb(:results)
end
