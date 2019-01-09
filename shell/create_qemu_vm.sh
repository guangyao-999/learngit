#!/bin/bash
#
#author:sgy
#
function menu {
    clear
    echo
    echo -e "\t\t\t vm Admin Menu\n"
    echo -e "\t1、create new vm server"
    echo -e "\t2、restart new vm server"
    echo -e "\t3、clone vm server"
    echo -e "\t0、Exit program\n\n"
    echo -en "\t\tEnter option: "
    read -n 1 option
}

# get random num (10~99)
function rand {
    local min=10
    local max=$((99-min+1))
    local num=$(($RANDOM+1000000000))
    echo $(($num%$max+$min))
}


function get_uuid {
    echo `uuidgen`
}

function create_img {

    cd `dirname $0`
    cd $vmname
    local basepath=$(pwd)
    qemu-img  create -f qcow2 sda.img 4000G &> $basepath/createlog
    qemu-img  create -f qcow2 sdb.img 200G  &>> $basepath/createlog
    qemu-img  create -f qcow2 sdc.img 200G  &>> $basepath/createlog
    qemu-img  create -f qcow2 sdd.img 200G  &>> $basepath/createlog

}

function copy_img {

    cd `dirname $0`
    cd $vmname
    local basepath=$(pwd)
    qemu-img  create -f qcow2  -b  /user/model/sda.img  sda.img &> $basepath/copylog
    qemu-img  create -f qcow2  -b   /user/model/sdb.img  sdb.img &>> $basepath/copylog
    qemu-img  create -f qcow2  -b   /user/model/sdc.img  sdc.img &>> $basepath/copylog
    qemu-img  create -f qcow2  -b   /user/model/sdd.img  sdd.img &>> $basepath/copylog


}

function get_mac {
    local mac='52:54:20':$(rand):$(rand):$(rand)
    echo $mac
}

define_vm() {
    virsh define $1.xml &>> $basepath/log
}

start_vm() {
    virsh start $1 &>> $basepath/log
}

function get_port {
    local out=`virsh dumpxml $1 |grep port|grep yes |gawk '{print $3}'`
    echo $out
}

function check_name {

    local name=$1
    local vm_list=`virsh list|gawk '{print $2}'`
    for i in $vm_list
    do
        if [ $i = $name ]
        then
            return $error
        fi
    done

    return $success
}
function check_iso_file {
    
    local iso_file=$1
    if [ ! -e iso_file ] 
    then
        return $error
    fi

    if [ "${iso_file##*.}"x = "iso"x ]
    then
        return $success
    else 
        return $error
    fi
}

function create_new_vm_server {

    clear
    echo -e "\t\t\tPlease input vmname"
    local uuid=$(get_uuid)
    local mac=$(get_mac)
    local iso_file_path="/test.iso"

    read -p "vmname:" vmname
    check_name $vmname
    result=$?
    if [ $result -ne $success ] 
    then 
        echo "vmname is exists, choice other!"
        return $error
    fi
    
    basepath=$(cd `dirname $0`; mkdir $vmname; cd $vmname;pwd)
    
    echo "
s/<name>test<\/name>/<name>$vmname<\/name>/
s/<uuid>test<\/uuid>/<uuid>$uuid<\/uuid>/
s!file='test.iso'!file='$iso_file_path'!
s!file='sda.img'!file='$basepath/sda.img'!
s!file='sdb.img'!file='$basepath/sdb.img'!
s!file='sdc.img'!file='$basepath/sdc.img'!
s!file='sdd.img'!file='$basepath/sdd.img'!
s!mac address='52:54:00'!mac address='$mac'!

    " > $basepath/script.sed

    sed -f $basepath/script.sed /user/test.xml > $basepath/$vmname.xml
    create_img $vmname
    define_vm $vmname
    start_vm $vmname
    port=$(get_port $vmname)
    echo "the vm port is $port"

}

function restart_new_vm_server {

    clear
    echo -e "\t\t\tClone vm server quickly"
    echo -e "\tPlease input vmname"
    
    read -p "vmname:" vmname
    check_name $vmname
    result=$?
    if [ $result -eq $success ] 
    then 
        echo "the vm server is not running!"
        return $error
    fi

    cd `dirname $0`
    cd $vmname
    basepath=$(pwd)

    sed -i "s/dev='cdrom'/dev='hd'/" $vmname.xml 
    virsh destroy $vmname
    define_vm $vmname
    start_vm $vmname
    result=$(get_port $vmname)
    echo "the vm port is $result"
}


function clone_vm_server() {
    clear
    echo -e "\t\t\tClone vm server quickly"
    echo -e "\tPlease input vmname:"
    local uuid=$(get_uuid)
    local mac=$(get_mac)
    local iso_file_path="/test.iso"
    
    read -p "vmname:" vmname
    check_name $vmname
    result=$?
    if [ $result -ne $success ] 
    then 
        echo "vmname is exists, choice other!"
        return $error
    fi

    basepath=$(cd `dirname $0`; mkdir $vmname; cd $vmname;pwd)

    
    echo "
s/<name>test<\/name>/<name>$vmname<\/name>/
s/<uuid>test<\/uuid>/<uuid>$uuid<\/uuid>/
s!file='test.iso'!file='$iso_file_path'!
s!file='sda.img'!file='$basepath/sda.img'!
s!file='sdb.img'!file='$basepath/sdb.img'!
s!file='sdc.img'!file='$basepath/sdc.img'!
s!file='sdd.img'!file='$basepath/sdd.img'!
s!mac address='52:54:00'!mac address='$mac'!
s!dev='cdrom'!dev='hd'!
    
    " > $basepath/script.sed
    sed -f $basepath/script.sed /usertest.xml > $basepath/$vmname.xml
    copy_img  $vmname
    define_vm $vmname
    start_vm $vmname
    port=$(get_port $vmname)
    echo "the vm port: $port"
    
}

while [ 1 ]
do
    error=1
    success=0
    menu
    case $option in 
    0)
        break ;;
    1)
        create_new_vm_server ;;
    2)
        restart_new_vm_server ;;
    3)
        clone_vm_server ;;
    *)
        clear
        echo "wrong selection" ;;
    esac
    echo -en "\n\n\t\tHit any key to continue"
    read -n 1 line
done
clear
