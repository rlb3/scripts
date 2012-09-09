#!/usr/bin/perl

use strict;
use warnings;

use threads;
use Thread::Semaphore;

my $semaphore = Thread::Semaphore->new(4);    # max number of proccesors to use

for my $i ( 1 .. 10 ) {
    my $thr = threads->new( \&sub1, $i );
    $thr->detach();
}
sleep 20;

sub sub1 {
    $semaphore->down(1);
    my $tn = shift;
    print "thread $tn is working\n";
    my $s = int( rand 4 ) + 1;                # a long calculation
    sleep $s;
    $semaphore->up(1);
}
