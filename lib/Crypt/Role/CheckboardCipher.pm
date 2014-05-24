use 5.008;
use strict;
use warnings;

package Crypt::Role::CheckboardCipher;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

use Moo::Role;
use namespace::sweep;

has square => (
	is       => 'lazy',
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

my $_build_lookups = sub
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
