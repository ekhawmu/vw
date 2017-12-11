#!/bin/bash -ex
rm /etc/udev/rules.d/70-persistent-net.rules
echo "export http_proxy=http://proxy.ir.intel.com:911" >> /etc/environment
echo "export HTTP_PROXY=http://proxy.ir.intel.com:911" >> /etc/environment
echo "export https_proxy=https://proxy.ir.intel.com:911" >> /etc/environment
echo "export ftp_proxy=http://proxy.ir.intel.com:911" >> /etc/environment
echo "export no_proxy=$ipaddr" >> /etc/environment
echo "export NO_PROXY=$ipaddr" >> /etc/environment
source /etc/environment

echo "Running boot script to enable ingress port in promisc mode"
echo $ipaddr
dhclient
#ifname=$(ifconfig | grep -B1 "inet addr:"$ipaddr | awk '$1!="inet" && $1!="--" {print $1}')
ifname=$(ifconfig | grep -B1 $ipaddr | grep -o "^\w*")
ip link set $ifname promisc on
ethtool -K $ifname gro off
ethtool -K $ifname lro off

ifname2=$(ifconfig | grep -B1 $ipaddr2 | grep -o "^\w*")
ip link set $ifname2 promisc on
ethtool -K $ifname2 gro off
ethtool -K $ifname2 lro off

ifconfig

#/etc/dpi/runMe.sh $ifname:$ifname2 &
/etc/dpi/ndpiReader -i $ifname -p /etc/dpi/protos.txt &  /etc/dpi/reader $ifname2 &
