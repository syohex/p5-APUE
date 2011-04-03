#!/usr/bin/env perl
use strict;
use warnings;

use constant BUFSIZE => 8192;

# 低レベルファイルIOを使って、標準入力から標準出力にファイルをコピーする

while (1) {
    my $len = sysread STDIN, my $input, BUFSIZE;
    die "Can't read from STDIN\n" unless defined $len;

    last if $len == 0;

    my $write_len = syswrite STDOUT, $input, $len;
    die "Can't write data to STDOUT\n" unless defined $write_len;
}
