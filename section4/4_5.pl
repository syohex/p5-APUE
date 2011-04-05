#!/usr/bin/env perl
use strict;
use warnings;

# ファイルをオープンし、アンリンクする
my $file = "spam";
open my $fh, "+>", $file or die "Can't open file $!\n";
unlink $file or die "Can't unlink file $!\n";

print "file unlinked\n";
sleep 15;
print "done\n";
