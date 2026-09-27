Copyright (c) 2018, Mnheia <mnheia@gmail.com>

# check_running_vms
A Nagios plugin to check the number of running VMs in KVM or XEN environments.

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

The final argument is the expected number of running VMs. In this example, exactly 4 VMs should be running.

# Requirements
- Bash
- awk
- virsh or xe

# Bugs
Please report any bugs or feature requests through the web interface at https://github.com/mnheia/check_running_vms/issues
