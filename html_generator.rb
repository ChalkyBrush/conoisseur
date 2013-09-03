require 'json'
require 'open-uri'

class HtmlGenerator 
  def product_finder
    product_type = "beer"
    second_filter = "Canada"
    puts "HtmlGenerator: index"
    chile_wines = []
    products = []
    i = 1
    while i <= 20 do
    raw_response = open("http://lcboapi.com/products?page=#{i}&per_page=100&q=#{product_type}").read
    # Parse JSON­formatted text into a Ruby Hash 
    parsed_response = JSON.parse(raw_response)
    # parsed_array = parsed_array.push(parsed_response)
    products = products.push(parsed_response["result"])
    i += 1
    end
    # Return the actual result data from the response, ignoring metadata
    products.each do |x|
      x.each do |y|
      origin = y.fetch("origin")
      picture = y.fetch("image_url")
        if origin.include?(second_filter) && picture != nil
          chile_wines = chile_wines.push(y)
        end
      end
    end
    chile_wines.each do |test|
      p test.keys
    end
    return chile_wines
  end

  def index
    puts "Welcome to the liquor product finder\n"
    # puts "Enter a product type"
    # user1 = gets.chomp
    # puts "Enter a product origin"
    # user2 = gets.chomp
    wines = product_finder

    File.open('santiago.html', 'w') do |f|
      f.puts("<html>")
      f.puts("<head>")
      f.puts('<link type="text/css" rel="stylesheet" href="santiago_stylesheet.css">')
      f.puts("<link href='http://fonts.googleapis.com/css?family=Droid+Sans' rel='stylesheet' type='text/css'>")
      f.puts("<link href='http://fonts.googleapis.com/css?family=Actor' rel='stylesheet' type='text/css'>")
      f.puts("    <title>Santiago</title>")
      f.puts("</head>")
      f.puts("<body>")
      f.puts('<div id="container">')
      f.puts('<div class="header_footer" id="header"></div>')
      f.puts("<ul>\n")
      wines.each_with_index do |wine, index|
      f.puts("  <li>\n")
      f.puts('    <div class="'+"card#{index%2}"+'">')
      f.puts('      <div class="thumbnail">')
      f.puts('        <img src="'+"#{wine.fetch("image_thumb_url")}"+'">')
      f.puts('        <p class="product_name">'+"#{wine.fetch("name")}")
      f.puts('        </p>')
      f.puts('        <p class="'+"other_text#{index%2}"+'"'+"> ID: #{wine.fetch("id")}")
      f.puts('        </p>')
      f.puts('      <div class="product_name"')
      f.puts("    </div>")
      f.puts("  </li>")
        #do pages?
      end
      f.puts('</ul>')
      f.puts('</div>')
      f.puts('</body>')
      f.puts('</html>')

    end

  end
  def show(product_id)
  # write the same as the index method but passing a product_id in
  end 
end
