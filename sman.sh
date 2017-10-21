#!/bin/bash
# nilfs2 snapshot manager by Istvan Kosztik 2017-


dev="/dev/sda2"
mp="/tmp"

_1=`lscp -s|cut -d' ' -f 30-40| tail -n +2 | head -1|sed 's/ //g'`
_2=`lscp -s|cut -d' ' -f 30-40| tail -n +3 | head -1|sed 's/ //g'`
_3=`lscp -s|cut -d' ' -f 30-40| tail -n +4 | head -1|sed 's/ //g'`
_4=`lscp -s|cut -d' ' -f 30-40| tail -n +5 | head -1|sed 's/ //g'`
_5=`lscp -s|cut -d' ' -f 30-40| tail -n +6 | head -1|sed 's/ //g'`
_6=`lscp -s|cut -d' ' -f 30-40| tail -n +7 | head -1|sed 's/ //g'`

echo $_1

_d1=`lscp -s|cut -d' ' -f 19-23| tail -n +2 | head -1`
_d2=`lscp -s|cut -d' ' -f 19-23| tail -n +3 | head -1`
_d3=`lscp -s|cut -d' ' -f 19-23| tail -n +4 | head -1`
_d4=`lscp -s|cut -d' ' -f 19-23| tail -n +5 | head -1`
_d5=`lscp -s|cut -d' ' -f 19-23| tail -n +6 | head -1`
_d6=`lscp -s|cut -d' ' -f 19-23| tail -n +7 | head -1`


function compare_1to2 {
    _e=`echo "100-(($_1*100)/$_2)"|bc`
    echo $_e% --- $_d1 - $_d2
}

function compare_2to3 {
    _e=`echo "100-(($_2*100)/$_3)"|bc`
    echo $_e% --- $_d2 - $_d3
}

function compare_3to4 {
    _e=`echo "100-(($_3*100)/$_4)"|bc`
    echo $_e% --- $_d3 - $_d4
}

function compare_4to5 {
    _e=`echo "100-(($_4*100)/$_5)"|bc`
    echo $_e% --- $_d4 - $_d5
}

function compare_5to6 {
    _e=`echo "100-(($_5*100)/$_6)"|bc`
    echo $_e% --- $_d5 - $_d6
}


function make_ss {
    numberof_ss=`lscp -s | wc -l`
    for i in `seq 1 $(( numberof_ss - 6  ))`; do
	    #ss=`lscp -r -s|  tail -1| cut -d" " -f1-19|sed 's/ //g'`
	    ss=`lscp -r -s|  tail -1| awk -F"ss" '{print $1}'|awk -F"-" '{print $1}'|sed 's/.\{4\}$//'| sed 's/ //g'`
	    #echo $ss le
	    umount.nilfs2 $mp/snapshot$ss
	    rm -rf $mp/snapshot$ss
	    chcp cp $ss
            rmcp $ss
    done
    
    mkcp -ss
    #lastSS=`lscp -s | tail -1| cut -d" " -f1-19|sed 's/ //g'`
    lastSS=`lscp -s|  tail -1| awk -F"ss" '{print $1}'|awk -F"-" '{print $1}'|sed 's/.\{4\}$//'| sed 's/ //g'`
    mkdir $mp/snapshot$lastSS
    #echo $lastSS fel
    mount -t nilfs2 -r -o cp=$lastSS $dev $mp/snapshot$lastSS

}

function compareall {

    compare_1to2
    compare_2to3
    compare_3to4
    compare_4to5
    compare_5to6

}



case "$1" in
        make)
            make_ss
            ;;
         
        compareall)
            compareall
            ;;
        condrestart)
            if test "x`pidof anacron`" != x; then
                stop
                start
            fi
            ;;
         
        *)
            echo $"Usage: $0 {make|compareall|compare2}"
            exit 1
 
esac

# mount -t nilfs2 -r -o cp=2 /dev/sdb1 /snapshot
