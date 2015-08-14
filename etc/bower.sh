ver="v0.12.4"

curl http://nodejs.org/dist/$ver/node-$ver.tar.gz | tar xz
cd node-$ver
./configure
make
sudo make install
sudo npm install -g npm
sudo npm install -g bower
