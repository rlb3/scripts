#!/usr/bin/perl
use threads;
use Thread::Queue;

my $DataQueue = Thread::Queue->new;
$thr = threads->new(
    sub {
        while ( $DataElement = $DataQueue->dequeue ) {
            print "Popped $DataElement off the queue\n";
        }
    }
);

$DataQueue->enqueue(12);
$DataQueue->enqueue( "A", "B", "C" );

#sleep 1;
$DataQueue->enqueue("Test");
$thr->join;
