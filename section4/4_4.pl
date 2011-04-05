#!/usr/bin/env perl
use strict;
use warnings;

use Fcntl ':mode';

# chmod関数の使用例
my $file = shift or die "Usage: $0 file\n";

my $orig = (stat $file)[2] & 07777;

# turn on set-group-ID and turn off group-execute
my $new_permission = (($orig & ~S_IXGRP) | S_ISGID) & 07777;
chmod $new_permission, $file or die "Can't chmod $file\n";
