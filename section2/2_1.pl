#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

# sysconfとpathconfの定義値を出力する

print "sysconf:\n";
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
print "\n";

print "pathconf:\n";
for my $key (%POSIX::) {
    next unless $key =~ m{^_PC_}xms;

    {
        no strict "refs";
        my $val = POSIX::pathconf("/", &{"POSIX::$key"});
        if (defined $val) {
            print "$key, $val\n";
        } else {
            print "$key (undefined)\n"
        }
    }
}
