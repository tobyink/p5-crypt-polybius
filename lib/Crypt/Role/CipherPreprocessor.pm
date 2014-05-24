use 5.008;
use strict;
use warnings;

package Crypt::Role::CipherPreprocessor;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

use Moo::Role;
use Text::Unidecode;
use namespace::sweep;

has substitutions => (
	is       => 'lazy',
);

sub _build_substitutions
{
	my $self = shift;
	return { 'J' => 'I' };
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

1;
