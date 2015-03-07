#require 'mina/bundler'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, ENV['exdomain']
set :deploy_to, '/var/www/elixir'
set :repository, 'git://github.com/ohr486/elixir_deploy_example.git'
set :branch, 'master'
set :app_name, 'elixir_deploy_example'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['log']

# Optional settings:
set :user, 'deploy-user'    # Username in the server to SSH to.
set :forward_agent, true     # SSH forward_agent.
set :identity_file, '/Users/ooharatsunenori/ohr-ec2-test.pem'

elixir_commands = [:start, :stop, :ping]

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  #invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
  queue %[source /etc/profile.d/kerl.sh]
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[sudo mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[sudo chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    queue %[mix deps.get]
    queue %[mix release]

    to :launch do
      #queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      #queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    end
  end
end

namespace :elixir do
  elixir_commands.each do |cmd|
    desc "elixir command[#{cmd}]"
    task cmd => :environment do
      queue "cd #{deploy_to}/#{current_path}/rel/#{app_name}/bin && ./#{app_name} #{cmd}"
    end
  end
end

