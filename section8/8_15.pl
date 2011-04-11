#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

# 実ユーザIDおよび実効ユーザIDを出力する
printf "real uid = %d, effective uid = %d\n", POSIX::getuid(), POSIX::geteuid();
printf "real uid = %d, effective uid = %d\n", $<, $>;
