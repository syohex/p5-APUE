#!/usr/bin/env perl
use strict;
use warnings;

# 割り込み文字を無効にし、ファイルの終わりの文字を変更する

use POSIX ();

unless (POSIX::isatty(0)) {
    die "standard input is not a terminal device\n";
}

my $vdisable = POSIX::fpathconf(POSIX::STDIN_FILENO, POSIX::_PC_VDISABLE);
unless (defined $vdisable) {
    die "_POSIX_VDISABLE not in effect\n";
}

my $termios = POSIX::Termios->new;
unless ($termios->getattr(POSIX::STDIN_FILENO)) {
    die "Error: POSIX::getattr :$!\n";
}

$termios->setcc(POSIX::VINTR, $vdisable);  # disable INTR character
$termios->setcc(POSIX::VEOF, 2); # EOF is Control-B

$termios->setattr(POSIX::STDIN_FILENO, POSIX::TCSAFLUSH);
