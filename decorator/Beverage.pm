package Beverage;

use strict;
use warnings;

sub new {
	my $class = shift;

	bless { 
		description => 'Unknown Beverage'
	}, $class;
}

sub getDescription {
	return shift->{description};
}

1;
