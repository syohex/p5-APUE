#!/usr/bin/env perl
use strict;
use warnings;

# fork関数の例

my $glob = 6;
my $buf  = "a write to stdout\n";

sub main {
    my $var = 88;
    print STDOUT $buf;

    my $pid = fork;
    die "Error: fork $!\n" unless defined $pid;

    if ($pid == 0) { #child
        $glob += 1;
        $var  += 1;
    } else { # parent
        sleep 2;
    }

    printf "pid=%d, glob=%d, var=%d\n", $pid, $glob, $var;
}

main();
