#!/usr/bin/env perl
use strict;
use warnings;

use Try::Tiny;
use Furl;

# setjump/longjump

my $furl = Furl->new( timeout => 10 );
try {
    $furl->get("http://a_a.example.com");
} catch {
    print "Catch exception: $_"
} finally {
    undef $furl;
    print "Clean up\n";
};
