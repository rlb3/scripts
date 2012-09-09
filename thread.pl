#!/usr/bin/perl

use strict;
use threads;
use threads::shared;

our $num : shared;
our $end : shared;
$num = 0;
$end = 0;

sub Boss {
    lock $num;
    $num = 5;
sleep 4;
    lock $end;
    $end = 1;

    return "Boss\n";
}

sub Worker {
    while (1) {
        print $num. "\n";
        return "Worker\n" if $end;
    }
}

my @hold;
push @hold, threads->new( \&Boss );
push @hold, threads->new( \&Worker );

print $_->join foreach (@hold);
