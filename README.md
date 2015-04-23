# shared_vagrant_provisioners

## Using Provisioners

To use a provisioner, start by importing my public key:

    gpg --keyserver keys.gnupg.net --recv-keys 79E612D4

To execute a provisioner in a Vagrantfile:

    curl https://raw.githubusercontent.com/jcnnghm/shared_vagrant_provisioners/master/docker.sh.sig > /tmp/docker.sh.sig && gpg --verify /tmp/docker.sh.sig && gpg --decrypt /tmp/docker.sh.sig | sh

## Updating Signed Files

Whenever scripts are updated, the signed files will need to be updated.  To do
that, run:

    ./update_sigs

## Precommit Hook

To setup a precommit hook that will prevent commit script changes without
updating the config, run from the root:

    ln -s ../../pre-commit .git/hooks/pre-commit
