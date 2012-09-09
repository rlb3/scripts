package DarkRoast;

use strict;
use warnings;

use base 'Beverage';

sub new {
	my $class = shift;
	my $self = $class->SUPER::new;

	$self->{description} = 'Dark Roast';
	return $self;
}

sub cost {
	my $self = shift;

	return .99;
}

1;
