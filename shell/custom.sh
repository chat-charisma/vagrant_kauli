. /vagrant/conf.sh

# Gitのユーザー設定
git config --global user.name $name
git config --global user.email $mail

# masterにcommitできないように設定
mkdir -p ~/.git_template/hooks
cat > ~/.git_template/hooks/pre-commit << EOF
#!/bin/sh

branch="\$(git symbolic-ref HEAD 2>/dev/null)" || "\$(git describe --contains --all HEAD)"

if [ "\${branch##refs/heads/}" = "master" ]; then
  echo "Do not commit on the master branch!"
  exit 1
fi
EOF
chmod +x ~/.git_template/hooks/pre-commit
git config --global init.templatedir ~/.git_template
ls /kauli | egrep -v "logs|webroot" | xargs -I{} ln -fs ~/.git_template/hooks/pre-commit /kauli/{}/.git/hooks/pre-commit

#
curl -s https://raw.githubusercontent.com/awaki75/dotfiles/master/install.sh | sh
cat >> ~/.zshrc << EOF


export KAULI_HOME=/kauli/common
. /kauli/common/python27/bin/activate

function chpwd_func {
    dir=\`git rev-parse --show-toplevel 2>/dev/null\`
    echo \$dir | grep -q ^/kauli/ && export KAULI_HOME=\$dir
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd chpwd_func

function chapi {
    echo \$1 | grep -q '^https\?://..*/$' || return
    sudo sed -i "s|\\(sub_filter https://api.kau.li/\\).*$|\1 \$1;|" /etc/nginx/conf.d/dspui.conf
    sudo service nginx restart
}
function _chapi {
    if ((CURRENT == 2)); then
        compadd http://dev-api.kau.li/ http://dsp-api.dev.kau.li/
    fi
}
compdef _chapi chapi
EOF
