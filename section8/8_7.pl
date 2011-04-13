#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;
use Fcntl;
use IO::Handle;

# プログラム8.6をレースコンディションを避けるように変更

sub charatatime {
    my $str = shift;

    for my $c (split //, $str) {
        print STDOUT $c;
        STDOUT->autoflush;
        sleep 0.1;
    }
}

my ($rd, $wr);
my $sigflag = 0;
sub TELL_WAIT {
    $SIG{USR1} = sub { $sigflag = 1; };
}

sub WAIT_PARENT {
    # wait for parent to terminate
    while ($sigflag == 0) {
        POSIX::pause();
    }
}

sub TELL_CHILD {
    my $pid = shift;
    kill POSIX::SIGUSR1, $pid;
}

TELL_WAIT();

my $pid = fork;
die "Error: fork $!\n" unless defined $pid;

if ($pid == 0) {
    WAIT_PARENT();
    charatatime("output from child\n");
} else {
    charatatime("output from parent\n");
    TELL_CHILD($pid);
}
