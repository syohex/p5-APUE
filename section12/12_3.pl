#!/usr/bin/env perl
use strict;
use warnings;

use Fcntl;

sub lock_test {
    my $fh = shift;
    fcntl $fh, Fcntl::F_GETLK, my $buf;

    my @vals = unpack('hhqqI', $buf);

    print "@vals\n";
}

sub is_readlock {
    my $fh = shift;
    lock_test($fh);
}

is_readlock(*STDIN);

__END__
import fcntl, struct

def lock_test(fd, type, offset, whence, length):
    lockdata = struct.pack('hhqqI', type, whence, offset, length, 0)
    ret = fcntl.fcntl(fd, fcntl.F_GETLK, lockdata)

    type, whence, offset, length, pid = struct.unpack('hhqqI', ret)
    if type == fcntl.F_UNLCK:
        return None		# false, region is not locked by another proc
    else:
        return pid		# true, return pid of lock owner

def is_readlock(fd, offset, whence, lenght):
    return lock_test(fd, fcntl.F_RDLCK, offset, whence, length)

def is_writelock(fd, offset, whence, lenght):
    return lock_test(fd, fcntl.F_WRLCK, offset, whence, length)
