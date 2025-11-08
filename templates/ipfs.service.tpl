[Unit]
Description=IPFS daemon
After=network.target

[Service]
User=__USER__
ExecStart=/usr/local/bin/ipfs daemon --enable-pubsub-experiment --enable-namesys-pubsub
Restart=on-failure
CPUAccounting=true
CPUQuota=60%

[Install]
WantedBy=multi-user.target

