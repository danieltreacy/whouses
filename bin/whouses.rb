#!/bin/ruby

# get list of names
$search = ARGV[0]
$geeks = []

class Geek
  
  attr_reader :name, :url
  
  def initialize(geek)
    @name = /.*<a href='http:\/\/(.*).usesthis.com\/.*/.match(geek)[1].gsub(".", " ").gsub(/^[a-z]|\s+[a-z]/) { |a| a.upcase }
    @url = /.*<a href='(.*)\/'.*/.match(geek)[1]
  end
  
  def has(item)
    result = `curl --silent #{@url} | grep -i '#{item}'`
    !result.empty?
  end
  
end

puts "Getting list of geeks from usesthis.com"

`curl --silent http://www.usesthis.com/archives/ | grep ".usesthis.com/' title='"`.split("\n").each do |geek|
  new_geek = Geek.new(geek)
  $geeks << new_geek
end

count = 0

# loop curl for parameter
$geeks.each do |geek|
  if geek.has($search)
    puts "#{geek.name} uses #{$search}..."
    count = count + 1 
  else
    puts "#{geek.name} does NOT use #{$search}"
  end
end

# tally results
percentage = (count.to_f / $geeks.size.to_f) * 100.0
puts "#{count} geeks (#{percentage.round}%) use #{$search}"