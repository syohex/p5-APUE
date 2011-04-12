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
sub TELL_WAIT {
    pipe $rd, $wr;
    die "Error: pipe $|\n" unless defined $rd && defined $wr;

    my $flags = fcntl $wr, F_GETFL, 0;
    fcntl $wr, F_SETFL, $flags | POSIX::O_NONBLOCK;

    $SIG{USR1} = sub {};
}

sub WAIT_PARENT {
    # wait for parent to terminate
    my $rin = '';
    vec($rin, fileno($rd), 1) = 1;
    while (1) {
        select $rin, undef, undef, undef;
        if ($! == POSIX::EINTR) {
            last;
        } else {
            die "Error: select $!\n";
        }

        while (1) {
            my $len = sysread $rd, my $buf, 64;
            die "Error: read $!\n" unless defined $len;
            last if $len == 0;
        }
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
    waitpid $pid, 0;
}
