#!/usr/bin/perl

use strict;
use warnings;

my $it = make_splitfile_iter(
    {
        read_limit  => 3000000,
        bytes_limit => 10000000,
        dir         => 'testdata',
    }
);

system('mkdir', 'tmp');

my $count = 1;
while ( my $chunk = $it->() ) {
    my $file = sprintf( "%s%05d", "tmp/test.tar.part", $count );
    if ( open( my $fh, '>', $file ) ) {
        print {$fh} $chunk;
        $count++;
        close $fh;
    }
    print '.......' . "\n";
}

sub make_splitfile_iter {
    my ($args)      = @_;
    my $read_limit  = $args->{'read_limit'};
    my $bytes_limit = $args->{'bytes_limit'};
    my $dir         = $args->{'dir'};

    if ( open( my $tar_h, "-|" ) || exec( 'tar', 'pcz', $dir ) ) {
        return sub {
            my $store;
            my $bytes = 0;
            while ( read( $tar_h, my $buffer, $read_limit ) ) {
                $bytes += $read_limit;
                $store .= $buffer;
                if ( $bytes > $bytes_limit ) {
                    return $store;
                }
                elsif ( eof($tar_h) ) {
                    return $store;
                }
            }
        };
    }
}
