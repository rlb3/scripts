#!/usr/bin/perl -w

use strict;

use constant TRUE => 1;

my $list = day_list( shift, shift );

print $list, "\n";

sub day_list {
    use Data::Dumper;
    my ( $first, $last ) = @_;

    die("Invalid args: $0 day1 day2\n") unless $first and $last;

    my %days = (
        sun  => 0,
        mon  => 1,
        tues => 2,
        wed  => 3,
        thu  => 4,
        fri  => 5,
        sat  => 6
    );

    my @days = qw|sun mon tues wed thu fri sat|;

    my $end = $days{$first};

    my $count;
    my @end;
    while (TRUE) {
        $end = 0 if ( $end > 6 );
        $end[ $count++ ] = $days[$end];
        if ( $end == $days{$last} ) {
            return join ", ", @end;
        }
        exit if ( $end++ == $days{$last} );
    }
}
