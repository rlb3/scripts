package Data;

use strict;
use warnings;

use Class::DBI::Loader;

Class::DBI::Loader->new(
    dsn       => "dbi:mysql:bluebird:wtwwwdb.wtamu.edu",
    user      => "robert",
    password  => "",
    namespace => "Bluebird",
);

sub join_sql {
    my $db    = $_[0];
    my $where = $_[1] || "";
    my $limit = $_[2] || "";

    my $sql = qq{
    SELECT
        %s.objid , %s.doctype, docmatrix.newdoctype, doctype.drawer,
        %s.primaryid, nsvo.objname, nsloc.stordetail, nsvoattach.xpos,
        nsvoattach.ypos, nsvoattach.page, nsattachment.data, stu.fname,
        stu.lname, stu.birthdate, stu.ssn,nsloc.createtime, nsloc.lastaccess
    FROM
        %s INNER JOIN nsvo
            ON %s.objid = nsvo.objid
        INNER JOIN nsloc
            ON nsvo.objid = nsloc.objid
        LEFT JOIN nsvoattach
            ON nsloc.objid = nsvoattach.objid
        LEFT JOIN nsattachment
            ON nsvoattach.attachid = nsattachment.attachid
        LEFT JOIN docmatrix
            ON %s.doctype = docmatrix.doctype
        LEFT JOIN doctype
            ON docmatrix.newdoctype = doctype.newdoctype
        LEFT JOIN stu
            ON %s.primaryid = stu.riscid
        %s
        %s
    };

    my @db = map { $db } ( 1 .. 7 );
    return sprintf $sql, @db, $where, $limit;
}

package Bluebird::Reg;

Bluebird::Reg->set_sql( get_all => qq{ %s } );

sub get_all {
    my $self = shift;

    my $db    = $_[0];
    my $where = $_[1] || "";
    my $limit = $_[2] || "";

    return $self->sth_to_objects(
        $self->sql_get_all( Data::join_sql( $db, $where, $limit ) ) );
}

package Bluebird::Fa;

Bluebird::Fa->set_sql( get_all => qq{ %s } );

sub get_all {
    my $self = shift;

    my $db    = $_[0];
    my $where = $_[1] || "";
    my $limit = $_[2] || "";

    return $self->sth_to_objects(
        $self->sql_get_all( Data::join_sql( $db, $where, $limit ) ) );
}

package Bluebird::Gc;

Bluebird::Gc->set_sql( get_all => qq{ %s } );

sub get_all {
    my $self = shift;

    my $db    = shift;
    my $limit = shift;

    return $self->sth_to_objects(
        $self->sql_get_all( Data::join_sql( $db, $limit ) ) );
}

package Bluebird::Po;

Bluebird::Po->set_sql( get_all => qq{ %s } );

sub get_all {
    my $self = shift;

    my $db    = shift;
    my $limit = shift;

    return $self->sth_to_objects(
        $self->sql_get_all( Data::join_sql( $db, $limit ) ) );
}

package Bluebird::NewFa;

Bluebird::NewFa->set_sql( get_all => qq{ %s } );

sub get_all {
    my $self = shift;

    my $db    = $_[0];
    my $where = $_[1] || "";
    my $limit = $_[2] || "";

    return $self->sth_to_objects(
        $self->sql_get_all( Data::join_sql( $db, $where, $limit ) ) );
}

1;
