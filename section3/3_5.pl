#!/usr/bin/env perl
use strict;
use warnings;

use Fcntl;

# 指定したファイルの記述子のファイルフラグを出力する

my $file = shift or die "Usage: $0 file [flag]\n";
my $flag = shift || O_NONBLOCK;

open my $fh, "<", $file or die "Can't open $file: $!";
my $val = fcntl $fh, F_GETFL, 0;
die "Can't get file flag: $file\n" unless defined $val;

die "FLAG is already set\n" if ($val & $flag);

$val |= $flag;

my $retval = fcntl $fh, F_SETFL, $val;
die "Can't set file flag: $file\n" unless defined $retval;

my $check = fcntl $fh, F_GETFL, 0;
die "Can't get file flag: $file\n" unless defined $check;

print "OK set flag\n" if ($check & $flag);

close $fh;
