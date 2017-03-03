package Games::MancalaX::Slot;

use Moose;
use Moose::Util::TypeConstraints;

has 'player' => (
  is => 'ro',
  isa => 'Games::MancalaX::Player',
  required => 1,
  handles => [qw(playernum)],
);

has 'slotnum' => (
  is => 'ro',
  isa => subtype( 'Int' => where { $_ >= 0 } ),
  required => 1,
);

has 'playnum' => (
  is => 'ro',
  isa => subtype( 'Int' => where { $_ > 0 && $_ < 10 } ),
);

has 'is_goal' => (
  is => 'ro',
  isa => 'Bool',
  required => 1,
);

has 'tokens' => (
  is => 'rw',
  isa => subtype( 'Int' => where { $_ >= 0 } ),
  required => 1,
);

no Moose::Util::TypeConstraints;

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;
  my $opts = $class->$orig(@_);
  die "Slot cannot have both playnum and is_goal"
    if $$opts{'playnum'} && $$opts{'is_goal'};
  $$opts{'is_goal'} = 0 if $$opts{'playnum'};
  return $opts;
};

sub pickup {
  my $self = shift;
  my $inhand = $self->tokens;
  $self->tokens(0);
  return $inhand;
}

sub drop {
  my ($self,$count) = @_;
  $count ||= 1;
  $self->tokens($self->tokens + $count);
}

no Moose;
__PACKAGE__->meta->make_immutable;






