#!/usr/bin/expect -f

ssh-keygen -t rsa
set ip [lindex $argv 0]
spawn scp -o StrictHostKeyChecking=no /root/.ssh/id_rsa.pub $ip:/root/.ssh/authorized_keys
set timeout 20
expect "password:"
exec sleep 2
send "123456"    # You want to login to the server‘s login password.
interact