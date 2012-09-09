#!/usr/bin/perl

use strict;
use warnings;

my $cycle = cycle('red','blue');

print $cycle->(), "\n";
print $cycle->(), "\n";
print $cycle->(), "\n";
print $cycle->(), "\n";

my $count = count();

print $count->(), "\n";
print $count->(), "\n";
print $count->(), "\n";
print $count->(), "\n";
print $count->(), "\n";

sub cycle {
    my @list = @_;
    return sub {
        my ($first, @rest) = @list;
        @list = (@rest, $first);
        return $first;
    };
}

sub count {
    my $count = (defined $_[0]) ? $_[0] : 1;
    return sub {
        return $count++;
    };
}
