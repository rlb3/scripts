#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $days = {
    sun   => 0,
    mon   => 1,
    tues  => 2,
    wed   => 3,
    thurs => 4,
    fri   => 5,
    sat   => 6,
};

my $daylist = [qw/sun mon tues web thurs fri sat/];

print Dumper [ daylist( 'thurs', 'wed' ) ];

sub daylist {
    my ( $first, $last ) = @_;
    my $start = $days->{$first};
    my $end   = $days->{$last};
    if ( $start <= $end ) {
        return map { $daylist->[$_] } $start..$end;
    }
    else {
        my @list = map { $daylist->[$_] } $start..$#$daylist;
        push @list, daylist('sun', $last);
        return @list;
    }
}
