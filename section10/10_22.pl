#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

# SIGTSTPの処理方法

sub sig_tstp {
    # move cursor to lower left corner, reset tty mode ...

    # unblock SIGTSTP, since it's blocked while we're handling it
    my $sigset = POSIX::SigSet->new;

    $sigset->addset(POSIX::SIGTSTP);

    my $ret = POSIX::sigprocmask(POSIX::SIG_UNBLOCK, $sigset, undef);
    die "Error: sigprocmask $!\n" unless defined $ret;

    # reset disposition to default
    $SIG{TSTP} = 'DEFAULT';

    # and set the signal to ourself
    kill POSIX::SIGTSTP, POSIX::getpid;

    # we won't return from the kill untill we're continued

    # reestablish signal handler
    $SIG{TSTP} = \&sig_tstp;

    # reset tty mode, redraw screen, ...
}

# only catch SIGTSTP if we' re running with a job-control shell
$SIG{TSTP} = \&sig_tstp;

while (1) {
    my $ret = sysread STDIN, my $buf, 1024;
    die "Error: read $!\n" unless defined $ret;

    if ($! == POSIX::EINTR) {
        warn "EINTR\n";
        next;
    }

    last unless defined $buf;

    syswrite STDOUT, $buf;
}
