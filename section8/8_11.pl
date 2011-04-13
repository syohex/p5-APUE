#!/usr/bin/env perl
use strict;
use warnings;

# 解釈実行ファイルに入れたPerlプログラム

my $length = scalar @ARGV;
for my $i ( 0..($length-1) ) {
    printf "ARG[%d] = %s\n", $i, $ARGV[$i];
}
