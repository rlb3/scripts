package Mocha;

use strict;
use warnings;

use base 'CondimentDecorator';

sub new {
	my $class = shift;

	my $self = $class->SUPER::new;
	$self->{beverage} = shift;
	return $self;
}

sub getDescription {
	my $self = shift;
	return $self->{beverage}->getDescription . ', Mocha';
}

sub cost {
	my $self = shift;

	return .20 + $self->{beverage}->cost;
}

1;
