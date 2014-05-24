use 5.008;
use strict;
use warnings;

package Crypt::Role::CheckboardCipher;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

use Moo::Role;
use Const::Fast;
use POSIX qw( ceil );
use Types::Common::Numeric qw( PositiveInt SingleDigit );
use Types::Standard qw( ArrayRef Str );
use namespace::sweep;

has square_size => (
	is       => 'lazy',
	isa      => PositiveInt & SingleDigit,
);

requires 'alphabet';

sub _build_square_size {
	my $self = shift;
	my $letters = @{ $self->alphabet };
	return ceil(sqrt($letters));
}

has square => (
	is       => 'lazy',
	isa      => ArrayRef[ ArrayRef[Str] ],
);

sub _build_square
{
	my $self = shift;
	
	my @alphabet = @{ $self->alphabet };
	my $size = $self->square_size;
	
	const my @rows => map {
		my @letters = (
			splice(@alphabet, 0, $size),
			('') x $size,
		);
		const my @row => @letters[0..$size-1];
		\@row;
	} 1..$size;
	
	\@rows;
}

my $_build_lookups = sub
{
	my $self = shift;
	my ($want) = @_;
	
	my (%enc, %dec);
	my $square = $self->square;
	my $size   = $self->square_size;
	for my $i (0 .. $size-1)
	{
		my $row = $square->[$i];
		for my $j (0 .. $size-1)
		{
			my $clear  = $row->[$j];
			my $cipher = sprintf('%s%s', $i+1, $j+1);
			$enc{$clear}  = $cipher;
			$dec{$cipher} = $clear;
		}
	}
	
	const my $enc => \%enc;
	const my $dec => \%dec;
	$self->_set_lookup_enc($enc);
	$self->_set_lookup_dec($dec);
	$self->$want;
};

has _lookup_enc => (
	is       => 'lazy',
	writer   => '_set_lookup_enc',
	default  => sub { shift->$_build_lookups('_lookup_enc') },
);

has _lookup_dec => (
	is       => 'lazy',
	writer   => '_set_lookup_dec',
	default  => sub { shift->$_build_lookups('_lookup_dec') }
);

requires 'preprocess';

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
