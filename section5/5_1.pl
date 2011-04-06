#!/usr/bin/env perl
use strict;
use warnings;

# getc()とputc()を用いて標準出力へコピーする

while (1) {
    my $c = getc(STDIN);
    last unless defined $c;

    print STDOUT $c;
}
