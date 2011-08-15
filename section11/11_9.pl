#!/usr/bin/env perl
use strict;
use warnings;

do '11_8.pl';

# getpass関数を呼ぶ
my $passwd = getpass("Enter password:");

# now we use password
print "\npassword is $passwd\n";

$passwd = "\0";
