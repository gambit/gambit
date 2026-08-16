%global         commit       e5bf50ef65127ca2880e5b8e19240dafffb405a3
%global         shortcommit  %(c=%{commit}; echo ${c:0:7})
%global         commitdate   20250525

Name:           gambit-c
Version:        4.9.6^%{commitdate}git%{shortcommit}
Release:        %autorelease
Summary:        Scheme programming system

License:        Apache-2.0 OR LGPL-2.1-only
URL:            http://gambitscheme.org/
Source0:        https://github.com/gambit/gambit/archive/%{commit}/gambit-%{shortcommit}.tar.gz
Source1:        gambit-init.el
Patch0:         gambc-v4_2_8-modtime.patch

BuildRequires:  gcc
BuildRequires:  emacs
BuildRequires:  make
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
Requires(post):  info
Requires(preun): info
# switch to noarch
Obsoletes:      gambit-c-doc < %{version}-%{release}

%description    doc
Gambit-C includes a Scheme interpreter and a Scheme compiler which can
be used to build standalone executables.  Because the compiler
generates portable C code it is fairly easy to port to any platform
with a decent C compiler.

This package contains the Gambit-C user manual in HTML and PDF formats.


%prep
%autosetup -n gambit-%{commit} -p1
# Gambit tries to do a git update-index if a git repo is detected
rm -rf .git

# Permission fixes
chmod -x lib/*.{c,h}


%build

%if 0%{?rhel}
%if 0%{?rhel} <= 7
%global disable_gcc_opts 1
%endif
%endif

%if "%{_arch}"!="i686"
%configure --enable-trust-c-tco \
	  --bindir=%{_libdir}/%{name}/bin \
           --libdir=%{_libdir}/%{name}
%else
%configure --disable-trust-c-tco \
           --bindir=%{_libdir}/%{name}/bin \
           --libdir=%{_libdir}/%{name}
%endif

make %{?_smp_mflags}
	  
# Compile emacs module
(cd misc && %{_emacs_bytecompile} gambit.el)


%check
make check


%install
make install DESTDIR=$RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_bindir}
for i in gsc gsi
do
  ln -sf ../%{_lib}/%{name}/bin/$i $RPM_BUILD_ROOT%{_bindir}/$i
done
cat > $RPM_BUILD_ROOT%{_bindir}/gsix <<EOF
#!/bin/sh
%{_libdir}/%{name}/bin/six $@
EOF
chmod +x $RPM_BUILD_ROOT%{_bindir}/gsix

# Remove duplicate docs
rm -rf $RPM_BUILD_ROOT%{_prefix}/doc

# Emacs mode files
mkdir -p $RPM_BUILD_ROOT%{_emacs_sitestartdir}
cp -p misc/gambit.elc $RPM_BUILD_ROOT%{_emacs_sitelispdir}
cp -p %{SOURCE1} $RPM_BUILD_ROOT%{_emacs_sitestartdir}

# Link static libs
(cd $RPM_BUILD_ROOT%{_libdir} && ln -s %{name}/*.a .)


%files
%license LGPL.txt LICENSE-2.0.txt
%doc README
%{_bindir}/*
%{_includedir}/*.h
%{_mandir}/man1/gsi.*
%{_libdir}/%{name}
%{_libdir}/*.a
%{_emacs_sitelispdir}/*.el
%{_emacs_sitelispdir}/*.elc
%{_emacs_sitestartdir}/gambit-init.el


%files doc
%doc doc/gambit.html doc/gambit.pdf
# don't package examples until makefiles are fixed
# examples
%{_infodir}/*


%changelog
%autochangelog
