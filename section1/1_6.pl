#!/usr/bin/env perl
use strict;
use warnings;

# エラー処理

eval {
    open my $fh, "<", "not_exist_file" or die $!;
};
if ($@) {
    print "Error $@ \n";
}
