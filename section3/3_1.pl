#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

# 標準入力ファイルがシーク可能であるかどうかを調べる

my $off_t = POSIX::lseek(&POSIX::STDIN_FILENO, 0, &POSIX::SEEK_CUR);
if (defined $off_t) {
    print "seek OK\n";
} else {
    print "cannot seek\n";
}
