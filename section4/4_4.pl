#!/usr/bin/env perl
use strict;
use warnings;

use Fcntl ':mode';

# chmod関数の使用例
my $file = shift or die "Usage: $0 file\n";

my $orig = (stat $file)[2] & 0777;

# turn on set-group-ID and turn off group-execute
my $new_permission = (($orig & ~S_IXGRP) | S_ISGID);
printf "test = %o\n", $new_permission;
chmod (($orig & ~S_IXGRP) | S_ISGID), $file or die "Can't chmod $file\n";

my $mode = (stat $file)[2] & 0x777;

printf "original mode: 0%o, after mode: 0%o\n", $orig, $mode;
