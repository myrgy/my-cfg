Name:           my-cfg
Version:        1.0.4
Release:        1%{?dist}
Summary:        My config

Group:          Package
License:        GPLv2
URL:            https://github.com/myrgy/my-cfg
Source0:        my-cfg-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-root
BuildArch:      noarch

Requires: lm_sensors, brightnessctl, network-manager-applet, redshift-gtk, lxpolkit, xscreensaver, fish, stow, hddtemp, util-linux-user

%description
Set up usual packets for macbook

%global debug_package %{nil}

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
/etc/grub.d/*.conf
/sbin/*.sh

%post
systemctl enable hddtemp.service
systemctl start hddtemp.service
gpu-switch -i
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

%changelog
* Wed Jun 5 2018 Alexander Dalshov <dalshov@gmail.com> 1.0.4
- Xorg config
- apple-set-os (enable intel gpu)
- add gpu-switch
* Wed Jun 5 2018 Alexander Dalshov <dalshov@gmail.com> 1.0.0
- Initial RPM release
