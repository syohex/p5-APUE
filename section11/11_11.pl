#!/usr/bin/env perl
use strict;
use warnings;

do '11_10.pl';

# ローモードとcbreakモードのテスト

sub sig_catch {
    print "signal caught\n";
    tty_reset(*STDIN);
    exit 0;
}

local $SIG{INT}  = \&sig_catch;
local $SIG{QUIT} = \&sig_catch;
local $SIG{TERM} = \&sig_catch;

tty_raw(*STDIN);
print "Enter raw mode characters, terminate with DELETE\n";

while (1) {
    my $c = getc();
    if (ord $c == 0177) {
        last;
    }

    print hex(ord($c));
}

tty_reset(*STDIN);

tty_cbreak(*STDIN);
print "Enter cbreak mode characters, terminate with SIGINT\n";

while (1) {
    my $c = getc();
    print hex(ord($c));
}

tty_reset(*STDIN);
