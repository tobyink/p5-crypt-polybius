use 5.008;
use strict;
use utf8;
use warnings;

package Crypt::Role::GreekAlphabet;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.002';

use Moo::Role;
use Const::Fast;
use namespace::sweep;

const my $alphabet => [
	qw( Α Β Γ Δ Ε Ζ Η Θ Ι Κ Λ Μ Ν Ξ Ο Π Ρ Σ Τ Υ Φ Χ Ψ Ω )
];

sub alphabet { $alphabet }

sub preprocess
{
	my $self = shift;
	my $str = uc($_[0]);
	
	$str =~ tr/ΆΈΉΊΌΎΏΪΫ/ΑΕΗΙΟΥΩΙΥ/;
	$str;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Crypt::Role::GreekAlphabet - twenty-four letter Greek alphabet for classic cryptography

=head1 DESCRIPTION

This role provides a twenty-four letter alphabet for use in classic
cryptography. The letters are all uppercase.

=head2 Object Methods

=over

=item C<< alphabet >>

Returns the alphabet as an arrayref of letters.

=item C<< preprocess($str) >>

Perform pre-encipher processing on a string. The string is uppercased.
Common unicode codepoints correponding to Greek letters with diacritics
are replaced with the closest match from the alphabet.

Punctuation characters, spaces, etc are I<not> removed from the string.
It is the choice of the cipher whether to, say, pass them through
unchanged, or strip them from the ciphertext.

=back

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Crypt-Polybius>.

=head1 SEE ALSO

L<Crypt::Polybius::Greek>.

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

