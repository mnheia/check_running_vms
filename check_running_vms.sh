#!/bin/bash

# check_running_vms is a Nagios plugin to check number of running VMs on KVM or XEN environment
#
# Copyright (c) 2018, Mnheia <mnheia@gmail.com>
#
# This module is free software; you can redistribute it and/or modify it
# under the terms of GNU general public license (gpl) version 3.
# See the LICENSE file for details.

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

print_usage()
{
        echo "Usage: $(basename "$0") <desired_running_vms>"
}

desired_vms="${1:-}"

if ! [[ "$desired_vms" =~ ^[0-9]+$ ]]; then
        echo "UNKNOWN: desired_running_vms must be a non-negative integer."
        print_usage
        exit $STATE_UNKNOWN
fi

if command -v virsh >/dev/null 2>&1; then
        if ! vm_output=$(virsh list --all 2>&1); then
                echo "UNKNOWN: virsh failed: $vm_output"
                exit $STATE_UNKNOWN
        fi

        running_vms=$(printf '%s\n' "$vm_output" |
                awk 'NR > 2 && ($3 == "running" || $3 == "idle") && $2 != "Domain-0" { count++ } END { print count + 0 }')
elif command -v xe >/dev/null 2>&1; then
        if ! vm_output=$(xe vm-list 2>&1); then
                echo "UNKNOWN: xe failed: $vm_output"
                exit $STATE_UNKNOWN
        fi

        running_vms=$(printf '%s\n' "$vm_output" |
                awk '/power-state.*:[[:space:]]*(running|idle)[[:space:]]*$/ { count++ } END { print count + 0 }')
else
        echo "UNKNOWN: virsh or xe is not installed."
        exit $STATE_UNKNOWN
fi

if (( running_vms < desired_vms || running_vms == 0 )); then
        echo "CRITICAL: Number of running VMs is $running_vms - less than desired |vms=$running_vms"
        exit $STATE_CRITICAL
elif (( running_vms > desired_vms )); then
        echo "WARNING: Number of running VMs is $running_vms - more than desired |vms=$running_vms"
        exit $STATE_WARNING
else
        echo "OK: Number of running VMs is $running_vms - exactly as desired |vms=$running_vms"
        exit $STATE_OK
fi
