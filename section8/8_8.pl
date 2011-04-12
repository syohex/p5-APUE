#!/usr/bin/env perl
use strict;
use warnings;

# exec関数の例

my $pid = fork;
die "Error fork $!\n" unless defined $pid;

if ($pid == 0) {
    exec { "./echoall" } "echoall", "myarg1", "MY ARG2", "USER" => "unknown";
    exit 0;
}

waitpid $pid, 0;

my $pid2 = fork;
die "Error fork $!\n" unless defined $pid;

if ($pid2 == 0) {
    exec { "./echoall" } "echoall", "only one arg";
    exit 0;
}

waitpid $pid2, 0;
