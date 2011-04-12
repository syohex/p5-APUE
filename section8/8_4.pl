#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

do "8_3.pl"; # import pr_exit

# 様々な終了状態を出力する

my $pid = fork;
die "Error: fork $!\n" unless defined $pid;

if ($pid == 0) { # child
    exit 7;
}

my $childpid = wait;
my $status   = $?;

pr_exit($status);

$pid = fork;
die "Error: fork $!\n" unless defined $pid;

if ($pid == 0) {
    POSIX::abort;
}

$childpid = wait;
$status   = $?;
pr_exit($status);

$pid = fork;
die "Error: fork $!\n" unless defined $pid;

if ($pid == 0) {
    my $dummy = 1 / 0;
}

$childpid = wait;
$status   = $?;

pr_exit($status);
