#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

require '10_9.pl'; # import sigismember

# プログラムのシグナルマスクを出力する

sub pr_mask {
    my $str = shift;
    local $!;

    my $sigset = POSIX::SigSet->new;
    unless (POSIX::sigprocmask(0, undef, $sigset)) {
        die "$!\n";
    }
    if (sigismember($sigset, POSIX::SIGINT)) {
        print "SIGINT\n";
    }
    if (sigismember($sigset, POSIX::SIGQUIT)) {
        print "SIGQUIT\n";
    }
    if (sigismember($sigset, POSIX::SIGUSR1)) {
        print "SIGUSR1\n";
    }
    if (sigismember($sigset, POSIX::SIGALRM)) {
        print "SIGALRM\n";
    }

    print "\n";
}

1;
