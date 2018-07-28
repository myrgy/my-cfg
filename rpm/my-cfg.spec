Name:           my-cfg
Version:        1.0.6
Release:        1%{?dist}
Summary:        My config

Group:          Package
License:        GPLv2
URL:            https://github.com/myrgy/my-cfg
Source0:        my-cfg-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-root
BuildArch:      noarch

Requires: lm_sensors, brightnessctl, network-manager-applet, redshift-gtk, lxpolkit,
Requires: xscreensaver, fish, stow, hddtemp, util-linux-user, powertop, kbdd, tlp, smartmontools
Requires: neofetch, xdg-utils, glibc, nemo

%define _binaries_in_noarch_packages_terminate_build   0

%description
Set up usual packets for macbook

%global debug_package %{nil}

%{?systemd_requires}
BuildRequires: systemd

%prep
%setup -q -n %{name}-%{version}

%build
exit 0

%install
make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
/boot/efi/EFI/fedora/*.efi
/etc/X11/xorg.conf.d/*.conf
/etc/yum.repos.d/*.repo
/etc/modprobe.d/*.conf
/etc/udev/rules.d/*.rules
/etc/grub.d/*
/etc/systemd/system/*.service
/sbin/*
/usr/lib/systemd/system-preset/*.preset

%preun
%systemd_preun hddtemp.service
%systemd_preun macbook_fix.service
%systemd_preun nvidia-disable.service

%post
gpu-switch -i
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
%systemd_post hddtemp.service
%systemd_post nvidia-disable.service
%systemd_post macbook_fix.service
systemctl is-enabled nvidia-disable.service
systemctl enable nvidia-disable.service

%changelog
* Fri Jun 27 2018 Alexander Dalshov <dalshov@gmail.com> 1.1.4
- Disable nvidia on resume

* Fri Jun 15 2018 Alexander Dalshov <dalshov@gmail.com> 1.0.5
- Nvidia power management
- CPU ACPI issue workaround

* Fri Jun 15 2018 Alexander Dalshov <dalshov@gmail.com> 1.0.4
- Xorg config
- apple-set-os (enable intel gpu)
- add gpu-switch

* Tue Jun 5 2018 Alexander Dalshov <dalshov@gmail.com> 1.0.0
- Initial RPM release
