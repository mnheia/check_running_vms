(c) Mitja Sovec

# check_running_vms
A Nagios plugin to check number of running VMs on KVM or XEN environment

# Example
## Server Side
```
define service {
        service_description RUNNING_VMS
        use service-name
        host_name hostname
        check_command check_nrpe!5666!check_running_vms
}
```

## Client Side
```
command[check_running_vms]=sudo /usr/lib64/nagios/plugins/check_running_vms.sh 4
```
Where number of running VMs should be 4 - replace number with the number of VMs that should be running.

# Bugs
Please report any bugs or feature requests through the web interface at https://github.com/mnheia/check_running_vms/issues
