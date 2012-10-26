# Ruby Association 2012 Grant

## Creosote

## Intermediate Report

\vfill

Sam Rawlins

October 25, 2012

\newpage

## Targets

The targets for this intermediate report include the following:

1. Up-to-date GMP, MPFR, and Msieve libraries, and extensive documentation for each
2. Ruby bindings for GMP-ECM
3. Ruby bindings for MPC
4. Creosote, a gem allowing various mathematics libraries to be bridged, in Ruby

Effort was made against each of these targets, except for the second. Bindings for GMP-ECM will be written during the second half of the grant period.

## 1. Up-to-date GMP, MPFR, and Msieve libraries, and extensive documentation for each

These three projects are grouped together because they are the three projects that I had already started, and largely completed. Bindings for GMP and MPFR are packaged into a single gem, `gmp`. Msieve is packaged in its own gem, `msieve`.

### GMP

The `gmp` gem has been improved upon during this half of the grant period. Highlights include:

* Implement `GMP::sprintf` ([d53c40a](https://github.com/srawlins/gmp/commit/d53c40acaacfe28f860aa781d12f60b99824ca8e)). This is discussed in [a blog post](http://srawlins.ruhoh.com/sprintf-now-available/) for the project:

        GMP.sprintf("%5Zd * %d = %5Zd, %s", z127, 2, z254, "Yay!")
        => "  127 * 2 =   254, Yay!"
        GMP.sprintf("0x%Zx * %d = 0x%Zx, %s", z127, 2, z254, "Yay!")
        => "0x7f * 2 = 0xfe, Yay!"
  Very exciting. This also represents the very first Ruby code in the `gmp` gem; its the first time I've had resort to falling back to Ruby.

* extend `GMP::F#to_s` to allow a base to be passed in ([5d340a4](https://github.com/srawlins/gmp/commit/5d340a476824e963b820a759bb0a8ce45d542b17)). This was necessary for the `gnu_mpc` gem tests, allowing for things like:

        GMP::F.new("0x1921FB54442D18p-51", 53, 16)
        => 0.31415926535897931e+1
  So $0x1921FB54442D18p-51$ is an approximation of pi written in [Hex Float format](http://www.exploringbinary.com/hexadecimal-floating-point-constants/).

* Add `Rakefile`! ([3be64a5](https://github.com/srawlins/gmp/commit/3be64a51ccd8fc07a7dce0f29cffd91619fe5d4c)).
* Add some `GMP::F#to_s` tests ([3be64a5](https://github.com/srawlins/gmp/commit/3be64a51ccd8fc07a7dce0f29cffd91619fe5d4c)), ([9a1630f](https://github.com/srawlins/gmp/commit/9a1630fed29052c0b96c8a82eb913c637cad9d3c)).

At this point, the `gmp` gem exposes over 70 functions from GMP's [Integer Functions](http://gmplib.org/manual/Integer-Functions.html#Integer-Functions) interface, over 25 from the [Rational Number Functions](http://gmplib.org/manual/Rational-Number-Functions.html#Rational-Number-Functions) interface, and over 33 from the [Floating-point Functions](http://gmplib.org/manual/Floating_002dpoint-Functions.html#Floating_002dpoint-Functions) interface.

In addition, seven Ruby methods expose the [Random Number Functions](http://gmplib.org/manual/Random-Number-Functions.html#Random-Number-Functions) interface.

The `gmp` gem is currently documented with a 31-page [manual](https://github.com/srawlins/gmp/blob/master/manual.pdf?raw=true) and [rdoc](http://rubydoc.info/gems/gmp/frames).

### MPFR

The MPFR bindings, inside the `gmp` gem, have been improved upon during this half of the grant period. Highlights include:

* implement `GMP::F#integer?` ([36f0735](https://github.com/srawlins/gmp/commit/36f07358d38b20e2fcb0544de6f3061f14bfbd33)).
* MPFR 3.1's PRNG changed; fix tests ([092db3c](https://github.com/srawlins/gmp/commit/092db3c98dc93b6510acfc823b534699e1b3a1df)).

At this point the `gmp` gem exposes over 55 functions from MPFR's interface.

The Msieve bindings in the `gmp` gem are currently documented with a 31-page [manual](https://github.com/srawlins/gmp/blob/master/manual.pdf?raw=true) and [rdoc](http://rubydoc.info/gems/gmp/frames).

### Msieve

No new features were added to the `msieve` gem during this half of the grant
period. Only two real changes were made:

* Fixed memory freeing issue that caused a Segmentation Fault.
* Upgraded tests to work under Ruby 1.9.

## 2. Ruby Bindings for GMP-ECM

Bindings for GMP-ECM will be written during the second half of the grant period.

## 3. Ruby Bindings for MPC

Bindings for GNU's MPC library were written from the ground up, and largely
completed during the first half of the grant period:

* more than 40 functions from the MPC [Complex Numbers](http://www.multiprecision.org/index.php?prog=mpc&page=html#Complex-Functions) interface have been bridged in the `gnu_mpc` gem.
* more than 90% of the methods exposed in the `gnu_mpc` gem are heavily tested. The test suite includes over 160 test examples.
* Approximately 10 functions from the MPC interface have not been bridged.
* The `gnu_mpc` gem has largely been documented in `manual.md`, which gets compiled into a 12-page `manual.pdf` and `manual.html`, using Pandoc.

## 4. Creosote, a gem allowing various mathematics libraries to be bridged, in Ruby
