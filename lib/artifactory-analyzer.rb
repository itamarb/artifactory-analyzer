#!/usr/bin/ruby

require 'mysql'

class ArtifactoryAnalyzer
  def self.check_bins(filestore)
    #filestore = ARGV[0]
    puts "Filestore location: #{filestore}"

    #puts File.exists?(filestore)

    con = Mysql.new 'localhost', 'root', '', 'artdb3'
    rs = con.query 'SELECT VERSION()'
    puts "Database version: #{rs.fetch_row[0]}"

    rs = con.query('SELECT sha1 FROM binaries')
    results = 0
    missing = 0
    rs.each do |row|
      results +=1
      sha1 = row[0]
      expected_file = "#{filestore}/#{sha1[0..1]}/#{sha1}"
      unless File.exists?(expected_file)
        missing +=1
        puts "\nBinary not found #{sha1}: #{expected_file}"
        rs = con.query("SELECT repo, node_path, node_name FROM nodes WHERE sha1_actual = '#{sha1}'")
        rs.each do |node_row|
          puts "#{node_row.join('/')}"
        end
      end
    end

    puts "\nResults: #{results} Missing: #{missing}"

  rescue Mysql::Error => e
    puts "Error #{e.errno}: #{e.error}"

  ensure
    con.close if con
  end
end