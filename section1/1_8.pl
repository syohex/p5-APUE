#!/usr/bin/env perl
use strict;
use warnings;

local $SIG{INT} = sub {
    print "interrupt\n";
};

# シグナル
while (1) {
    print "> ";
    my $command = <STDIN>;
    last unless defined $command;
    next if $command =~ m{^\s*$};

    my $pid = fork;
    die "Can't fork\n" unless defined $pid;

    if ($pid == 0) {
        # child process
        my @commands = split /\s/, $command;
        exec {$commands[0]} @commands;
    }

    waitpid $pid, 0;
}
