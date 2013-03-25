require 'HTTParty'
require 'csv'

# Enter brand name here
puts ('Enter the brand that you want to look at (example: ge, doveus, microsoft): ')
b = gets.chomp
brand = b.gsub("\n","")

# Make sure the access token you get from facebook doesn't expire
access_token = ''

# Start the script with this message
cli_response = 'Pulling post level stuff for '+brand+'...' 
puts cli_response

# Open CSV file to start writing to disk
CSV.open(brand+'.csv','w') do |csv|
  	
	# Bulk request to Facebook
	request = HTTParty.get('https://graph.facebook.com/'+brand+'/posts?access_token='+access_token+'&limit=1000&scope=offline_access').parsed_response
	
	# Headers for CSV export
	csv << ['Post ID', 'Facebook Link', 'Date Created', 'Post Type','Post Text', 'Likes', 'Comments', 'Shares']
	
	# Constant variables for making the parsing easier
	base = request['data']
	last = base.length
	range = last - 1
	
	# Iteration through the request
	for post in (0..range) do
	  
	  # This next line is used to weed out 'statuses' that were from people leaving comments on the wall.
	  next if base[post]['story'] != nil
	  
	  # Key information per post
	  post_id = base[post]['id']
	  post_link = 'http://facebook.com/'+post_id
	  post_date = base[post]['created_time']
	  post_type = base[post]['type']
	  post_copy = base[post]['message']
	  
	  # Logic for pulling engagement metrics
	 post_likes = base[post]['likes']
	  if post_likes == nil then
	   post_likes = 0
	  else
	    post_likes = base[post]['likes']['count']
	  end
	  post_comments = base[post]['comments']
	  if post_comments == nil then
	    post_comments = 0
	  else
	   post_comments = base[post]['comments']['count']
	  end
	  post_shares = base[post]['shares']
	  if post_shares == nil then
	    post_shares = 0
	  else
	    post_shares = base[post]['shares']['count']
	  end
	
	# Iteration into CSV file that got originally produced.
	csv << [post_id, post_link, post_date, post_type, post_copy, post_likes, post_comments, post_shares]
	end
	
	# Just to let you know the file is done and ready to go.
	puts('D0N3')
  end
