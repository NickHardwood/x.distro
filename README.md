![Launchers](doc/images/launchers.png)

# x.Distro Docker and Windows Subsystem for Linux Distributions
A General Purpose Docker & WSL Base Distribution Builder, Installer & Launcher

## Continuous integration

| Build server                | Platform     | Build Status Branch - Master                                                                                                                                        | Build Status Branch - DMZ                                                                                                                                           |
|-----------------------------|--------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AppVeyor                    | Windows      | [![Build Status](https://ci.appveyor.com/api/projects/status/7a33242t19k5dv9b/branch/master?svg=true)](https://ci.appveyor.com/project/mrpastewart/xenta-template/branch/master)   | [![Build Status](https://ci.appveyor.com/api/projects/status/7a33242t19k5dv9b/branch/dmz?svg=true)](https://ci.appveyor.com/project/mrpastewart/xenta-template/branch/dmz)      |
| Travis                      | Linux / OS X | [![Build Status](https://travis-ci.org/xentafx/xenta.template.svg?branch=master)](https://travis-ci.org/xentafx/xenta.template)                                     | [![Build Status](https://travis-ci.org/xentafx/xenta.template.svg?branch=dmz)](https://travis-ci.org/xentafx/xenta.template)                                        |
| GitLab                      | Windows      | [![Build Status](https://gitlab.com/xentafx/xenta.template/badges/master/pipeline.svg)](https://gitlab.com/xentafx/xenta.template/commits/master)                   | [![Build Status](https://gitlab.com/xentafx/xenta.template/badges/dmz/pipeline.svg)](https://gitlab.com/xentafx/xenta.template/commits/dmz) &nbsp;                  |

### Preview of project logo
![Launchers](doc/images/logo.png)

## Table of Contents

- [Introduction](#introduction)
    - [Project Goals](#project-goals)
    - [OSS Projects Used](#oss-projects-used)
    - [Project Structure](#project-structure)
- [Installation](#installation)
    - [Requirements](#requirements)
    - [Deployment](#deployment)
    - [Developers](#developers)
- [Developers Setup](#development-setup)
    - [Base Setup](#base-setup)
    - [Addon Setup](#addon-setup)
    - [Extension Packs](#extension-packs)
    - [Extending Psito](#extending-psito)
- [Configurations](#configurations)
    - [IDE Packages](#ide-packages)
    - [Scripts](#scripts)
    - [Config Files](#config-files)
    - [Project Sources](#project-sources)
- [Contributions](#contributions)
- [License](#license)
- [Links](#links)

## Introduction

The pupose of this project is to provide developers with an easy way to leverage Microsoft's Windows Subsystem for Linux (WSL). x.Distro allows building, installing and launching any GNU/Linux distribution userspace in WSL using RootFS tarballs, :package: Docker Containers :whale: or ISO files. :cd:

x.Distro also allows using the same RootFS to build base Docker images effectively providing a single development environment to maintain base WSL and Docker filesystems.

### Project Goals

The goal of this project is to provide developers with the ability to just download a distribution, unzip and run it or to execute standard Docker commands to duplicate the same environment inside a container. This will allow side by side deployment of Linux systems and Docker containers with fast turn around times for developing in WSL and Docker.

### OSS Projects Used

The x.Distro Project attempts to combine the relevant open source projects that provide meaningful usage within our project scope. The following OSS projects have been chosen for inspiration or inclusion.

1. [WSL-DistroLauncher](https://github.com/yuk7/WSL-DistroLauncher.git)
2. [WSL-Distibution-Switcher](https://github.com/RoliSoft/WSL-Distribution-Switcher)
3. [LxRunOffline](https://github.com/DDoSolitary/LxRunOffline.git)
4. [WSLInstall](https://github.com/Biswa96/WSLInstall)
5. [CPP-Basic_Project-Template](https://github.com/arreisGit/cpp-basic-project-template)
6. [CPP-Boilerplate](https://github.com/bamorim/cpp-boilerplate)
7. [CXX-Boilerplate](https://github.com/tijme/cxx-boilerplate)
8. [Docker-BaseImage](https://github.com/sicz/docker-baseimage)

**This list is a moving target and may be updated as the project moves forward to add or delete projects as the needs become clearer.**

### Project Structure

Downloading the source distribution from Github creates the following file structure;
````
{root}
  +-- base
  +-- config
  +-- doc
  +-- include
  +-- scripts
  +-- spike
  +-- src
  |    +-- main.c
  +-- test
  +-- <.editorconfig>>
  +-- <.gitattributes>
  +-- <.gitignore>
  +-- <makefile>
  +-- <readme.md>
````

Downloading the release distribution from Github creates the following file structure;
````
{root}
  +-- rootfs.tar.gz
  +-- rootfs
  +-- <ubuntu.exe>
  +-- <license.txt>
  +-- <versions.txt>
````

## Installation

### Requirements

### Deployment

### Developers

## Developers Setup

### Base Setup

### Addon Setup

### Extension Packs

### Extending Psito

## Configurations

### IDE Packages

### Scripts

### Config Files

### Project Sources

## Contributions

## License

Copyright 2000 - 2017 Xenta SocialLabs

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and
limitations under the License.

## Links
