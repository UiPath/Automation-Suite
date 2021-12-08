service_exists() {
    local n=$1
    if [[ $(systemctl list-units --all -t service --full --no-legend "$n.service" | cut -f1 -d' ') == $n.service ]]; then
        return 0
    else
        return 1
    fi
}
if service_exists rke2-server; then
  systemctl stop rke2-server
  systemctl disable rke2-server
fi
if service_exists rke2-agent; then
  systemctl stop rke2-agent
  systemctl disable rke2-agent
fi
if [ -e /usr/bin/rke2-killall.sh ]
then
    echo "Running rke2-killall.sh"
    /usr/bin/rke2-killall.sh > /dev/null
else
    echo "File not found: rke2-killall.sh"
fi
if [ -e /usr/bin/rke2-uninstall.sh ]
then
    echo "Running rke2-uninstall.sh"
    /usr/bin/rke2-uninstall.sh > /dev/null
else
    echo "File not found: rke2-uninstall.sh"
fi

rm -rfv /etc/rancher/ > /dev/null
rm -rfv /var/lib/rancher/ > /dev/null
rm -rfv /var/lib/rook/ > /dev/null
rm -rfv /var/lib/longhorn/ > /dev/null
findmnt -lo target | grep /var/lib/kubelet/ | xargs umount -l -f
rm -rfv /var/lib/kubelet/ > /dev/null
rm -rfv /datadisk/* > /dev/null
rm -rfv ~/.uipath/* > /dev/null
mkdir -p /var/lib/rancher/rke2/server/db/ && mount -a
rm -rfv /var/lib/rancher/rke2/server/db/* > /dev/null
echo "Uninstall RKE complete."
