#!/usr/bin/env perl
use strict;
use warnings;

use autodie;
use POSIX;

# 実効記録データを生成するためのプログラム

my $pid = fork;
if ($pid != 0) {
    sleep 2;
    exit 2;
}

$pid = fork;
if ($pid != 0) {
    sleep 4;
    POSIX::abort();
}

$pid = fork;
if ($pid != 0) {
    exec { "/bin/dd" } "dd", "if=/etc/shells", "of=/dev/null";
    exit 7;
}

$pid = fork;
if ($pid != 0) {
    sleep 8;
    exit 0;
}

sleep 8;
kill POSIX::SIGKILL, $$;
exit 6;
