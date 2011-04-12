#!/usr/bin/env perl
use strict;
use warnings;

# 全てのコマンド行引数と全ての環境変数を出力する

# echo all args
my $length = scalar @ARGV;
for my $i ( 0..($length-1) ) {
    printf "ARG[%d] = %s\n", $i, $ARGV[$i];
}

# echo all env strings
while (my ($key, $val) = each %ENV) {
    print "$key:$val\n";
}
