#!/usr/bin/env perl
use strict;
use warnings;

use IO::Handle;

# fgets()とfputs()を用いて標準出力へコピーする

my $io = IO::Handle->new;
unless ($io->fdopen(fileno(STDIN), "r")) {
    die "Can't open STDIN\n";
}

while (my $line = $io->gets) {
    print STDOUT "$line";
}
