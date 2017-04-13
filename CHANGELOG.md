Copyright (c) 2017-Preset Mihai Vultur, All Rights Reserved.

CHANGELOG
=========
## jenkins_slave_terraform

This file is used to list changes made in each version of the `jenkins_slave_terraform` project.

### Version 1.0.0
Initial implementation of the Dockerfile that will create jenkins slave image.
Installs the following:
* OpenSSH
* GNU Wget
* Unzip Utility
* OpenJDK
* Terraform

Creates jenkins user and adds public key to be able to connect from jenkins master.
