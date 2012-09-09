#!/usr/bin/perl

use strict;
use warnings;

use Class::DBI::Loader;

Class::DBI::Loader->new(
    dsn       => "dbi:mysql:bluebird:wtwwwdb.wtamu.edu",
    user      => "robert",
    password  => "",
    namespace => "Bluebird",
);

Class::DBI::Loader->new(
    dsn       => "dbi:mysql:stu:wtwwwdb.wtamu.edu",
    user      => "robert",
    password  => "",
    namespace => "Stu",
);

my $reg_itr = Bluebird::NewFa->retrieve_all;

my %cache = ();
while ( my $reg = $reg_itr->next ) {
    next unless length $reg->primaryid == 7;
    my $riscid = $reg->primaryid;

    my $student = Stu::TblAccounts->retrieve($riscid);

    next unless $student;
    next unless $student->lname;
    next if ( $cache{$riscid} );

    $cache{$riscid} = 1;

    my $birthdate = birthdate( $student->birthdate );

    unless ( $birthdate =~ /\d{4}-\d{2}-\d{2}/xms ) {
        my $error = sprintf "%s\t\t Old Bday: %s\t Modified: %s\n", $riscid,
          $student->birthdate, $birthdate;
        open my $fh, ">>log.txt" or die;
        print $fh $error;
        close $fh;
    }

    printf "($riscid) %s, %s %s %s\n", $student->lname, $student->fname,
      $student->ssn, $birthdate;
    eval {
        Bluebird::Stu->find_or_create(
            {
                riscid    => $riscid,
                fname     => $student->fname,
                lname     => $student->lname,
                ssn       => ssn($student->ssn),
                birthdate => $birthdate,
            }
        );
    };
}


sub ssn {
    my $ssn = shift;

    $ssn =~ s/\-//g;
    return $ssn;
}

sub birthdate {
    my $birthdate = shift;

    return $birthdate if $birthdate =~ /\d{4}-\d{2}-\d{2}/xms;

    if ( $birthdate =~ m{/}xms ) {
        my ( $bmonth, $bday, $byear ) = split( m{/}, $birthdate );
        $birthdate = sprintf "%s-%s-%s", $byear, $bmonth, $bday;
    }
    elsif ( $birthdate =~ /\d{6}/xms ) {
        my $day = substr( $birthdate, 0, 2 );
        my $mon = substr( $birthdate, 2, 2 );
        my $year = substr( $birthdate, 4 );

        if ( length $year == 2 ) { $year = '19' . $year; }

        $birthdate = sprintf "%s-%s-%s", $year, $mon, $day;
    }
    else {
        $birthdate = "";
    }
    return $birthdate;
}

