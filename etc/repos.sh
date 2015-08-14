for dir in /kauli/*; do
    echo $dir
    cd $dir
    if [ "`git rev-parse --abbrev-ref HEAD 2>/dev/null`" = "master" ]; then
        git pull
    else
        echo "なかった"
    fi
done
