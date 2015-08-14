name=`ruby -ryaml -e 'puts YAML.load(open("/vagrant/conf.yaml").read)["name"]'`
mail=`ruby -ryaml -e 'puts YAML.load(open("/vagrant/conf.yaml").read)["mail"]'`

domain="local.kau.li"
