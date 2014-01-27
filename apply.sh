#!/bin/bash

sudo puppet apply --modulepath=/etc/puppet/modules \
                  --heira_config /etc/puppet/hiera/data/secrets.yaml \
                  /etc/puppet/manifests/site.pp
