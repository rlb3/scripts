#!/usr/bin/perl

use strict;
use warnings;

use Espresso;
use DarkRoast;
use HouseBlend;
use Mocha;
use Whip;
use Soy;

my $beverage = Espresso->new;

print $beverage->getDescription . ' $'. $beverage->cost."\n";

my $beverage2 = DarkRoast->new;
$beverage2 = Mocha->new($beverage2);
$beverage2 = Mocha->new($beverage2);
$beverage2 = Whip->new($beverage2);

print $beverage2->getDescription . ' $'. $beverage2->cost."\n";

my $beverage3 = HouseBlend->new;
$beverage3 = Soy->new($beverage3);
$beverage3 = Mocha->new($beverage3);
$beverage3 = Whip->new($beverage3);

print $beverage3->getDescription . ' $'. $beverage3->cost."\n";
