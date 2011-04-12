#!/usr/bin/env perl
use strict;
use warnings;

use IO::Handle;
use Time::HiRes;

# レースコンディションを有するプログラム

sub charatatime {
    my $str = shift;

    for my $c (split //, $str) {
        print STDOUT $c;
        STDOUT->autoflush;
        sleep 0.1;
    }
}

my $pid = fork;
die "Error: fork $!\n" unless defined $pid;

if ($pid == 0) {
    charatatime("output from child\n");
} else {
    charatatime("output from parent\n");
}
