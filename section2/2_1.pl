#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

# sysconfとpathconfの定義値を出力する

for my $key (%POSIX::) {
    next unless $key =~ m{^_SC_}xms;

    {
        no strict "refs";

        my $val = POSIX::sysconf( &{"POSIX::$key"} );
        if (defined $val) {
            print "$key, $val\n";
        } else {
            print "$key (undefined)\n"
        }
    }
}

my $fd = POSIX::open("/etc/passwd", POSIX::O_RDONLY);
die "Can't open file: $!" unless defined $fd;

for my $key (%POSIX::) {
    next unless $key =~ m{^_PC_}xms;

    {
        no strict "refs";
        my $val = POSIX::pathconf($fd, &{"POSIX::$key"});
        if (defined $val) {
            print "$key, $val\n";
        } else {
            print "$key (undefined)\n"
        }
    }
}
