task :default => [:update, :compile, :purge, :link ]

task :update do
  sh 'git pull'
end

task :compile do
  sh 'mkdir -p config'
  sh 'cp templates/* config'
end

GIT_TOKEN_FILE = ".gittoken"

task :ghi do
  if File.exists?(GIT_TOKEN_FILE)
    token = File.read(GIT_TOKEN_FILE)
    gitconfig = File.read("templates/gitconfig")
    gitconfig<<"\r\n[ghi]"
    gitconfig<<"\r\n\ttoken=#{token}\r\n"
    File.open("config/gitconfig","w"){|f| f<<gitconfig}
    Rake::Task["purge"].execute
    Rake::Task["link"].execute
  else
    warn "run 'rake git_token' first"
  end
end

task :git_token do
  puts "Please enter your github token"
  token = STDIN.gets
  unless token.empty?
    File.open( GIT_TOKEN_FILE,"w+") do |f|
      f<<token
    end
    sh "chmod 0600 #{GIT_TOKEN_FILE}"
  end
end

task :purge do
  Dir["config/*"].each do |t|
    name = t.split('/').last
    sh "rm ~/.#{name}"
  end
end

task :link do
  Dir["config/*"].each do |t|
    name = t.split('/').last
    file = File.join(Dir.pwd,t)
    ln_s file, File.join(ENV['HOME'],".#{name}")
  end
end
