#!/usr/bin/perl -w

use strict;

use threads;
use threads::shared;

print "Started\n";

my $status : shared = 0;

my $thr1 = threads->new(
    sub {
        sleep(2) and print "thread1: $status\n" while 1;
    }
);
my $thr2 = threads->new(
    sub {
        sleep(1) and print "thread2: status incremented\n" while ++$status;
    }
);

$thr1->join;
$thr2->join;
