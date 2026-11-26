# Package post release commit to ensure builds on x86
# https://github.com/gambit/gambit/issues/1064
%global commit        5167159e75e27883a75c7df9aa36b38cd1475a70
%global commitdate    20261113
%global shortcommit   %(c=%{commit}; echo ${c:0:7})

Name:           gambit-c
Version:        4.9.8^%{commitdate}git%{shortcommit}
Release:        1%{?dist}
Summary:        Scheme programming system

License:        Apache-2.0 OR LGPL-2.1-only
URL:            http://gambitscheme.org/
%global _dirname gambit-v%(echo %{version} | sed -e 's/\\./_/g' | cut -d^ -f1 )-devel
Source0:        https://github.com/gambit/gambit/archive/%{commit}/gambit-%{shortcommit}.tar.gz
#Source1:        gambit-init.el

BuildRequires:  gcc
BuildRequires:  gcc-c++
BuildRequires:  emacs
BuildRequires:  make
BuildRequires:  openssl-devel
Requires:       gcc
Requires:       emacs-filesystem >= %{_emacs_version}


%description
Gambit-C includes a Scheme interpreter and a Scheme compiler which can
be used to build standalone executables.  Because the compiler
generates portable C code it is fairly easy to port to any platform
with a decent C compiler.

The Gambit-C system conforms to the R4RS, R5RS and IEEE Scheme
standards.  The full numeric tower is implemented, including: infinite
precision integers (bignums), rationals, inexact reals (floating point
numbers), and complex numbers.


%package        doc
Summary:        Documentation for %{name}

BuildArch:      noarch
Requires:       %{name} = %{version}-%{release}
# switch to noarch
Obsoletes:      gambit-c-doc < %{version}-%{release}

%description    doc
Gambit-C includes a Scheme interpreter and a Scheme compiler which can
be used to build standalone executables.  Because the compiler
generates portable C code it is fairly easy to port to any platform
with a decent C compiler.

This package contains the Gambit-C user manual in HTML and PDF formats.


%prep
%autosetup -n gambit-%{commit} 
# Gambit tries to do a git update-index if a git repo is detected
rm -rf .git
# Remove binary
rm prebuilt/windows/binpatch.exe

# Permission fixes
chmod -x lib/*.{c,h}


%build

%ifarch ppc64le
%configure --enable-dynamic-clib \
           --enable-single-host \
           --enable-openssl \
           --enable-cplusplus=yes \
           --enable-versioned-shared-libs \
           --with-x \
           --bindir=%{_libdir}/%{name}/bin \
           --libdir=%{_libdir}/%{name}
%elifarch %{ix86}
%configure --enable-dynamic-clib \
           --disable-single-host \
           --enable-openssl \
           --enable-cplusplus=yes \
           --enable-versioned-shared-libs \
           --with-x \
           --bindir=%{_libdir}/%{name}/bin \
           --libdir=%{_libdir}/%{name}
%else
%configure --enable-trust-c-tco \
           --enable-dynamic-clib \
           --enable-single-host \
           --enable-openssl \
           --enable-cplusplus=yes \
           --enable-versioned-shared-libs \
           --with-x \
	   --bindir=%{_libdir}/%{name}/bin \
           --libdir=%{_libdir}/%{name}
%endif

%ifarch %{ix86}
make
%else
make %{?_smp_mflags}
%endif
	   
# Compile emacs module
(cd misc && %{_emacs_bytecompile} gambit.el)


%check
make check


%install
make install DESTDIR=%{buildroot}
mkdir -p %{buildroot}%{_bindir}
for i in gsc gsi
do
  ln -sf ../%{_lib}/%{name}/bin/$i %{buildroot}%{_bindir}/$i
done
cat > %{buildroot}%{_bindir}/gsix <<EOF
#!/bin/sh
%{_libdir}/%{name}/bin/six $@
EOF
chmod +x %{buildroot}%{_bindir}/gsix

# Remove duplicate docs
rm -rf %{buildroot}%{_prefix}/doc

# Emacs mode files
mkdir -p %{buildroot}%{_emacs_sitestartdir}
cp -p misc/gambit.elc %{buildroot}%{_emacs_sitelispdir}
cp -p misc/packaging/fedora/gambit-init.el %{buildroot}%{_emacs_sitestartdir}

# Link static libs
(cd %{buildroot}%{_libdir} && ln -s %{name}/*.a .)


%files
%license LGPL.txt LICENSE-2.0.txt
%doc README
%{_bindir}/gsc
%{_bindir}/gsi
%{_bindir}/gsix
%{_includedir}/gambit.h
%{_includedir}/gambit-not409008.h
%{_mandir}/man1/gsi.1*
%{_libdir}/%{name}/
%{_libdir}/libgambit.a
%{_libdir}/libgambitgsc.a
%{_libdir}/libgambitgsi.a
%{_emacs_sitelispdir}/gambit.el
%{_emacs_sitelispdir}/gambit.elc
%{_emacs_sitestartdir}/gambit-init.el


%files doc
%doc doc/gambit.html doc/gambit.pdf
%doc examples
%{_infodir}/gambit.info*


%changelog
* Sun Nov 08 2026 Benson Muite <fed500@fedoraproject.org> - 4.9.8-1
- Update to release 4.9.8

* Wed Jul 15 2026 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.7-4
- Rebuilt for https://fedoraproject.org/wiki/Fedora_45_Mass_Rebuild

* Fri Jan 16 2026 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.7-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_44_Mass_Rebuild

* Wed Jul 23 2025 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.7-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_43_Mass_Rebuild

* Thu Jul 17 2025 Benson Muite <fed500@fedoraproject.org> - 4.9.7-1
- Update to release 4.9.7

* Tue Apr 08 2025 Tim Landscheidt <tim@tim-landscheidt.de> - 4.9.6-2
- Remove obsolete requirements for %%post/%%preun scriptlets

* Fri Mar 14 2025 Benson Muite <fed500@fedoraproject.org> - 4.9.6-1
- Update to release 4.9.6

* Thu Jan 16 2025 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.3-15
- Rebuilt for https://fedoraproject.org/wiki/Fedora_42_Mass_Rebuild

* Wed Aug 28 2024 Miroslav Suchý <msuchy@redhat.com> - 4.9.3-14
- convert license to SPDX

* Wed Jul 17 2024 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.3-13
- Rebuilt for https://fedoraproject.org/wiki/Fedora_41_Mass_Rebuild

* Wed Jan 24 2024 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.3-12
- Rebuilt for https://fedoraproject.org/wiki/Fedora_40_Mass_Rebuild

* Fri Jan 19 2024 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.3-11
- Rebuilt for https://fedoraproject.org/wiki/Fedora_40_Mass_Rebuild

* Wed Jul 19 2023 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.3-10
- Rebuilt for https://fedoraproject.org/wiki/Fedora_39_Mass_Rebuild

* Thu Jan 19 2023 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.3-9
- Rebuilt for https://fedoraproject.org/wiki/Fedora_38_Mass_Rebuild

* Thu Jul 21 2022 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.3-8
- Rebuilt for https://fedoraproject.org/wiki/Fedora_37_Mass_Rebuild

* Thu Jan 20 2022 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.3-7
- Rebuilt for https://fedoraproject.org/wiki/Fedora_36_Mass_Rebuild

* Wed Jul 21 2021 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.3-6
- Rebuilt for https://fedoraproject.org/wiki/Fedora_35_Mass_Rebuild

* Tue Jan 26 2021 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.3-5
- Rebuilt for https://fedoraproject.org/wiki/Fedora_34_Mass_Rebuild

* Mon Jul 27 2020 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.3-4
- Rebuilt for https://fedoraproject.org/wiki/Fedora_33_Mass_Rebuild

* Tue Jan 28 2020 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.3-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_32_Mass_Rebuild

* Thu Jul 25 2019 Fedora Release Engineering <releng@fedoraproject.org> - 4.9.3-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_31_Mass_Rebuild

* Mon May 27 2019 Michel Alexandre Salim <salimma@fedoraproject.org> - 4.9.3-1
- Update to 4.9.3
- Move license files to /usr/share/licenses

* Fri Jul 13 2018 Fedora Release Engineering <releng@fedoraproject.org> - 4.8.8-5
- Rebuilt for https://fedoraproject.org/wiki/Fedora_29_Mass_Rebuild

* Wed Feb 07 2018 Fedora Release Engineering <releng@fedoraproject.org> - 4.8.8-4
- Rebuilt for https://fedoraproject.org/wiki/Fedora_28_Mass_Rebuild

* Wed Aug 02 2017 Fedora Release Engineering <releng@fedoraproject.org> - 4.8.8-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_27_Binutils_Mass_Rebuild

* Wed Jul 26 2017 Fedora Release Engineering <releng@fedoraproject.org> - 4.8.8-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_27_Mass_Rebuild

* Sun Feb 26 2017 Michel Alexandre Salim <salimma@fedoraproject.org> - 4.8.8-1
- Update to 4.8.8
- Automatically calculate _dirname

* Fri Feb 10 2017 Fedora Release Engineering <releng@fedoraproject.org> - 4.8.7-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_26_Mass_Rebuild

* Mon Jan  9 2017 Michel Alexandre Salim <salimma@fedoraproject.org> - 4.8.7-1
- Update to 4.8.7

* Mon Jan  9 2017 Michel Alexandre Salim <salimma@fedoraproject.org> - 4.8.6-1
- Update to 4.8.6

* Sun Feb 28 2016 Michel Alexandre Salim <salimma@fedoraproject.org> - 4.8.4-2
- Re-enable ARM build with upstream cast fix

* Sun Feb 21 2016 Michel Alexandre Salim <salimma@fedoraproject.org> - 4.8.4-1
- Update to 4.8.4

* Wed Feb 03 2016 Fedora Release Engineering <releng@fedoraproject.org> - 4.7.9-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_24_Mass_Rebuild

* Sun Sep  6 2015 Michel Alexandre Salim <salimma@fedoraproject.org> - 4.7.9-1
- Update to 4.7.9
- Update home page link
- Adjust to new Emacs packaging guidelines, no longer shipping separate packages
- Further reduce expensive optimizations on resource-limited arches

* Tue Jul 28 2015 Peter Robinson <pbrobinson@fedoraproject.org> 4.7.7-1
- Update to 4.7.7

* Wed Jun 17 2015 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 4.7.5-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_23_Mass_Rebuild

* Sun May  3 2015 Peter Robinson <pbrobinson@fedoraproject.org> 4.7.5-1
- Update to 4.7.5

* Tue Nov 04 2014 Jakub Čajka <jcajka@redhat.com> - 4.7.3-2
- Fix build OOM on s390

* Thu Oct 30 2014 Michel Alexandre Salim <salimma@fedoraproject.org> - 4.7.3-1
- Update to 4.7.3

* Sat Aug 16 2014 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 4.7.2-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_21_22_Mass_Rebuild

* Sat Jun 07 2014 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 4.7.2-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_21_Mass_Rebuild

* Fri Feb  7 2014 Michel Salim <salimma@fedoraproject.org> - 4.7.2-1
- Update to 4.7.2

* Tue Nov 05 2013 Kyle McMartin <kyle@fedoraproject.org>
- Fix FTBFS because of dirname macro, use _dirname instead.

* Sat Aug 03 2013 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 4.6.6-4
- Rebuilt for https://fedoraproject.org/wiki/Fedora_20_Mass_Rebuild

* Wed Feb 13 2013 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 4.6.6-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_19_Mass_Rebuild

* Thu Jul 19 2012 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 4.6.6-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_18_Mass_Rebuild

* Tue Jun  5 2012 Michel Salim <salimma@fedoraproject.org> - 4.6.6-1
- Update to 4.6.6

* Sat Mar 31 2012 Michel Salim <salimma@fedoraproject.org> - 4.6.5-2
- Reduce optimization level on ppc64 to work around gcc compilation error

* Thu Mar 29 2012 Michel Salim <salimma@fedoraproject.org> - 4.6.5-1
- Update to 4.6.5
- Drop termite subpackages, they have been disabled for many releases
- Disable ppc64 target for now; broken since 4.6.4

* Wed Feb 15 2012 Michel Salim <salimma@fedoraproject.org> - 4.6.4-1
- Update to 4.6.4

* Wed Feb  1 2012 Michel Salim <salimma@fedoraproject.org> - 4.6.3-1
- Update to 4.6.3

* Fri Jan 13 2012 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 4.6.1-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_17_Mass_Rebuild

* Wed Jul 27 2011 Michel Salim <salimma@fedoraproject.org> - 4.6.1-1
- Update to 4.6.1

* Tue Feb 08 2011 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 4.6.0-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_15_Mass_Rebuild

* Mon Jul 12 2010 Michel Salim <salimma@fedoraproject.org> - 4.6.0-2
- noarch -doc subpackage properly obsoletes older, arched variant

* Mon Jul 12 2010 Michel Salim <salimma@fedoraproject.org> - 4.6.0-1
- Update to 4.6.0
- Bundle license text with independent Emacs subpackage

* Fri Jul 24 2009 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 4.3.2-4
- Rebuilt for https://fedoraproject.org/wiki/Fedora_12_Mass_Rebuild

* Tue Feb 24 2009 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 4.3.2-3
- Rebuilt for https://fedoraproject.org/wiki/Fedora_11_Mass_Rebuild

* Wed Jan 28 2009 Michel Salim <salimma@fedoraproject.org> - 4.3.2-2
- If termite packages are disabled, the corresponding gambit-c packages
  Provides: and Obsoletes: them

* Fri Dec 19 2008 Michel Salim <salimma@fedoraproject.org> - 4.3.2-1
- Update to 4.3.2

* Tue Oct 14 2008 Michel Salim <salimma@fedoraproject.org> - 4.2.9-1
- Update to 4.2.9
- Disable Termite for now; still broken
- When built on EL-5, depend directly on emacs binary rather than emacs(bin)

* Mon Jul 14 2008 Michel Salim <salimma@fedoraproject.org> - 4.2.8-6
- Put include files and libraries in standard paths

* Thu Jun 19 2008 Michel Salim <salimma@fedoraproject.org> - 4.2.8-5
- Package Termite as a module instead of bundling a custom Gambit-C with it

* Thu Jun 19 2008 Michel Salim <salimma@fedoraproject.org> - 4.2.8-4
- Permission fixes for Termite subpackage

* Wed Jun 18 2008 Michel Salim <salimma@fedoraproject.org> - 4.2.8-3
- Bundle Termite as a subpackage

* Sat Jun  7 2008 Michel Salim <salimma@fedoraproject.org> - 4.2.8-2
- Rename six symlink to avoid clash with existing six package

* Mon Jun  2 2008 Michel Salim <salimma@fedoraproject.org> - 4.2.8-1
- Update to 4.2.8
- Rename to gambit-c

* Fri Dec 28 2007 Gerard Milmeister <gemi@bluewin.ch> - 4.1.2-1
- new release 4.1.2

* Sat Apr 14 2007 Gerard Milmeister <gemi@bluewin.ch> - 4.0-1.b22
- new version 4.0b22

* Sun Oct 15 2006 Gerard Milmeister <gemi@bluewin.ch> - 4.0-1.b20
- new version 4.0b20

* Sat Feb  4 2006 Gerard Milmeister <gemi@bluewin.ch> - 4.0-1.b17
- new version 4.0b17

* Mon Nov  7 2005 Gerard Milmeister <gemi@bluewin.ch> - 4.0-1.b15
- New Version 4.0b15

* Fri Aug 12 2005 Gerard Milmeister <gemi@bluewin.ch> - 4.0-1.b14
- First Fedora release

