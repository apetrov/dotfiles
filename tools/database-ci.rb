#!/Users/apetrov/.rvm/rubies/ruby-1.8.7-p302/bin/ruby
#before create pgpass
#cat > ~/.pgpass
#*:*:*:postgres:postgres
#chmod 0600 ~/.pgpass
puts "usage database-ci <aws id> <aws key> <bucket> <part of the backupname> <local databasename>"
require 'rubygems'
require 'aws/s3'

aws_id = ARGV[0]
aws_key = ARGV[1]
bucket = ARGV[2]
pattern= ARGV[3]
database = ARGV[4]

puts "aws_id   = #{aws_id}"
puts "aws_key  = #{aws_key}"
puts "bucket   = #{bucket}"
puts "pattern  = #{pattern}"
puts "database = #{database}"

include AWS::S3
AWS::S3::Base.establish_connection!(
  :access_key_id     => aws_id,
  :secret_access_key => aws_key
)

objects = Bucket.find(bucket).objects.select{|t| t.key.include?(pattern)}

name =  objects.last.key
file_name = name.split("/").last.gsub('.sql.gz','.sql')
backup = "/tmp/#{file_name}"
backup_arc = "#{backup}.gz"

puts "#{backup}"
puts "#{backup_arc}"
File.open(backup_arc,"w") do |file|
  S3Object.stream(name, bucket) do |chunk|
    file.write chunk
  end
end
puts "gunzip #{backup_arc}"
`gunzip #{backup_arc}`
puts "dropdb -U postgres -h localhost #{database}"
`dropdb -U postgres -h localhost #{database}`
puts "createdb -U postgres -h localhost #{database}"
`createdb -U postgres -h localhost #{database}`
puts "psql -U postgres -h localhost #{database} < #{backup}"
`psql -U postgres -h localhost #{database} < #{backup}`
puts "rm #{backup}"
`rm #{backup}`
puts "done"
