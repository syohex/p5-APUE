#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();

# getpass関数の実装

sub getpass {
    my $prompt = shift;

    my $path = POSIX::ctermid();
    my $fd = POSIX::open($path, POSIX::O_WRONLY);
    unless (defined $fd) {
        die "Error: open $!\n";
    }

    my $sig = POSIX::SigSet->new;
    my $sigsave = POSIX::SigSet->new;

    # block SIGINT & SIGTSTP, save signal mask
    $sig->emptyset;
    $sig->addset(POSIX::SIGINT);
    $sig->addset(POSIX::SIGSTOP);

    unless (POSIX::sigprocmask(POSIX::SIG_BLOCK, $sig, $sigsave)) {
        die "Error: sigprocmask $!\n";
    }

    my $termios = POSIX::Termios->new;
    $termios->getattr($fd);

    my $saveflag;
    my $lflag = $saveflag = $termios->getlflag;
    $lflag &= ~(POSIX::ECHO | POSIX::ECHOE | POSIX::ECHOK | POSIX::ECHONL);
    $termios->setlflag($lflag);
    $termios->setattr($fd, POSIX::TCSAFLUSH);

    print "$prompt";

    chomp(my $passwd = <STDIN>);

    # restore tty state
    $termios->setlflag($saveflag);
    $termios->setattr($fd, POSIX::TCSAFLUSH);
    # restore signal mask
    unless (POSIX::sigprocmask(POSIX::SIG_BLOCK, $sigsave, undef)) {
        die "Error: sigprocmask $!\n";
    }
    # done with /dev/tty
    unless (POSIX::close($fd)) {
        die "Error: close $!\n";
    }

    return $passwd;
}

1;
