
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)

set :domain, ENV['exdomain']
set :deploy_to, '/var/www/elixir'
set :repository, 'git://github.com/ohr486/elixir_deploy_example.git'
set :branch, 'master'
set :app_name, 'elixir_deploy_example'

set :shared_paths, ['log']

set :user, 'deploy-user'
set :forward_agent, true
set :identity_file, '/Users/ooharatsunenori/ohr-ec2-test.pem'

task :environment do
  queue %[source /etc/profile.d/kerl.sh]
end

task :setup => :environment do
  queue! %[sudo mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[sudo chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    queue %[mix deps.get]
    queue %[mix release]

    to :launch do
      # implement here
    end
  end
end

elixir_commands = [:start, :stop, :ping]
namespace :elixir do
  elixir_commands.each do |cmd|
    desc "elixir command[#{cmd}]"
    task cmd => :environment do
      queue "cd #{deploy_to}/#{current_path}/rel/#{app_name}/bin && ./#{app_name} #{cmd}"
    end
  end
end

