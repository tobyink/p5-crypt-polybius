use 5.008;
use strict;
use warnings;

package Crypt::Polybius;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

use Moo;
use Text::Unidecode;

has square => (
	is       => 'lazy',
);

has substitutions => (
	is       => 'lazy',
);

has _lookup_enc => (
	is       => 'lazy',
	writer   => '_set_lookup_enc',
	builder  => sub { shift->_lookups('_lookup_enc') },
);

has _lookup_dec => (
	is       => 'lazy',
	writer   => '_set_lookup_dec',
	builder  => sub { shift->_lookups('_lookup_dec') }
);

sub _build_square
{
	my $self = shift;
	return [
		[qw/ A B C D E /],
		[qw/ F G H I K /],
		[qw/ L M N O P /],
		[qw/ Q R S T U /],
		[qw/ V W X Y Z /],
	];
}

sub _build_substitutions
{
	my $self = shift;
	return { 'J' => 'I' };
}

sub _lookups
{
	my $self = shift;
	my ($want) = @_;
	
	my (%enc, %dec);
	my $square = $self->square;
	for my $i (0 .. $#$square)
	{
		die if $i > 8;
		my $row = $square->[$i];
		for my $j (0 .. $#$row)
		{
			die if $j > 8;
			my $clear  = $row->[$j];
			my $cipher = sprintf('%s%s', $i+1, $j+1);
			$enc{$clear}  = $cipher;
			$dec{$cipher} = $clear;
		}
	}
	
	$self->_set_lookup_enc(\%enc);
	$self->_set_lookup_dec(\%dec);
	$self->$want;
}

sub preprocess
{
	my $self = shift;
	my ($str) = unidecode uc($_[0]);
	
	my $subst = $self->substitutions;
	my $re    = join "|", map quotemeta, keys %$subst;
	$str =~ s/($re)/$subst->{$1}/eg;
	$str =~ s/[^A-Z]//g;
	$str;
}

sub encipher
{
	my $self = shift;
	my $str  = $self->preprocess($_[0]);
	
	my %enc = %{ $self->_lookup_enc };
	$str =~ s/(.)/$enc{$1}." "/eg;
	chop $str;
	return $str;
}

sub decipher
{
	my $self = shift;
	my $str  = $_[0];
	
	my %dec = %{ $self->_lookup_dec };
	$str =~ s/[^0-9]//g;
	$str =~ s/([0-9]{2})/$dec{$1}/eg;
	return $str;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Crypt::Polybius - implementation of the Polybius square

=head1 SYNOPSIS

   use Crypt::Polybius;
   
   #      1    2    3    4    5
   # 1    A    B    C    D    E
   # 2    F    G    H    I/J  K
   # 3    L    M    N    O    P
   # 4    Q    R    S    T    U
   # 5    V    W    X    Y    Z
   #
   # ATTACK  ->  11 44 44 11 13 25
   # AT      ->  11 44
   # DAWN    ->  14 11 52 33
   
   my $square = Crypt::Polybius->new;
   
   print $square->encipher('Attack at dawn.'), "\n";

=head1 DESCRIPTION

This module provides an implementation of the B<Polybius square>, or
B<Polybius checkerboard>. This cipher is not cryptographically strong,
nor completely round-trip-safe.

=head2 Constructor

=over

=item C<< new(%attributes) >>

Moose-like constructor.

=back

=head2 Attributes

=over

=item C<< square >>

An array of arrays of letters. The default is:

   [
      [qw/ A B C D E /],
      [qw/ F G H I K /],
      [qw/ L M N O P /],
      [qw/ Q R S T U /],
      [qw/ V W X Y Z /],
   ]

=item C<< substitutions >>

A hashref of strings of pre-encipher substitutions to make. The default
is:

   { "J" => "I" }

You should only use upper-case letters.

=back

=head2 Methods

=over

=item C<< encipher($str) >>

Enciphers a string and returns the ciphertext.

=item C<< decipher($str) >>

Deciphers a string and returns the plaintext.

=item C<< preprocess($str) >>

Perform pre-encipher processing on a string. C<encipher> calls this, so
you are unlikely to need to call it yourself.

=back

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Crypt-Polybius>.

=head1 SEE ALSO

L<http://en.wikipedia.org/wiki/Polybius_square>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2014 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

