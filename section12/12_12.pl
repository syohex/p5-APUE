#!/usr/bin/env perl
use strict;
use warnings;

# writen関数

sub writen {
    my ($fh, $buf) = @_;

    while (1) {
        my $n = syswrite $fh, $buf, length $buf;
        return length $buf unless defined $n;

        $buf = substr $buf, $n;
    }
}


__END__
import os
def writen(fd, buf):
    while buf:
        try:
            n = os.write(fd, buf)
        except IOError:
            return len(buf)
        buf = buf[n:]
