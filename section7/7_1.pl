#!/usr/bin/env perl
use strict;
use warnings;

# 終了ハンドラの例

sub my_exit1 {
    print "first exit handler\n";
}

sub my_exit2 {
    print "second exit handler\n";
}

END {
    my_exit1();
    my_exit2();
}

print "main is done\n"
