#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Bin. "/lib";

# Local Modules
use Opts;
use Data;
use Convert;
use Files;

# Setting Command line options
my $opts   = Opts->values;
my $module = $opts->{module};
my $db     = $opts->{db};
my $limit  = $opts->{limit};
my $batch  = $opts->{batch};
my $where  = $opts->{where};

# Using Class::DBI to get database info
# and test to see if $module is complete
my $reg_itr;
if ( $module->can('get_all') ) {
    $reg_itr = $module->get_all( $db, $where, $limit );
}
else {
    die "get_all() has not been implemented for $module.\n";
}

# Set Count vars for Directory naming
my $count       = 1;
my $batch_count = 1;


# Creating first dir for file storage
my $files = Files->new( { base => base( $db, $batch_count ) } );

# Begin loop over Class::DBI::Iterator
my $convert;
while ( my $reg = $reg_itr->next ) {

    my $xml = $files->xml_filename( $reg->{primaryid} );

    $convert =
      Convert->new( { reg => $reg, xml => $xml, base => $files->get_base() } );
    $convert->run();

    # Test for building mulipule batch directories
    if ($batch) {
        $count++;
        if ( ( ( $count % $batch ) == 0 ) ) {

            # Seed new Files object
            $batch_count++;
            $files = Files->new( { base => base( $db, $batch_count ) } );
        }
    }
}

sub base {
    my ( $db, $count ) = @_;
    return sprintf "convert/%s%03d", $db, $count;
}

=pod

=head1 Usage

    Usage: convert.pl -d <database> | [-l max_records] [-t] [-h] [-b batch_size]

        -d, --database
            Sets the name of the database to be converted.

        -l, --limit
            Sets the number of records to be pulled from the database.
            If it is not set all records will be pulled.

        -t
            Pulls the list of databases that can be converted.

        -h, --help
            Display this help and exit.

        -b, --batch
            Will pull all record and create a folder with batch_size number
            of files.
    


=head1 Author

    Robert Boone
    Aug 24, 2005
    West Texas A&M University

=cut

