Name:           my-cfg
Version:        1.0.0
Release:        1%{?dist}
Summary:

Group:
License:        GPLv2
URL:
Source0: my-cfg-1.0.0.tar.gz

BuildRequires:
Requires: sensors brightnessctl network-manager-applet redshift-gtk lxpolkit xscreensaver

%description
Set up usual packets for macbook

%prep
%setup -q -n

%install
rm -rf $RPM_BUILD_ROOT
cp /etc $RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc

%changelog
* Wed Jun 5 2018 Alexander Dalshov <dalshov@gmail.com> 1.0.0
- Initial RPM release
