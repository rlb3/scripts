package HouseBlend;

use strict;
use warnings;

use base 'Beverage';

sub new {
	my $class = shift;
	my $self = $class->SUPER::new;

	$self->{description} = 'House Blend Coffee';
	return $self;
}

sub cost {
	my $self = shift;

	return .89;
}

1;
