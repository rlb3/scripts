#!/usr/bin/perl

use strict;
use warnings;

use Template;
use IO::All;

use FindBin;
use lib $FindBin::Bin. "/lib";

use Data;

my $tt = Template->new( { INCLUDE_PATH => 'templates/' } );

my $reg_itr = Bluebird::Reg->get_all("LIMIT 20");

while ( my $reg = $reg_itr->next ) {

    my $xml = xml_filename( $reg->{primaryid} );

    reg_index( $reg, $xml );
    xml_file( $reg, $xml );
}

sub xml_file {
    my $reg = shift;
    my $xml = shift;

    my $name =
        ( defined $reg->{lname} )
        ? sprintf( "%s, %s", $reg->{lname}, $reg->{fname} )
        : "";
    $reg->{data} =~ s/\s+$// if $reg->{data};
    $reg->{data} =~ s/\n//g  if $reg->{data};

    my %data = (
        drawer     => $reg->{drawer},
        folder     => $reg->{primaryid},
        tab        => $name,
        f3         => $reg->{ssn},
        f4         => $reg->{birthdate},
        f5         => $reg->{newdoctype},
        page       => $reg->{page},
        xpos       => $reg->{xpos},
        ypos       => $reg->{ypos},
        data       => $reg->{data},
        createtime => $reg->{createtime},
        lastaccess => $reg->{lastaccess},
    );

    my $output;
    $tt->process( 'ano.tt', \%data, \$output );

    $output > io($xml);

}

sub xml_filename {
    my $id = shift;

    my $count = 0;

    while (1) {
        if ( -f "convert/xml/$id-$count.xml" ) {
            $count++;
        }
        else {
            return "convert/xml/$id-$count.xml";
        }

    }

}

sub reg_index {
    my $reg = shift;
    my $xml = shift;

    my $name =
        ( defined $reg->{lname} )
        ? sprintf( "%s, %s", $reg->{lname}, $reg->{fname} )
        : "";

    my $vars = {
        drawer    => $reg->{drawer}     || "",
        riscid    => $reg->{primaryid}  || "",
        name      => $name              || "",
        ssn       => $reg->{ssn}        || "",
        birthdate => $reg->{birthdate}  || "",
        doctype   => $reg->{newdoctype} || "",
        page      => $reg->{page}       || "",
        image     => $reg->{stordetail} || "",
        xml       => $xml               || "",
    };

    my $output;
    $tt->process( 'index.tt', $vars, \$output );

    $output >> io('convert/index.txt');

}
