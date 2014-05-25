use 5.008;
use strict;
use warnings;

package Crypt::Role::ScrambledAlphabet;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

use Moo::Role;
use Const::Fast;
use Types::Common::String qw(Password);
use namespace::sweep;

has password => (
	is       => 'lazy',
	isa      => Password,
	required => !!1,
);

around alphabet => sub
{
	my $next = shift;
	my $self = shift;
	my $orig = $self->$next(@_);
	
	my %allowed_letters;
	$allowed_letters{$_}++ for @$orig;
	
	my @letters = grep $allowed_letters{$_}, split '', $self->password;
	push @letters, @$orig;
	
	my %seen;
	return [ grep !$seen{$_}++, @letters ];
};

1;
