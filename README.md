# VPS Puppet Manifests

A set of manifests for a standalone Puppet install for the VPS serving [devkdesigns.com](http://devkdesigns.com) and [*.robhoward.id.au](http://robhoward.id.au).

1. Set up `files`, `hiera`, `manifests` and `modules` under `/etc/puppet` on the server.
2. Run the Puppet upgrade script in `shell/ensure-puppet3.sh`.
3. Create a `/etc/puppet/hiera/data/secrets.yaml` from the provided example.
4. `sudo puppet apply --hiera_config /etc/puppet/hiera/hiera.yaml --modulepath=/etc/puppet/modules /etc/puppet/manifests/site.pp`
5. Return in six months after learning more about Puppet; hang head in shame.

(Additional steps: use hiera-eyaml instead of a secrets file, set up a Puppet Master.)
