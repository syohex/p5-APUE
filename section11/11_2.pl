#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

# tcgetattrの例

my $termios = POSIX::Termios->new;
unless ($termios->getattr(POSIX::STDIN_FILENO)) {
    die "Error: POSIX::getattr :$!\n";
}

my $size = $termios->getcflag & POSIX::CSIZE;

if ($size == POSIX::CS5) {
    print "5 bits/byte\n";
} elsif ($size == POSIX::CS6) {
    print "6 bits/byte\n";
} elsif ($size == POSIX::CS7) {
    print "7 bits/byte\n";
} elsif ($size == POSIX::CS8) {
    print "8 bits/byte\n";
} else {
    print "unknown bits/byte\n";
}

my $csize = $termios->getcflag;
$csize &= ~(POSIX::CSIZE);
$csize |= POSIX::CS8;

$termios->setcflag($csize);
$termios->setattr(POSIX::STDIN_FILENO, POSIX::TCSANOW);
