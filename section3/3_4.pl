#!/usr/bin/env perl
use strict;
use warnings;

use Fcntl;
use POSIX;

# 指定したファイルの記述子のファイルフラグを出力する

my $file = shift or die "Usage: $0 file\n";
open my $fh, ">>", $file or die "Can't open $file: $!";
my $flags = fcntl $fh, F_GETFL, 0 or die "Can't fcntl $file: $!";

my $accmode = $flags & O_ACCMODE;
if ($accmode == O_RDONLY) {
    print "read only\n"
} elsif ($accmode == O_WRONLY) {
    print "write only\n";
} elsif ($accmode == O_RDWR) {
    print "read write\n";
}

if ($flags & O_APPEND) {
    print "append\n";
}
if ($flags & O_NONBLOCK) {
    print "nonblocking\n";
}
if ($flags & O_SYNC) {
    print "synchronous write";
}

close $fh;
