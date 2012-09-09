package Files;

use strict;
use warnings;

use IO::All;
use Carp;

use Class::Std;
{
    my %base   :ATTR( :get<base> :set<base> );
    my %index  :ATTR;
    my %xml    :ATTR;
    my %images :ATTR;

    sub BUILD {
        my ( $self, $ident, $arg_ref ) = @_;

        unless ( $arg_ref->{base} =~ m{/$}xms ) {
            $arg_ref->{base} = $arg_ref->{base} . "/";
        }

        unless ( -d $arg_ref->{base} ) {
            `mkdir -p $arg_ref->{base}`;
            `mkdir -p $arg_ref->{base}/images`;
        }

        $base{$ident}   = $arg_ref->{base};
        $index{$ident}  = 'index.txt';
        $xml{$ident}    = 'xml';
        $images{$ident} = 'images/';

        $self->delete;
    }

    sub del_index {
        my $self = shift;

        my $ident = ident($self);
        my $base  = $base{$ident};
        my $index = $index{$ident};

        io( $base . $index )->unlink if -f $base . $index;
    }

    sub del_xml {
        my $self = shift;

        my $ident = ident($self);
        my $base  = $base{$ident};
        my $xml   = $xml{$ident};

        io( $base . $xml )->rmtree if -d $base . $xml;
        io( $base . $xml )->mkdir unless -d $base . $xml;
    }

    sub del_images {
        my $self = shift;

        my $ident  = ident($self);
        my $base   = $base{$ident};
        my $images = $images{$ident};

        io( $base . $images )->rmtree if -d $base . $images;
        io( $base . $images )->mkdir unless -d $base . $images;
    }

    sub delete {
        my $self = shift;

        $self->del_index();
        $self->del_xml();
        $self->del_images();
    }

    sub xml_filename {
        my $self = shift;

        my $id    = shift;
        my $ident = ident($self);
        my $base  = $base{$ident};
        my $xml   = $xml{$ident};

        my $path  = $base . $xml;
        my $count = 0;

        while (1) {
            if ( -f $path . '/' . $id . '-' . $count . '.xml' ) {
                $count++;
            }
            else {
                return $path . '/' . $id . '-' . $count . '.xml';
            }
        }
    }
}

1;
