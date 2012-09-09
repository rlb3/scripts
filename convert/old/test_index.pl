#!/usr/bin/perl

use strict;
use warnings;

use Template;
use DBI;

my $tt = Template->new( { INCLUDE_PATH => 'templates/' } );

open my $fh, ">convert/index.txt" or die "Cannot open file.";

my $dbh = DBI->connect( "dbi:mysql:bluebird", "robert", "" )
    or die "Cannot connect to data base";

my $sql = qq{
    SELECT
        reg.objid, reg.doctype, docmatrix.newdoctype, doctype.drawer,
        reg.primaryid, nsvo.objname, nsloc.stordetail, nsvoattach.xpos,
        nsvoattach.ypos, nsvoattach.page, nsattachment.data, stu.fname,
        stu.lname, stu.birthdate, stu.ssn,nsloc.createtime, nsloc.lastaccess
    FROM
        reg INNER JOIN nsvo
            ON reg.objid = nsvo.objid
        INNER JOIN nsloc
            ON nsvo.objid = nsloc.objid
        LEFT JOIN nsvoattach
            ON nsloc.objid = nsvoattach.objid
        LEFT JOIN nsattachment
            ON nsvoattach.attachid = nsattachment.attachid
        LEFT JOIN docmatrix
            ON reg.doctype = docmatrix.doctype
        LEFT JOIN doctype
            ON docmatrix.newdoctype = doctype.newdoctype
        LEFT JOIN stu
            ON reg.primaryid = stu.riscid
};

my $sth = $dbh->prepare($sql) or die("Unable to prepare sql.");

$sth->execute;

while ( my $row = $sth->fetchrow_arrayref ) {

    my @data;

    my $drawer = $row->[3] || "";

    my $folder = $row->[4] || "";
    my $tab =
        ( defined $row->[12] )
        ? sprintf( "%s, %s ", $row->[12], $row->[11] )
        : "";
    my $f3    = $row->[14] || "";
    my $f4    = $row->[13] || "";
    my $f5    = $row->[2]  || "";
    my $page  = $row->[9]  || "";
    my $image = $row->[6]  || "";
    my $xmlfile = ( $row->[4] ) ? sprintf( "%s.xml", $row->[4] ) : "";
    my $xpos = $row->[7]  || "";
    my $ypos = $row->[8]  || "";
    my $data = $row->[10] || "";
    $data =~ s/\s+$//;
    $data =~ s/\n$//;
    my $createtime = $row->[15] || "";
    my $lastaccess = $row->[16] || "";

    my %data = (
        drawer     => $drawer,
        folder     => $folder,
        tab        => $tab,
        f3         => $f3,
        f4         => $f4,
        f5         => $f5,
        page       => $page,
        xpos       => $xpos,
        ypos       => $ypos,
        data       => $data,
        createtime => $createtime,
        lastaccess => $lastaccess,
    );

    open my $fh2, ">convert/xml/$xmlfile" or die "Can't open $xmlfile.";

    my $output;
    $tt->process( 'ano.tt', \%data, \$output );
    print $fh2 $output;

    push @data,
        ( $drawer, $folder, $tab, $f3, $f4, $f5, $page, $image, $xmlfile );

    printf $fh "^%s^%s^%s^%s^%s^%s^%s^%s^%s^\n", @data;
}
