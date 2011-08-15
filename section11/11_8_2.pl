#!/usr/bin/env perl
use strict;
use warnings;

use Term::ReadKey ();

print "Input password >> ";

Term::ReadKey::ReadMode('noecho');
my $password = Term::ReadKey::ReadLine(0);

print "\npassword is $password\n";
