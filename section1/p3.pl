#!/usr/bin/env perl
use strict;
use warnings;

# 標準入出力を使用したファイルのコピー
while (1) {
    my $c = getc;
    last unless defined $c;

    print STDOUT $c;
}
