#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

print Dumper [tokenize('one "two three" four')];

sub tokenize {
    my ($line) = @_;
    my $buffer;
    my @stash;
    my $in_double_quote = 0;
    my $in_single_quote = 0;
    foreach my $chr ( split //, $line ) {
        if ( $chr =~ /["]/ ) {
            $in_double_quote = !$in_double_quote;
        }
        if ( $chr =~ /[']/ ) {
            $in_single_quote = !$in_single_quote;
        }

        if ( $chr eq ' ' && (!$in_double_quote && !$in_single_quote) ) {
            push @stash, $buffer;
            $buffer = '';
        }
        else {
            $buffer .= $chr;
        }
    }
    return @stash, $buffer;
}

