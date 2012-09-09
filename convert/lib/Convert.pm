package Convert;

use strict;
use warnings;

use IO::All;
use Template;
use File::Basename;
use Class::Std;
{

    my %reg  :ATTR( :get<reg>  :set<reg> );
    my %xml  :ATTR( :get<xml>  :set<xml> );
    my %base :ATTR( :get<base> :set<base> );
    my $tt = Template->new( { INCLUDE_PATH => 'templates/' } );

    sub BUILD {
        my ( $self, $ident, $args_ref ) = @_;

        $reg{$ident}  = $args_ref->{reg};
        $xml{$ident}  = $args_ref->{xml};
        $base{$ident} = $args_ref->{base};
    }

    sub index {
        my $self  = shift;
        my $ident = ident($self);

        my $reg  = $reg{$ident};
        my $xml  = $xml{$ident};
        my $base = $base{$ident};
        my $ext  = '.tif';

        # Just leave xml\
        $xml =~ s{$base}{};
        $xml =~ s{/}{\\}g;

        # Windows style path
        my $win_dir = ( split( m{/}, $base ) )[-1];
        $win_dir = sprintf "C:\\%s\\", $win_dir;

        my $name =
          ( defined $reg->{lname} )
          ? sprintf( "%s, %s", $reg->{lname}, $reg->{fname} )
          : "";

        # If the images doesn't exist, why bother?
        return unless $reg->{stordetail};

        # Grab image basename.
        my $image;
        ( $image = $reg->{stordetail} ) =~ s{\\}{/}g;
        my $image_basename = basename($image);


        # Look for images on bluebird harddrive.
        if ( $image =~ /LOCAL/i ) {

            # Find all directories that deal with local storage.
            my @d_mount = `ls /mnt/d`;
            my @storage = grep { /storage/i } @d_mount;
            chomp @storage;

            # Find files that are under one of the local storage directories.
            my @pick = grep { -f "/mnt/d/" . $_ . '/' . $image } @storage;
            if ( scalar @pick ) {
                my $cmd = "/mnt/d/"
                  . $pick[0] . '/'
                  . $image . ' '
                  . $base
                  . "images/"
                  . $image_basename
                  . $ext;
                `cp $cmd`;
            }
            else {

                # Can't find image. Having two of these smells wrong.
                printf "id: %s | file: %s\n", $reg->{primaryid}, $image;
                return;
            }

        }
        else {

            # Look for images on the optical drive.
            if ( -f "/mnt/o/" . $image ) {
                my $cmd =
                    "/mnt/o/" . $image . ' ' . $base
                  . "images/"
                  . $image_basename
                  . $ext;
                `cp $cmd`;
            }
            else {

                # Can't find image. Having two of these smells wrong.
                printf "id: %s | file: %s\n", $reg->{primaryid}, $image;
                return;
            }
        }

        $reg->{stordetail} =~ s{/}{\\}g;
        $reg->{stordetail} = "images\\" . $image_basename . $ext;

        $xml = ($reg->{data}) ? $win_dir . $xml : "";

        my $vars = {
            drawer    => $reg->{drawer}                || "FA_Admin",
            riscid    => $reg->{primaryid}             || "",
            name      => $name                         || "",
            ssn       => $reg->{ssn}                   || "",
            birthdate => birthday( $reg->{birthdate} ) || "",
            doctype   => $reg->{newdoctype}            || $reg->{doctype},
            page      => $reg->{page}                  || "",
            image     => $win_dir . $reg->{stordetail} || "",
            xml       => $xml                          || "",
        };

        my $output;
        $tt->process( 'index.tt', $vars, \$output );

        $output >> io( $base . 'index.txt' );
        $reg->{stordetail} = '';
    }

    sub ssn {
        my $ssn = shift;

        $ssn =~ s/-//g;
        return $ssn;
    }

    sub birthday {
        my $bday = shift;

        return unless $bday;

        my ( $year, $mon, $day ) = split /-/, $bday;

        return sprintf "%s%s%s", $mon, $day, $year;
    }

    sub xml {

        my $self  = shift;
        my $ident = ident($self);

        my $reg  = $reg{$ident};
        my $xml  = $xml{$ident};
        my $base = $base{$ident};

        # If the data doesn't exist, why bother?
        return unless $reg->{data};

        my $name =
          ( defined $reg->{lname} )
          ? sprintf( "%s, %s", $reg->{lname}, $reg->{fname} )
          : "";
    
        # Clean up ending spaces and newlines.
        $reg->{data} =~ s/\s+$//
          if $reg->{data};
        $reg->{data} =~ s/\n//g
          if $reg->{data};

        my %data = (
            drawer     => $reg->{drawer} || "Records",
            folder     => $reg->{primaryid},
            tab        => $name,
            f3         => $reg->{ssn},
            f4         => birthday( $reg->{birthdate} ) || "",
            f5         => $reg->{newdoctype} || $reg->{doctype},
            page       => $reg->{page},
            xpos       => $reg->{xpos} || 100,
            ypos       => $reg->{ypos} || 100,
            data       => $reg->{data},
            createtime => $reg->{createtime},
            lastaccess => $reg->{lastaccess},
        );

        my $output;
        $tt->process( 'ano.tt', \%data, \$output );

        $output > io($xml);

    }

    sub run {
        my $self  = shift;
        my $ident = ident($self);
        my $base  = $base{$ident};

        $self->index;
        $self->xml;
    }

}
