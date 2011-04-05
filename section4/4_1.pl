#!/usr/bin/env perl
use strict;
use warnings;

use Fcntl ":mode";

# 指定したファイルの種類を出力する

die "Usage $0 file1 file2 ..." if scalar @ARGV == 0;

for my $file (@ARGV) {
    my $mode = (lstat $file)[2];

    print "$file type is ";

    if (S_ISREG($mode)) {
        print "regular file\n"
    } elsif (S_ISDIR($mode)) {
        print "directory\n";
    } elsif (S_ISCHR($mode)) {
        print "character special\n"
    } elsif (S_ISLNK($mode)) {
        print "symbolic link\n"
    } else {
        print "** unknown mode **\n";
    }
}
