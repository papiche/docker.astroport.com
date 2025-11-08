[Unit]
Description=ASTROPORT API
After=network.target
Requires=network.target

[Service]
Type=simple
User=__USER__
RestartSec=1
Restart=always
ExecStart=__ASTROPORT_PATH__/12345.sh
StandardOutput=file:__HOME_DIR__/.zen/tmp/12345.log

[Install]
WantedBy=multi-user.target

