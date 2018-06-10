Name:           my-cfg
Version:        1.0.2
Release:        1%{?dist}
Summary:        My config

Group:          Package
License:        GPLv2
URL:            http://my-cfg
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
/etc/X11/xorg.conf.d/*.conf
/etc/yum.repos.d/*.repo
/etc/modprobe.d/*.conf

%post
systemctl enable hddtemp.service
systemctl start hddtemp.service

%changelog
* Wed Jun 5 2018 Alexander Dalshov <dalshov@gmail.com> 1.0.0
- Initial RPM release
