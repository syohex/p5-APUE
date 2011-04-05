#!/usr/bin/env perl
use strict;
use warnings;

use Fcntl ':mode';

# st_devとst_rdevを出力する

die "Usage: $0 file1 file2 ..." if scalar @ARGV == 0;

for my $file (@ARGV) {
    my ($dev, $mode, $rdev) = (lstat $file)[0,2,6];

    printf "dev = %d/%d\n", ($dev & 0xff00) >> 8, $dev & 0xff;

    my $type;
    if (S_ISBLK($mode)) {
        $type = "block";
    } elsif (S_ISCHR($mode)) {
        $type = "character";
    } else {
        next;
    }

    printf "  %s(%s) major: %d, minor %d\n",
        $file, $type, ($rdev & 0xff00) >> 8, $rdev & 0xff;
}
