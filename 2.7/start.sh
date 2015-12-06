#!/bin/sh

cp -rp /.whiskey/jupyter $HOME/.jupyter
cp -rp /.whiskey/ipython $HOME/.ipython

if [ x"$IPYTHON_CLUSTER_LABEL" != x"" ]; then
    cat /.whiskey/ipython/profile_default/security/ipcontroller-client.json | \
        sed -e "s/ipcontroller/ipcontroller-$IPYTHON_CLUSTER_LABEL/" > \
        $HOME/.ipython/profile_default/security/ipcontroller-client.json
    cat /.whiskey/ipython/profile_default/security/ipcontroller-engine.json | \
        sed -e "s/ipcontroller/ipcontroller-$IPYTHON_CLUSTER_LABEL/" > \
        $HOME/.ipython/profile_default/security/ipcontroller-engine.json
fi

if [ x"$IPYTHON_CONTAINER_TYPE" = x"controller" ]; then
    exec ipcontroller
fi

if [ x"$IPYTHON_CONTAINER_TYPE" = x"engine" ]; then
    exec ipengine
fi

exec ipython notebook --no-browser --debug --log-level=DEBUG \
    --notebook-dir=/app --ip=* --port=8080
