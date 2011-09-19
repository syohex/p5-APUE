#!/usr/bin/env perl
use strict;
use warnings;

use Fcntl;

# ファイルの終わりに対応してロックを解除する際の問題を示すプログラム

require '12_2.pl';

open my $out, '+>', 'temp.lock' or die "Can't open temp.lock: $!";

for my $i (1..1000000) {
    # lock from current EOF to EOF
    write_lock($out, 0, Fcntl::SEEK_END, 0);
    print {$out} "1";
    un_lock($out, 0, Fcntl::SEEK_END, 0);
    print {$out} "1";
}
