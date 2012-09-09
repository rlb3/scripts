package Opts;

use strict;
use warnings;

use Getopt::Long;
use YAML;
use Lingua::EN::Inflect qw/NO PL_V/;
use IO::Prompt;

my $conf = YAML::LoadFile( $INC[0] . "/../conf/db.conf" );

my $db     = '';
my $limit  = '';
my $list   = '';
my $offset = '';
my $help   = '';
my $batch  = '';
my $riscid = '';

GetOptions(
    "database|d=s" => \$db,
    "limit|l=s"    => \$limit,
    "offset|o=s"   => \$offset,
    "list|t"       => \$list,
    "help|h"       => \$help,
    "batch|b=s"    => \$batch,
    "ricid|i=s"    => \$riscid,
);

if ($list) {
    db_list();
}

if ($help) {
    usage();
}

unless ($db) {
    usage();
    exit;
}

if ( defined $limit and $limit =~ /\D/ ) {
    print "\nLimit must be an integer.\n";
    exit;
}

unless ( defined $conf->{$db} ) {
    print "\nDatabase $db not defined.\n";
    db_list();
}

$limit  = ($limit)  ? "LIMIT " . $limit   : "";
$offset = ($offset) ? "OFFSET " . $offset : "";

sub values {
    unless ( $limit or $offset or $batch or $riscid) {
        my $ans = prompt
          "This command will convert the whole database. Are you sure. [yn] ",
          -yesno;
        if ( $ans eq 'n' ) { exit }
    }

    if ( $offset and not $limit ) {
        print STDERR "Error: Offset without Limit.\n";
        exit;
    }

    if ( $limit and $offset ) {
        $limit = sprintf "%s %s", $limit, $offset;
    }

    my $where;
    if ($riscid) {
      $where = sprintf "WHERE %s.primaryid = %s", $db, $riscid;
    }

    return {
        db     => $db,
        module => $conf->{$db},
        limit  => $limit,
        batch  => $batch,
        where  => $where,
    };
}

sub db_list {
    my @db = map { $_ } keys %{$conf};
    print "There "
      . PL_V( "is", scalar @db ) . " "
      . NO( "database", scalar @db )
      . " defined for the system: ";
    print( join( ", ", @db ), "\n" );
    exit;
}

sub usage {

    print qq{
Usage: convert.pl -d <database> | [-l max_records] [-t] [-h] [-b batch_size]
    -d, --database
        Sets the name of the database to be converted.

    -l, --limit
        Sets the number of records to be pulled from the database.
        If it is not set all records will be pulled.

    -t, --list
        Pulls the list of databases that can be converted.

    -h, --help
        Display this help and exit.

    -b, --batch
        Will pull all record and create a folder with batch_size number
        of files.
};

    exit;
}

1;