#!/bin/bash
locationDirs="$(ls -d */ | grep -v "startvpn-sh")" &&
    dirsNum=$(echo "$locationDirs" | wc -w) &&
    locationArray=($locationDirs)

declare stunnel_pid
declare openvpn_pid

print_dirs(){
    for((i=0;i<dirsNum;++i)) do
        printf "\t%d-%s\n" $i ${locationArray[i]%/}
    done
}

start_vpn(){
    cd "$1"
    sslfile=$(find -type f -name "*.ssl" | head -n 1) 
    ovpnfile=$(find -type f -name "*.ovpn" | head -n 1)

    if [[ ( -n "$sslfile" ) && ( -n "$ovpnfile" ) ]]; then
        $(stunnel "$sslfile") &
        stunnel_pid=$!
        $(openvpn "$ovpnfile") &
        openvpn_pid=$!
        wait $stunnel_pid $openvpn_pid
    else
        if [[ ! -n "$sslfile" ]]; then
            printf "No .ssl file in %s\n" "$1" >&2
        fi
        if [[ ! -n "$ovpnfile" ]]; then
            printf "No .ovpn file in %s\n" "$1" >&2
        fi
        exit
    fi
}

if [[ "$EUID" > 0 ]]; then
    echo "Please run as root" >&2
    exit
else
    while true; do
        echo -e "\nChoose a VPN Server:\n"
        print_dirs
        echo -e "\n\tOr input 'q' to exit"
        read -p "Enter selection > "

        if [[ -n "$REPLY" ]]; then
            if [[ "$REPLY" == 'q' ]]; then
                echo "Exiting..."
                exit
            elif [[ ("$REPLY" -ge 0) && ("$REPLY" -lt ${#locationArray[@]}) ]]; then
                chosen=${locationArray[$REPLY]%/}
                start_vpn $chosen
                exit
            fi
        fi
    done
fi

trap exit_signal SIGINT SIGTERM
exit_signal(){
    if [[ -n $stunnel_pid ]]; do kill $stunnel_pid SIGINT done
    if [[ -n $openvpn_pid ]]; do kill $openvpn_pid SIGINT done
    exit
}
