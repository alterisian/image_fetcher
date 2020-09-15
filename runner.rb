require './lib/image_fetcher.rb'

puts "=-=-=-=-=-=-"
puts "ImageFetcher"
puts "-=-=-=-=-=-="
puts "We have param: #{ARGV[0]}"
unless ARGV[0].nil?
  image_fetcher = ImageFetcher.new ARGV[0]
  image_fetcher.go
else
  puts 'Missing filename with image urls'
  puts 'Usage: ruby ./runner.rb "./input/image_list.txt'
end