#!/usr/bin/ruby

require 'mysql'

begin
    
    filestore = ARGV[0]
	puts "Filestore location: #{filestore}"
	
	#puts File.exists?(filestore)
	
	con = Mysql.new 'localhost', 'root', '', 'artdbdev'
    rs = con.query 'SELECT VERSION()'
    puts "Server version: #{rs.fetch_row[0]}"
    
	rs = con.query("SELECT sha1 FROM binaries LIMIT 10")
	rs.each do |sha1|
	    #puts bin.join("\s|\s")
		puts "#{sha1[0..1]}"
		expectedFile = "#{filestore}/#{sha1[0..1]}/#{sha1}"
		unless File.exists?(expectedFile)
			puts "Binary not found: #{expectedFile}"
		end
	end
			
rescue Mysql::Error => e
    puts "Error #{e.errno}: #{e.error}"
    
ensure
    con.close if con
end