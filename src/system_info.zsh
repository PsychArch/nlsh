# System information collector

nlsh-get-system-info() {
    local os=$(uname -s)
    local is_root=0
    [[ $UID -eq 0 ]] && is_root=1
    
    local distro=""
    if [[ -f /etc/os-release ]]; then
        distro=$(source /etc/os-release && echo $NAME)
    fi
    
    echo "OS: $os Distribution: $distro is_root: $is_root"
} 