Creosote
========

The creosote gem provides two distinct functionalities that aid in using mathematics Ruby extensions. Firstly, creosote can provide awareness between unrelated mathematical libraries (such as GMP and Msieve), allowing data to be passed between them. Secondly, creosote can install prerequisite C libraries that certain Rubygems might need (inspired by RVMs same ability). For example, if one wishes to install the gmp_ecm gem, but do not have the ecm library, or its prerequisites installed, creosote can help.

Setup
-----

`gem install creosote`

Package Installer Disclaimer
----------------------------

Creosote's second piece of functionality, installing package dependencies, should not be used lightly :P . I need to explain why this was written at all:

Historically, if a C Extension Rubygem depended on a dynamically loaded library, or shared object, then it was 100% the user's task to install said library. For example, Nokogiri depends on libxml2, and the gmp gem depends wholly on libgmp. On a typical Linux system, a user with root access is able to install such a library with a package manager (yum, synaptic, ...). On Mac OS X, a user can find such a package management system, such as MacPorts, or Homebrew, that can install a library. In Windows, this can certainly be tricky, but Cygwin isn't an awful way to go. Outside of package managers, a savvy user can compile and install most libraries from source. If a user does not have root access, they can install to a custom directory, such as `~/usr/local`.

However, in the spirit of making Ruby more accessible as a programming language for scientific computing, I wanted to make this easier. The idea first hit me when I was one day trying to figure out how RVM was installing Ruby dependencies behind the scenes. RVM actually downloads and installs required packages to `~/.rvm/usr` (use `rvm pkg --help` to see all of the packages available that RVM can manage.) I think that a lot of people might argue that there were _already_ well-understood ways to install these dependencies. When RVM does it under the covers, however, it lowers the barriers to entry. It allows more users who are not interested in system-administering their laptop to use Ruby in the powerful ways that RVM provides. Indeed, even RVM solves a problem that could already be solved with fancy shell scripting and symlinking, but providing this for everyone lowers the personal sysadmin requirements for using Ruby.

Creosote tries to mirror RVM's "package install" functionality (but its written in Ruby, thank goodness!). Required libraries can be installed to `.creosote/usr/` and Rubygems can then use those dependencies when building a C extension. This is purely to allow less package-administration-savvy users to use Ruby as a scientific computation platform.

My recommendation is this: if you are able, please try to manage your dependencies with the more established package management systems at your disposal. If using a mathematics Rubygem on a production RHEL system, I *highly* recommend that you install your prerequisites with YUM/RPM. Even locally, if you are using Mac OS X, I *highly* recommend using Homebrew or MacPorts. Creosote's package installer should be used only in cases where the user just doesn't want to mess with package management, and wants to get up and going with a Ruby C extension quickly.

Using creosote's package installer
----------------------------------

The gnu_mpc gem provides exposes the GNU MPC `mpc_t` type via a class in Ruby, `MPC`.

Compatibility
-------------

At this point, creosote has not been tested on a great variety of platforms:

* Mac OS X 10.6 (with Apple's GCC 4.2.1 as the default C compiler)
* Ubuntu 12.04 (with Ubuntu/Linaro's GCC 4.6.3 as the default C compiler)

Creosote has also only been tested with Ruby 1.9.3. It should work fine on all MRI versions 1.9.x, and with MRI 1.8.7, as I have taken care to not use any Ruby 1.9 syntax.
