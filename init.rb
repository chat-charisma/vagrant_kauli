#!/usr/bin/env ruby

require "readline"
require "yaml"

name = Readline.readline "name> "
if name.nil? or name.empty? then
    puts "name は1以上の長さが必要です"
    exit
end

mail = Readline.readline "mail> "
if mail.nil? or mail !~ /\A[a-zA-Z0-9_\#!$%&`'*+\-{|}~^\/=?\.]+@[a-zA-Z0-9][a-zA-Z0-9\.-]+\z/ then
    puts "mail はメールアドレスである必要があります"
    exit
end

open "./conf.yaml", "w" do |f|
    YAML.dump({"name" => name, "mail" => mail}, f)
end
puts "ok"
