#!/usr/bin/env perl
use strict;
use warnings;

# プログラム例 デッドロック

require '../section10/10_17.pl';

open my $fh, ">", 'templock' or die "Can't open file: $!";
print {$fh} "ab";
my $fd = fileno $fh;

TELL_WAIT();

my $pid = fork;
die "Can't fork: $!" unless defined $pid;

if ($pid == 0) { # child
    lockabyte("child", $fd, 0); ??
    TELL_PARENT($$);

} else { # parent
    TELL_CHILD($pid);
    WAIT_CHILD();
}

close $fh;

__END__

# create a file and write two bytes to it
f = open("templock", "w", 0)
f.write("ab")
fd = f.fileno()

TELL_WAIT()
pid = os.fork()
if pid == 0: #child

    TELL_PARENT(os.getppid())
    WAIT_PARENT()
    lockabyte("child", fd, 1)

else:        # parent
    lockabyte("parent", fd, 1)
    TELL_CHILD(pid)
    WAIT_CHILD()
    lockabyte("parent", fd, 0)
