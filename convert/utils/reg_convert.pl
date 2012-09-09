#!/usr/bin/perl

use strict;
use warnings;

use XML::Simple;
use YAML;

my $file = shift;

my $reg  = XMLin($file, forcearray => 1);

print Dump $reg;
