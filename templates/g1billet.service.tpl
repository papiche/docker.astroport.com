[Unit]
Description=G1BILLET API
After=network.target
Requires=network.target

[Service]
Type=simple
User=__USER__
RestartSec=1
Restart=always
ExecStart=__G1BILLET_PATH__/G1BILLETS.sh daemon
StandardOutput=file:__HOME_DIR__/.zen/tmp/g1billet.log

[Install]
WantedBy=multi-user.target

