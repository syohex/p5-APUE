#!/usr/bin/env perl
use strict;
use warnings;

use Term::ReadKey qw(ReadMode ReadLine);

print "Input password >> ";

ReadMode('noecho');
my $password = ReadLine(0);

print "\npassword is $password\n";
