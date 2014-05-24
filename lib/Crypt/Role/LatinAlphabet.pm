use 5.008;
use strict;
use warnings;

package Crypt::Role::LatinAlphabet;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '0.001';

use Moo::Role;
use Const::Fast;
use namespace::sweep;

const my $alphabet => [ 'A' .. 'I', 'K' .. 'Z' ];

sub alphabet { $alphabet }

1;
