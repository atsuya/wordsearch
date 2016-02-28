require 'rubygems'
require 'bundler/setup'

require 'optparse'

require 'colorize'


options = {
  dictionary: '/usr/share/dict/words',
  tld: './tld.txt'
}

OptionParser.new do |parser|
  parser.banner = 'Usage: search.rb [options]'

  parser.on('-d', '--dictionary DICTIONARY', String, 'Path to a dictionary file') do |value|
    options[:dictionary] = value
  end

  parser.on('-t', '--tld TLD', String, 'Path to a TLD file') do |value|
    options[:tld] = value
  end
end.parse!

tlds = {}
File.open(options[:tld]).each do |line|
  tld = line.strip.downcase
  tlds[tld] = tld unless tlds.has_key?(tld)
end
puts "TLDs to look for: #{tlds.keys.join(', ')}"

File.open(options[:dictionary]).each do |line|
  word = line.strip.downcase

  tlds.each_key do |tld|
    if word.end_with?(tld)
      puts "#{word.split(tld)[0]}.#{tld.colorize(:blue)}"
    end
  end
end
