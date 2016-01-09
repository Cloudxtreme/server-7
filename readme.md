# Minecraft server

Setup docker:

    wget -qO- https://get.docker.com/ | sudo sh

Get tool:
    
    wget https://raw.githubusercontent.com/mcstyle/server/master/run.server.sh
    chmod +x run.server.sh

Run the server:
    
    sudo ./run.server.sh --image mcstyle/kcauldron:1.7.10-1492.164 --name mcserver --data /srv/mcserver --port 25565  
