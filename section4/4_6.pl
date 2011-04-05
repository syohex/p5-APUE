#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

# utime()関数の例

die "Usage $0 file1 file2 ..." if scalar @ARGV == 0;

my ($atime, $mtime);
$atime = $mtime = time;
utime $atime, $mtime, @ARGV;
