#!/usr/bin/env perl
use strict;
use warnings;

# コマンド行の全ての引数を標準出力にエコーする

my @args = @ARGV;
{
    local @ARGV = @args;

    unshift @ARGV, $0;
    my $length = scalar @ARGV;
    for my $i (0..($length-1)) {
        printf "argv[%d]:%s\n", $i, $ARGV[$i];
    }
}
