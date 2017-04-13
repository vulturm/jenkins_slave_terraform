[//]: # (Describe the project's purpose.)

## jenkins_slave_terraform
This Dockerfile is used to create a docker image for jenkins slave that will execute the CI plan.<br />
[Docker image][9] created using this project can used with: `docker pull xxmitsu/jenkins_slave_terraform`.

[//]: # (List Project dependencie.)

## Dependencies
|Dependency |Comments |
|:---------|:----------|
| `docker` | `Dockerfile` developed and tested using `docker v1.12.6` |
| `Jenkins` | Resulted container integrated with `Jenkins Master ver. 2.32.2` |

[//]: # (Identify software stack provided inside the container.)
## Software stack provided inside the container
* [OpenSSH][1] - The SSH Daemon is used to facilitate the connectivity between jenkins master and the slave container.
* [GNU Wget][2] - Used to facilitate the provisioning of the [terraform][3] install archive.
* [Unzip Utility][4] - Used to facilitate the decompression of the [terraform][3] install archive.
* [OpenJDK][6] - Required by the `Jenkins` itself.
* [Terraform][3] - The tool itself that will be used for the configuration testing.
* [Git][7] - For managing `SCM repositories`.
* [GNU Bash][8] - Required for jenkins integration and plan syntax interpreter.

---
## **Usage**

[//]: # (Identify the commands -- that are meant to be called by a user.)

## Command used to build the image:
```bash
docker build -t jenkinsimageterraform .
```

## Jenkins configuration
Consult Jenkins - Docker Plugin [Documentation -> Configuration section][5] for more details about how Jenkins Slave inside docker container could be integrated.

---
## **License and Authors**

Maintainer:       'Mihai Vultur'<br>
License:          'GPL v3'<br>

[1]: https://www.openssh.com/ "OpenSSH"
[2]: https://www.gnu.org/software/wget/ "Wget"
[3]: http://www.terraform.io/ "Terraform"
[4]: https://linux.die.net/man/1/unzip "Unzip"
[5]: https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin#DockerPlugin-Configuration "Jenkins - Docker Plugin"
[6]: http://openjdk.java.net/ "OpenJDK - a free and open source implementation of the Java Platform"
[7]: https://git-scm.com/ "Git - a free and open source distributed version control system"
[8]: https://www.gnu.org/software/bash/ "GNU/Bash - an sh-compatible shell"
[9]: https://hub.docker.com/r/xxmitsu/jenkins_slave_terraform/ "Docker image for jenkins slave that will execute the CI plan for terraform."
