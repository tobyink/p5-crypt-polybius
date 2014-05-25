use 5.008;
use strict;
use warnings;

package Crypt::Polybius::Greek;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

use Moo;
use Text::Unidecode;
use namespace::sweep;

with qw(
	MooX::Traits
	Crypt::Role::CheckerboardCipher
	Crypt::Role::GreekAlphabet
);

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Crypt::Polybius::Greek - implementation of the Polybius square using the Greek alphabet

=head1 SYNOPSIS

   use utf8;
   use Crypt::Polybius;
   
   #      1    2    3    4    5
   # 1    Α    Β    Γ    Δ    Ε
   # 2    Ζ    Η    Θ    Ι    Κ
   # 3    Λ    Μ    Ν    Ξ    Ο
   # 4    Π    Ρ    Σ    Τ    Υ
   # 5    Φ    Χ    Ψ    Ω
   #
   # Άλφα  ->  11 31 51 11
   
   my $square = Crypt::Polybius::Greek->new;
   
   print $square->encipher("Άλφα"), "\n";

=head1 DESCRIPTION

This module provides an object-oriented implementation of the
B<Polybius square>, or B<Polybius checkerboard> using the
Greek alphabet. This cipher is not cryptographically strong,
nor completely round-trip-safe. And it requires you to write in
Greek.

=head2 Roles

This class performs the following roles:

=over

=item *

L<Crypt::Role::GreekAlphabet>

=item *

L<Crypt::Role::CheckerboardCipher>

=item *

L<MooX::Traits>

=back

=head2 Constructors

=over

=item C<< new(%attributes) >>

Moose-like constructor.

=item C<< new_with_traits(%attributes, traits => \@traits) >>

Alternative constructor provided by L<MooX::Traits>.

=back

=head2 Attributes

The following attributes exist. All of them have defaults, and should
not be provided to the constructor.

=over

=item C<< square >>

An array of arrays of letters. Provided by
L<Crypt::Role::CheckerboardCipher>.

=item C<< square_size >>

The length of one side of the square, as an integer. Provided by
L<Crypt::Role::CheckerboardCipher>.

=item C<< encipher_hash >>

Hashref used by the C<encipher> method. Provided by
L<Crypt::Role::CheckerboardCipher>.

=item C<< decipher_hash >>

Hashref used by the C<decipher> method. Provided by
L<Crypt::Role::CheckerboardCipher>.

=back

=head2 Object Methods

=over

=item C<< encipher($str) >>

Enciphers a string and returns the ciphertext. Provided by
L<Crypt::Role::CheckerboardCipher>.

=item C<< decipher($str) >>

Deciphers a string and returns the plaintext. Provided by
L<Crypt::Role::CheckerboardCipher>.

=item C<< preprocess($str) >>

Perform pre-encipher processing on a string. C<encipher> calls this, so
you are unlikely to need to call it yourself.

The implementation provided by L<Crypt::Role::GreekAlphabet> uppercases
any lower-case letters, and handles most common Greek diacritics.

=item C<< alphabet >>

Returns an arrayref of the known alphabet. Provided by
L<Crypt::Role::GreekAlphabet>.

=back

=head2 Class Method

=over

=item C<< with_traits(@traits) >>

Generates a new class based on this class, but adding traits.

L<Crypt::Role::ScrambledAlphabet> is an example of an interesting
trait that works with this class.

=back

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Crypt-Polybius>.

=head1 SEE ALSO

L<http://en.wikipedia.org/wiki/Polybius_square>.

L<Crypt::Polybius>.

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

