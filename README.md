<h1 align="center">System monitor applet</h1>
<p align="center">
<a href="https://github.com/prateekmedia/budgie-systemmonitor-applet/releases"><img alt="GitHub release" src="https://img.shields.io/github/v/release/prateekmedia/budgie-systemmonitor-applet?color=blueviolet"/></a> <a href="LICENSE"><img alt="License" src="https://img.shields.io/github/license/prateekmedia/budgie-systemmonitor-applet?color=blueviolet"/></a> <a href="https://github.com/prateekmedia"><img alt="Maintainer" src="https://img.shields.io/badge/Maintainer-prateekmedia-blueviolet"/></a>
</p>

System Monitor that can help you track your cpu, ram, swap, network and uptime.  
***Made with ♥️ for budgie desktop.***

![Screenshot](data/screenshot1.png)  

### Popover
![Screenshot](data/screenshot2.png) ![Screenshot](data/screenshot3.png)

---


## Dependencies
These dependencies are required if you want to [Build From Source](#Building-from-source)

**For Solus**
```
$ sudo eopkg it budgie-desktop-devel vala -c system.devel libgtop-devel
```

**For Debian/ Ubuntu based Distro**
```
$ sudo apt install budgie-core-dev meson valac 
```
**For Arch based Distro**
```
$ sudo pacman -S budgie-desktop
```

### Building from source
```
$ meson build --prefix=/usr --buildtype=plain

$ sudo ninja -C build install
```
