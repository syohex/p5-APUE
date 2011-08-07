#!/usr/bin/env perl
use strict;
use warnings;

use Fcntl ();

# ブロックしない大量の write

my $buf = <STDIN>;
printf STDERR "read %d bytes\n", length $buf;

my $val = fcntl(STDOUT, Fcntl::F_GETFL, 0);
die "Error: fcntl $!\n" unless defined $val;

fcntl(STDOUT, Fcntl::F_SETFL, $val | Fcntl::O_NONBLOCK); # set nonblocking

while (1) {
    my $n = syswrite STDOUT, $buf, length $buf;
    die "Error: syswrite $!\n" unless defined $n;

    printf STDERR "wrote %d bytes\n", $n;
    $buf = substr $buf, $n;
    print "$buf\n";
    last if length $buf == 0;
}

fcntl(STDOUT, Fcntl::F_SETFL, $val);	# clear nonblocking
