#! /bin/bash

# check_running_vms is a Nagios plugin to check number of running VMs on KVM or XEN environment
#
# Copyright (c) 2018, Mnheia <mnheia@gmail.com>
#
# This module is free software; you can redistribute it and/or modify it
# under the terms of GNU general public license (gpl) version 3.
# See the LICENSE file for details.

# Exit codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Get desired number of VMs
desired_vms=$1
#echo $desired_vms

if [ -x "$(command -v virsh)" ]; then
        running_vms=$(virsh list --all | egrep "running|idle" | grep -v Domain-0 | wc -l)
elif [ -x "$(command -v xe)" ]; then
        running_vms=$(xe vm-list | egrep "running|idle" | wc -l)
else
        echo "Error: virsh or xe is not installed."
        exit 1
fi

#echo $running_vms

if [[ $running_vms -lt $desired_vms || $running_vms == 0  ]]; then
        echo "CRITICAL: Number of running VMs is $running_vms - less than desired |vms=$running_vms"
        exit $STATE_CRITICAL
elif [[ $running_vms -gt $desired_vms ]]; then
        echo "WARNING: Number of running VMs is $running_vms more than desired |vms=$running_vms"
        exit $STATE_WARNING
else
        echo "INFO: Number of running VMs is $running_vms - exactly as desired |vms=$running_vms"
        exit $STATE_OK
fi
