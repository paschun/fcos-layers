%define module_version $(bcachefs version)
%define kernel_version $(cat /kernel-version.txt)
%define rpm_release 1

Name:           bcachefs-kmod
Version:        %{module_version}-%{kernel_version}
# ?dist puts .fc43
Release:        %{rpm_release}%{?dist}
Summary:        bcachefs kernel module

License:        GPL
Source0:        %{_sourcedir}/bcachefs.ko.xz

BuildArch:      $(cat /arch.txt)
Requires:       kernel-uname-r = %{kernel_version}

# mandatory
%description
bcachefs v%{module_version} kernel module for kernel %{kernel_version}.

%install
install -d %{buildroot}/usr/lib/modules/%{kernel_version}/extra/
install -m 0755 %{SOURCE0} %{buildroot}/usr/lib/modules/%{kernel_version}/extra/bcachefs.ko.xz

install -d %{buildroot}/etc/modules-load.d/
echo "bcachefs" > %{buildroot}/etc/modules-load.d/bcachefs.conf

%post
depmod -a %{kernel_version}

%files
%defattr(644,root,root,755)
/usr/lib/modules/%{kernel_version}/extra/bcachefs.ko.xz
/etc/modules-load.d/bcachefs.conf
