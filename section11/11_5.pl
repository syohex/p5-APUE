#!/usr/bin/env perl
use strict;
use warnings;

do '11_4.pl';

# isatty関数のテスト

for my $fd (0..2) {
    print "fd $fd: ";
    if (isatty($fd)) {
        print "tty\n";
    } else {
        print "not a tty\n";
    }
}
