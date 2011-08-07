#!/usr/bin/env perl
use strict;
use warnings;

do '11_4.pl'; # import isatty()
do '11_6.pl'; # import ttyname()

# ttyname関数のテスト

for my $fd (0..2) {
    print "fd $fd: ";

    if (isatty($fd)) {
        printf "%s\n", ttyname($fd);
    } else {
        print "not a tty\n";
    }
}
