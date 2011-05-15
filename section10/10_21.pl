#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

# sleepの信頼性のある実装

sub sig_alrm {
    # nothing to do, just returning wakes up sigsuspend()
}

sub sleep {
    my $nsecs = shift;

    my $newact = POSIX::SigAction->new;
    my $oldact = POSIX::SigAction->new;

    my $newmask  = POSIX::SigSet->new;
    my $oldmask  = POSIX::SigSet->new;
    my $suspmask = POSIX::SigSet->new;

    my $unslept = 0;

    # set out handler, save previous information
    $SIG{ALRM} = \&sig_alrm;
    sigaction(POSIX::SIGALRM, undef, $oldact);

    $newmask->addset(POSIX::SIGALRM);

    POSIX::sigprocmask(POSIX::SIG_BLOCK, $newmask, $oldmask);

    alarm $nsecs;

    $suspmask = $oldmask;
    $suspmask->delset(POSIX::SIGALRM);
    sigsuspend($suspmask);

    # some signalshas been caught, SIGALRM is now blocked

    $unslept = alarm 0;

    sigaction(POSIX::SIGALRM, $oldact, undef);


}

__END__

def sleep(nsecs):
    # reset signal mask, which unblocks SIGALRM
    sigprocmask(SIG_SETMASK, byref(oldmask), None)

    return unslept
