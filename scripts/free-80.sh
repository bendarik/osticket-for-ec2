if pids=$(sudo lsof -i:80 -t); then
    sudo kill $pids
fi