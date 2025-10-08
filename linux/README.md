# Linux
This module does not cover any concrete, thorough practical exercises, rather basic tasks pertaining to the following aspects of Linux system administration:

## Table of Contents
- [Linux](#linux)
  - [Table of Contents](#table-of-contents)
  - [Command Line Basics](#command-line-basics)
  - [User and Permission Management](#user-and-permission-management)
  - [System Administration and Process Management](#system-administration-and-process-management)
  - [Networking Basics and Security Concepts](#networking-basics-and-security-concepts)
  - [Troubleshooting](#troubleshooting)

## Command Line Basics

**Navigation Tasks**

Note the current directory, then change to the directory /etc and list its contents.

```bash
pwd
cd /etc
ls -la
```

**File Management Tasks**

Create a new directory named test_directory and change to this directory. Create a text file notes.txt there and copy it to a file notes_backup.txt.

```bash
mkdir test_directory
cd test_directory
touch notes.txt
cp notes.txt notes_backup.txt

```

**Editing File Contents**

Open notes.txt, insert some text lines and save the file. Then display the content of the file.

```bash
vi notes.txt
# Insert the text:
# Hello World!
cat notes.txt
```


**Clean up**

```bash
rm -r test_directory
```

## User and Permission Management

**Users and Groups**

Create a new user testuser and create a new group testgroup.

```bash
sudo useradd testuser
sudo groupadd testgroup
```

Assign testuser to the group testgroup.

```bash
sudo usermod -aG testgroup testuser
```

Verify that the user was correctly created and assigned to the group.

```bash
id testuser
```

**File Permissions**

Create a file example.txt in the home directory of testuser.

```bash
# Check the home directory of testuser
sudo cat /etc/passwd
# home directory: /home/testuser
sudo touch /home/testuser/example.txt
```

Set the file permissions so that the owner has read, write, and execute rights and the group and others have only read and execute rights.

```bash
sudo chmod 755 /home/testuser/example.txt
```

Change the owner of the file to testuser and the group to testgroup.

```bash
sudo chown testuser:testgroup /home/testuser/example.txt
```

Check the permissions.

```bash
ls -l  /home/testuser/example.txt
```

**Clean up**

```bash
sudo userdel -r testuser
sudo groupdel testgroup
```

## System Administration and Process Management

**Process Monitoring**

Display running processes.

```bash
ps aux
```

Live system monitoring using:

```bash
top
```

**Process Control**

Terminate a process.

```bash
# Determine the PID of the previously run top command
ps aux | grep top
# Terminate the process
kill 8476
```

Change the priority of a process.

```bash
$ sudo nice -n -5 top
# determine the PID of top process
$ ps aux | grep top 
$ sudo renice +10 8528
8528 (process ID) old priority -5, new priority 10
```

**Log Analysis**

Observe the logs.

```bash
tail -f /var/log/syslog
```

Filter error messages with grep.

```bash
tail -f /var/log/syslog | grep errror
```

**Package Management**

Update the system.

```bash
sudo apt update && sudo apt upgrade
```
Install curl and htop.

```bash
sudo apt install curl && sudo apt install htop
```

## Networking Basics and Security Concepts

Display your current interfaces and IP addresses.

```bash
ip addr show
```

Check the reachability of an external host.

```bash
ping google.com
```

Show open ports.

```bash
ss -tuln
```

Test-block a port that is not needed.

```bash
sudo iptables -A INPUT -p tcp --dport 8080 -j DROP
```

Check if the rule is active.

```bash
$ sudo iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
DROP       tcp  --  anywhere             anywhere             tcp dpt:http-alt
```

Delete the rule again.

```bash
sudo iptables -D INPUT -p tcp --dport 8080 -j DROP
```

Explicitly allow SSH access (port 22).

```bash
sudo ufw allow 22
```

Activate the firewall.

```bash
sudo ufw enable
```

Check the active rules.

```bash
$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22                         ALLOW       Anywhere
22 (v6)                    ALLOW       Anywhere (v6)
```

## Troubleshooting

**Log Analysis**

Observe running logs.

```bash
tail -f /var/log/syslog
```

Filter specifically for errors.

```bash
grep -i fail /var/log/syslog
```

**Error Diagnosis**

Stop a service.

```bash
sudo systemctl stop ssh
```
Check error sources.

```bash
systemctl status ssh
journalctl -xe
```

Create a backup of /etc directory.

```bash
sudo tar -czf etc-backup.tar.gz /etc/
```

Check the archive.

```bash
tar -tf etc-backup.tar.gz
```