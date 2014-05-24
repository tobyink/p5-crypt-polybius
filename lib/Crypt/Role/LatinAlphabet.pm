use 5.008;
use strict;
use warnings;

package Crypt::Role::LatinAlphabet;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

use Moo::Role;
use Const::Fast;
use Text::Unidecode;
use namespace::sweep;

const my $alphabet => [ 'A' .. 'I', 'K' .. 'Z' ];

sub alphabet { $alphabet }

sub preprocess
{
	my $self = shift;
	
	my $str = unidecode uc($_[0]);	
	$str =~ s/J/I/g;
	$str;
}

1;
