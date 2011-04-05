#!/usr/bin/env perl
use strict;
use warnings;

# chdir()の例

chdir "/tmp" or die "Can't chdir /tmp\n";
print "chdir to /tmp succeeded.\n"
