#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

# getcwd()の例
chdir "/tmp" or die "Can't chdir /tmp\n";

printf "cwd = %s\n", POSIX::getcwd();
