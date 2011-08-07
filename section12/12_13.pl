#!/usr/bin/env perl
use strict;
use warnings;

sub readn {
    my ($fh, $n) = @_;

    my @ret;
    while ($n > 0) {
        my $nread = sysread $fh, my $buf, $n;
        last unless defined $nread;

        push @ret, $buf;

        if ($nread == 0) {
            last;
        }

        $n -= $nread;
    }

    return join //, @ret;
}
