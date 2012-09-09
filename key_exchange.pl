#!/usr/bin/perl
use Test::More tests => 10000;

srand(time);

my $a = 434231;


for (1 .. 10_000) {
    my $b = int(rand(10000000000) + 1);
    my $c = int(rand(10000000000) + 1);

    my $x = $a ^ $b;
    my $y = $a ^ $c;

    my $z1 = $x ^ $c;
    my $z2 = $y ^ $b;

    diag(sprintf "Test %d\n\tRANDOM NUM1: %s\n\tRANDOM NUM2: %s\n\n\tSHARED KEY1: %s \n\tSHARED KEY2: %s\n\n\tSECRET KEY: %s\n\n", $_, $b, $c, $x, $y, $z1);
    ok($z1 == $z2);
}
