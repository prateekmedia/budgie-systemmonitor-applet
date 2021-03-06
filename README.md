<p align="center"><a href="#Why-this-fork"><img src="https://upload.wikimedia.org/wikipedia/commons/6/64/GNOME_System_Monitor_icon_2019.svg"/></a></p>
<h1 align="center">System monitor applet</h1>
<p align="center">
<a href="https://github.com/prateekmedia/budgie-systemmonitor-applet/releases"><img alt="GitHub release" src="https://img.shields.io/github/v/release/prateekmedia/budgie-systemmonitor-applet?color=blueviolet"/></a> <a href="LICENSE"><img alt="License" src="https://img.shields.io/github/license/prateekmedia/budgie-systemmonitor-applet?color=blueviolet"/></a> <a href="https://github.com/prateekmedia"><img alt="Maintainer" src="https://img.shields.io/badge/Maintainer-prateekmedia-blueviolet"/></a>
</p>

System Monitor that can help you track your cpu, ram, swap, network and uptime.  
***Made with ♥️ for budgie desktop.***

Fork of [Dirli/budgie-sys-monitor-applet](https://github.com/Dirli/budgie-sys-monitor-applet)

![Screenshot](data/screenshot1.png)  

### Popover
![Screenshot](data/screenshot2.png) ![Screenshot](data/screenshot3.png)

---

### Why this fork?
+ Orignal Project is abandoned and will not receive any update

### Ok, So what's new?
+ Add Icons for prefix
+ Options to Add Netspeed related things to Panel (See Screenshot)
+ Improved code

---

### Direct Install

**For Debian/ Ubuntu based Distro**
```
sudo add-apt-repository ppa:ubuntubudgie/backports
sudo apt install budgie-sys-monitor-applet
```
---

### Dependencies
These dependencies are required if you want to [Build From Source](#Building-from-source)

**For Solus**
```
$ sudo eopkg it budgie-desktop-devel vala -c system.devel libgee-devel libgtop-devel
```

**For Debian/ Ubuntu based Distro**
```
$ sudo apt install budgie-core-dev libgee-0.8-dev libgtop-2.0 meson valac 
```
**For Arch based Distro**
```
$ sudo pacman -S budgie-desktop libgee libgtop
```

---

### Building from source
```
$ meson build --prefix=/usr --buildtype=plain

$ sudo ninja -C build install
```
