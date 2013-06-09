#!/usr/bin/ruby

require 'mysql'

begin

  filestore = ARGV[0]
  puts "Filestore location: #{filestore}"

  #puts File.exists?(filestore)

  con = Mysql.new 'localhost', 'root', '', 'artdb'
  rs = con.query 'SELECT VERSION()'
  puts "Server version: #{rs.fetch_row[0]}"

  rs = con.query("SELECT sha1 FROM binaries LIMIT 100")
  results = 0
  missing = 0
  rs.each do |row|
    results +=1
    sha1 = row[0]
    expectedFile = "#{filestore}/#{sha1[0..1]}/#{sha1}"
    unless File.exists?(expectedFile)
      missing +=1
      puts "Binary not found: #{expectedFile}"
    end
  end

  puts "Results: #{results} Missing: #{missing}"

rescue Mysql::Error => e
  puts "Error #{e.errno}: #{e.error}"

ensure
  con.close if con
end