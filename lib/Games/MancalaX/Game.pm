package Games::MancalaX::Game;

use Games::MancalaX::Slot;
use Games::MancalaX::Player;

use Moose;
use Moose::Util::TypeConstraints;

# need at least 2, to be able to call it a game
has 'num_players' => (
  is => 'ro',
  isa => subtype( 'Int' => where { $_ > 1 } ),
  default => 2,
);

# per player, not including goal slots
# at least 2, to avoid trivial win on first move
# less than 10, to describe each play as a positive integer
has 'num_slots' => (
  is => 'ro',
  isa => subtype( 'Int' => where { $_ > 1 && $_ < 10 } ),
  default => 6,
);

# at least 3, to avoid trivial win with 2 slots
has 'tokens_per_slot' => (
  is => 'ro',
  isa => subtype( 'Int' => where { $_ > 2 } ),
  default => 4,
);

has 'gamestr' => (
  is => 'rw',
  isa => subtype( 'Str' => where { $_ =~ /^\d*$/ } ),
  default => '',
);

has 'board' => (
  is => 'ro',
  isa => 'ArrayRef[Games::MancalaX::Slot]',
  default => sub {[]},
);

has 'players' => (
  is => 'ro',
  isa => 'ArrayRef[Games::MancalaX::Player]',
  default => sub {[]},
);

has 'player' => (
  is => 'rw',
  isa => 'Games::MancalaX::Player',
  handles => [qw(playernum)],
);

no Moose::Util::TypeConstraints;

sub BUILD {
  my $self = shift;

  my $slotnum = 0;
  foreach my $playernum (1..$self->num_players) {
    my $player = Games::MancalaX::Player->new(
      playernum => $playernum,
    );
    push @{$self->players}, $player;
    foreach my $playnum (1..$self->num_slots) {
      my $slot = Games::MancalaX::Slot->new(
        player => $player,
        slotnum => $slotnum,
        playnum => $playnum,
        tokens => $self->tokens_per_slot,
      );
      push @{$player->slots}, $slot;
      push @{$self->board}, $slot;
      $slotnum++;
    }
    my $slot = Games::MancalaX::Slot->new(
      player => $player,
      slotnum => $slotnum,
      tokens => 0,
      is_goal => 1,
    );
    $player->goal($slot);
    push @{$self->board}, $slot;
    $slotnum++;
  }

  $self->player(${$self->players}[0]);

  foreach my $play ($self->plays) {
    $self->_play($play);
  }

}

sub plays {
  my $self = shift;
  return split("",$self->gamestr);
}

sub play {
  my ($self,$play) = @_;
  $self->_play($play);
  $self->gamestr($self->gamestr . $play);
}

# does not add play to gamestr
sub _play {
  my ($self,$playnum) = @_;

  # basic sanity checks
  $self->_desc_die("Cannot play, game was already won")
    if $self->gameover;
  $self->_desc_die("Illegal slot $playnum")
    unless $playnum =~ /^\d$/
        && $playnum > 0
        && $playnum <= $self->num_slots;

  # get slot to pickup from
  my $slot = $self->player->playnum2slot($playnum);
  $self->_desc_die("Bad slot")
    unless $slot && !$slot->is_goal;

  # pickup from slot
  my $inhand = $slot->pickup;
  $self->_desc_die("Cannot play slot $playnum, no tokens in slot")
    unless $inhand;

  # drop tokens around board
  while ($inhand) {
    $slot = $self->nextslot($slot);
    next if $slot->is_goal && !$self->is_player($slot);
    $slot->drop;
    $inhand -= 1;
  }

  # check for capture
  if ($self->is_player($slot) && !$slot->is_goal && $slot->tokens == 1) {
    $self->player->goal->drop($slot->pickup);
    $self->player->goal->drop($self->oppslot($slot)->pickup);
  }

  # check for next player's turn
  unless ($slot->is_goal && $self->is_player($slot)) {
    $self->player($self->nextplayer);
  }
}

sub is_player {
  my ($self,$obj) = @_;
  return $obj->playernum == $self->playernum;
}

sub oppslot {
  my ($self,$slot) = @_;
  return $self->nextplayer->playnum2slot($self->num_slots - $slot->playnum + 1);
}

sub nextslot {
  my ($self,$slot) = @_;
  my $slotnum = $slot->slotnum + 1;
  $slotnum = 0 if $slotnum >= scalar(@{$self->board});
  return ${$self->board}[$slotnum];
}

sub nextplayer {
  my $self = shift;
  my $playernum = $self->playernum + 1;
  $playernum = 1 if $playernum > $self->num_players;
  return ${$self->players}[$playernum - 1];
}

sub gameover {
  my $self = shift;
  PLAYER:
  foreach my $player (@{$self->players}) {
    foreach my $slot (@{$player->slots}) {
      next PLAYER if $slot->tokens;
    }
    return 1;
  }
  return 0;
}

sub winners {
  my $self = shift;
  return () unless $self->gameover;
  my @winners = ();
  my $maxscore = 0;
  foreach my $player (@{$self->players}) {
    if ($player->score > $maxscore) {
      @winners = ($player);
      $maxscore = $player->score;
    } elsif ($player->score == $maxscore) {
      push @winners, $player;
    }
  }
  return @winners;
}

sub _desc_die {
  my ($self,$message) = @_;
  die $message . "\n" .
      "  Game:  " . $self->gamestr . "\n" .
      "  Board: " . join("-",map { $_->tokens } @{$self->board}) . "\n"
}

no Moose;
__PACKAGE__->meta->make_immutable;
