#!/usr/bin/env perl
use strict;
use warnings;

use POSIX ();
use Term::ReadKey qw(GetTerminalSize);

# ウィンドウサイズを表示する

sub pr_winsize {
    my $fh = shift;
    my ($wchar, $hchar, $wpixels, $hpixels) = GetTerminalSize($fh);

    printf "%d rows, %d columns\n", $hchar, $wchar;
}

unless (POSIX::isatty(*STDIN)) {
    die "STDIN is not a tty\n";
}

pr_winsize(*STDIN);

local $SIG{WINCH} = sub {
    print "SIGWINCH received\n";
    pr_winsize(*STDIN);
};

print "My pid = $$\n";
while (1) {
    POSIX::pause();
}
