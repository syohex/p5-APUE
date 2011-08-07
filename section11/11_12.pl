#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;
use Term::ReadKey qw(GetTerminalSize);

# ウィンドウサイズを表示する

sub pr_winsize {
    my $fd = shift;
    my ($wchar, $hchar, $wpixels, $hpixels) = GetTerminalSize();

    printf "%d rows, %d columns\n", $hchar, $wchar;
}

unless (POSIX::isatty(*STDIN)) {
    die "STDIN is not a tty\n";
}

pr_winsize(POSIX::STDIN_FILENO);

local $SIG{WINCH} = sub {
    print "SIGWINCH received\n";
    pr_winsize(POSIX::STDIN_FILENO);
};

while (1) {
    POSIX::pause();
}
