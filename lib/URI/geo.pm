package URI::geo;

require URI::_generic;
use vars qw(@ISA $VERSION);

$VERSION = "1.00";
@ISA = qw(URI::_generic);

use strict;
use warnings;
no warnings 'uninitialized';

# TODO: how to handle "geo:,,"?

sub latlng
{
  my $self = shift;

  if ($self->opaque =~ /^(?:([^;,]+),([^;,]+))?(.*)/ and @_) {
    defined $_[0] ? $self->opaque("$_[0],$_[1]$3")
                  : $self->opaque("$3")
  }

  return unless defined $1;
  return ($1, $2);
}

sub altitude
{
  my $self = shift;

  if ($self->opaque =~ /^([^;,]*,[^;,]*)?(?:,([^;,]*))?(.*)/ and @_) {
    defined $_[0] ? $self->opaque("$1,$_[0]$3")
                  : $self->opaque("$1$3")
  }

  return $2;
}

sub crs
{
  my $self = shift;

  if ($self->opaque =~ /^([0-9.,-]*)(;crs=([^;]*))?(.*)/ and @_) {
    defined $_[0] ? $self->opaque("$1;crs=$_[0]$4")
                  : $self->opaque("$1$4")
  }

  return defined $2 ? $3 : "wgs84";
}

sub uncertainty
{
  my $self = shift;

  if ($self->opaque =~ /^([0-9.,-]*(?:;crs=[^;]*)?)?(;u=([^;]*))?(.*)/ and @_) {
    defined $_[0] ? $self->opaque("$1;u=$_[0]$4")
                  : $self->opaque("$1$4");
  }

  return unless defined $2;
  return $3;
}

sub parameters
{
  my $self = shift;
  
  $self->opaque =~ /^([0-9.,-]*(?:;crs=[^;]*)?(?:;u=[^;]*)?)(?:;(.*))?/;

  my $para = $1;

  my @old = map { /^([^=]*)(?:=(.*))?/; ($1, $2) } split /;/, $2;
  
  if (defined $_[0]) {
    for (my $i = 0; $i <= $#_; $i++) {
      $para .= ";" . $_[$i];
      $para .= "=" . $_[$i] if defined $_[++$i];
    }
  }

  $self->opaque($para) if @_;
  return @old;
}

sub is_valid
{
  my $self = shift;

  return $self->opaque =~
  / ^
    (?:-?[0-9]+(?:\.[0-9]+)?),      # coord-a,
    (?:-?[0-9]+(?:\.[0-9]+)?)       # coord-b
    (?:,(?:-?[0-9]+(?:\.[0-9]+)?))? # [ "," coord-c ]
    (?:;crs=[a-zA-Z0-9-]+)?         # ";crs=" crslabel
    (?:;u=[0-9]+(?:\.[0-9]+)?)?     # ";u=" uval
    (?:;[a-zA-Z0-9-]+               # ";" pname with optional value
    (?:=(?:%[a-fA-F0-9]{2}|[\[\]:&+\$a-zA-Z0-9\-_.!~*'()])+)?)
    *                               # any number of parameters
    $
  /x
}

1;

__END__

=head1 NAME

URI::geo - URI that contains a geographic location

=head1 SYNOPSIS

  use URI;

  $u = URI->new('geo:');
  $u->latlng(13.4125, 103.8667);
  print "$u\n";

=head1 DESCRIPTION

The C<URI::geo> class supports C<URI> objects belonging to the I<geo>
URI scheme. The I<data> URI scheme is specified in RFC 5879. It allows
the identification of a physical location in a two- or three-dimensional
coordinate reference system. The default reference system is the World
Geodetic System 1984 (WGS-84).

C<URI> objects belonging to the geo scheme support the common methods
(described in L<URI>) and the following scheme-specific methods:

=over 4

=item $uri->latlng( [$new_latitude, $new_longitude] )

Sets or gets the latitude and longitude measured in decimal degrees in
the default reference system.

=item $uri->altitude( [$new_altitude] )

Sets or gets the altitude measured in meters in the default reference
system. Passing C<undef> removes the value;

=item $uri->uncertainty( [$new_uncertainty] )

Sets or gets the location uncertainty parameter that indicates the
amount of uncertainty in the location measured in meters. Passing
C<undef> removes the value.

=item $uri->crs( [$new_crs] )

Sets or gets the coordinate reference system for the coordinates in
the URI. If no reference system is specified, then the default value
C<"wgs84"> is returned. Passing C<undef> removes the value;

=item $uri->parameters( [$name => $value, ...] )

Sets or gets extension parameters; C<undef> represents absent values.
Passing C<undef> removes all parameters;

=item $uri->is_valid()

Returns true if and only if the URI matches the grammar in RFC 5879.
This is not a complete validity check, for example, requirements that
are specific to a reference system are not checked, but can be useful
when handling potentially invalid URIs as, for instance, accessors
like C<latlng> do not ensure the values returned are proper numbers.

=back

=head1 SEE ALSO

L<URI>

=head1 AUTHOR / COPYRIGHT / LICENSE

  Copyright (c) 2008-2009 Bjoern Hoehrmann <bjoern@hoehrmann.de>.
  This module is licensed under the same terms as Perl itself.

=cut
