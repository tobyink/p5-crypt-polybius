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
