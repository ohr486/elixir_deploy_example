ElixirDeployExample
===================

# setup server(install elixir and ruby)
```
$ git clone git@github.com:ohr486/elixir_deploy_example.git
$ cd /elixir_deploy_example/setup
# install galaxy task for install elixir and erlang
$ ansible-galaxy install ohr486.elixir
# install elixir and erlang to deploy server
$ ansible-playbook setup.xml -i hosts #[wip] add ruby installation script to setup.xml
```

# setup local
```
# install mina
$ bundle install
# setup elixir app in deploy server
$ mina setup
```

# deploy
```
# deploy elixir app from github repo
$ mina deploy
```

# start/stop/restart elixir app
```
# start elixir app
$ mina elixir:start
# stop elixir app
$ mina elixir:stop
# restart elixir app
$ mina elixir:restart
```

