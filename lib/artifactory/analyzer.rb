#!/usr/bin/ruby

require 'mysql'

module Artifactory
  module Analyzer
    def self.check_bins(art_home)
      puts "Artifactory home location: #{art_home}"

      filestore = "#{art_home}/data/filestore"
      puts "Filestore location: #{filestore}"

      db_props_file = "#{art_home}/etc/storage.properties"

      db_props = {}
      IO.foreach(db_props_file) do |line|
        db_props[$1.strip] = $2 if line =~ /([^=]*)=(.*)/
      end
      #puts "DB Properties: #{db_props}"
      puts "Connection URL: #{db_props['url']}"

      # URL pattern jdbc:mysql://HOST:PORT/DB)NAME?PARAMS
      db_host, db_name = db_props['url'].match(/dbc:mysql:\/\/(.*):.*\/(.*)\?.*/).captures
      puts "DB Host: #{db_host} Name: #{db_name}"

      con = Mysql.new "#{db_host}", "#{db_props['username']}", "#{db_props['password']}", "#{db_name}"
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
          puts "\nBinary not found #{sha1}:\nFile: #{expected_file}"
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
end