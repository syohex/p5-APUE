#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

# シグナルの集合と、sigprocmaskの例

sub sig_quit {
    print "Caught SIGQUIT\n";
    $SIG{QUIT} = 'DEFAULT';
}

$SIG{QUIT} = \&sug_quit;

my ($newmask, $oldmask, $pendmask);
$newmask = POSIX::SigSet->new(POSIX::SIGQUIT);
$oldmask = POSIX::SigSet->new;
$pendmask = POSIX::SigSet->new;

unless (POSIX::sigprocmask(POSIX::SIG_BLOCK, $newmask, $oldmask)) {
    print "SIG_BLOCK error\n";
}

sleep 5;

unless (POSIX::sigpending($pendmask)) {
    print "sigpending error\n";
}

if ($pendmask->ismember(POSIX::SIGQUIT)) {
    print "SIGQUIT pending\n";
}

unless (POSIX::sigprocmask(POSIX::SIG_SETMASK, $oldmask)) {
    print "SIG_SETMASK error\n";
}

print "SIGQUIT unblocked\n";
sleep 5;
