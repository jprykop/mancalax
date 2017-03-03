package Games::MancalaX::Player;

use Moose;
use Moose::Util::TypeConstraints;

has 'playernum' => (
  is => 'ro',
  isa => subtype( 'Int' => where { $_ >= 0 } ),
  required => 1,
);

has 'slots' => (
  is => 'ro',
  isa => 'ArrayRef[Games::MancalaX::Slot]',
  required => 1,
  default => sub {[]},
);

has 'goal' => (
  is => 'rw',
  isa => 'Games::MancalaX::Slot',
);

no Moose::Util::TypeConstraints;

sub playnum2slot {
  my ($self,$playnum) = @_;
  return ${$self->slots}[$playnum-1];
}

sub score {
  my $self = shift;
  return $self->goal->tokens;
}

no Moose;
__PACKAGE__->meta->make_immutable;
