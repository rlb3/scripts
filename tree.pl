#!/usr/bin/perl
use strict;
use warnings;

my $root = {
    name     => "ROOT",
    level    => -1,
    children => [],
};

my @stack;
push @stack, $root;

while (<DATA>) {
    /^(\s*)(.*)/;
    my $indentation = length $1;
    my $name        = $2;
    while ( $indentation <= $stack[-1]{level} ) {
        pop @stack;
    }
    my $node = {
        name     => $name,
        level    => $indentation,
        children => [],
    };
    push @{ $stack[-1]{children} }, $node;
    push @stack, $node;
}

use Data::Dumper;
print Dumper($root);

__DATA__
Grocery Store
    Milk
    Juice
    Butcher
        Thin sliced ham
        Chuck roast
    Cheese
Cleaners
Home Center
    Door
    Lock
    Shims

