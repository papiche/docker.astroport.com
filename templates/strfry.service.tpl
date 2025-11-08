[Unit]
Description=NOSTR strfry relay service
After=network.target
Requires=network.target

[Service]
Type=forking
User=__USER__
Restart=always
WorkingDirectory=__STRFRY_PATH__
ExecStart=__STRFRY_PATH__/start.sh
PIDFile=__STRFRY_PATH__/.pid
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

