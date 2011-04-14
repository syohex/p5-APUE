#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

# オーファンドプロセスグループの作成

sub pr_ids {
    my $name = shift;

    printf "%s pid=%d ppid=%d pgrp=%d\n"
    , $name, POSIX::getpid, POSIX::getppid, POSIX::getpgrp;
}

pr_ids("parent");

my $pid = fork;
die "Error: fork $!\n" unless defined $pid;

if ($pid != 0) { # parent
    sleep 5;
    print "parent finish\n";
    exit 0;
} else { # child
    pr_ids("child");

    local $SIG{HUP} = sub {
        printf "SIGHUP received pi4=%d\n", POSIX::getpid;
    };

    kill POSIX::SIGSTOP, POSIX::getpid;

    pr_ids("child\n");
    sleep 1;

    my $retval = sysread STDIN, my $buf, 1;
     die "Error sysread $!\n" unless defined $retval;
}
