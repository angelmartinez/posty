require 'HTTParty'
require 'csv'

brand = ''

access_token = ''

# Start the script with this message

cli_response = 'Pulling post level stuff for '+brand+'...' 
puts cli_response


CSV.open(brand+'.csv','w') do |csv|
  	# Bulk request to Facebook
	
	request = HTTParty.get('https://graph.facebook.com/'+brand+'/posts?access_token='+access_token+'&limit=1000&scope=offline_access').parsed_response
	
	# Loop through GET request results to get the data points that I care about
	csv << ['Post ID', 'Facebook Link', 'Date Created', 'Post Type','Post Text', 'Likes', 'Comments', 'Shares']
	base = request['data']
	last = base.length
	range = last - 1
	for post in (0..range) do
	  next if base[post]['type'] == 'status'
	  post_id = base[post]['id']
	  post_link = 'http://facebook.com/'+post_id
	  post_date = base[post]['created_time']
	  post_type = base[post]['type']
	  post_copy = base[post]['message']
	  
	  # Engagements
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
	csv << [post_id, post_link, post_date, post_type, post_copy, post_likes, post_comments, post_shares]
	end
	puts('D0N3')
  end
