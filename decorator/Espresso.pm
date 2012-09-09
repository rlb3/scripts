package Espresso;

use strict;
use warnings;

use base 'Beverage';

sub new {
	my $class = shift;
	my $self = $class->SUPER::new;

	$self->{description} = 'Espresso';
	return $self;
}

sub cost {
	my $self = shift;

	return 1.99;
}

1;
