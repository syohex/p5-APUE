#!/usr/bin/env perl
use strict;
use warnings;

use Fcntl ":mode";

# umask関数の使用例
my ($before_mode, $after_mode);

open my $fh, ">", "before.txt" or die "Can't open before.txt $!\n";
$before_mode = (stat $fh)[2] & 0777;
close $fh;

my $mode = S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH;
umask $mode or die "umask is not implemented\n";

open my $fh2, ">", "after.txt" or die "Can't open after.txt $!\n";
$after_mode = (stat $fh2)[2] & 0777;
close $fh2;

printf "before permission: 0%o, after permission: 0%o\n"
    , $before_mode, $after_mode;

unlink "before.txt", "after.txt";
