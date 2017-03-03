package Games::MancalaX;

use Games::MancalaX::Game;

use Moose;

=head1 NAME

Games::MancalaX - packages for programming mancala games

=head1 SYNOPSIS

  use Games::MancalaX;

  # a traditional 2-player game on a traditional board
  $game = Games::MancalaX->newgame; #Games::MancalaX::Game object

  # or shake things up a bit
  $game = Games::MancalaX->newgame(
    num_players => 3, #at least 2
    num_slots   => 7, #per side, not counting goals, at least 2, max 9
    tokens_per_slot => 5, #to start, at least 3
  );

  # play the second slot on the current player's side
  $game->play(2);

  # find out who the current player is, first player is 1
  $curr_player = $game->player; #Games::MancalaX::Player object
  $curr_playernum = $game->playernum; #first player is 1

  # get an arrayref of all player objects, in numerical order
  $players = $game->players;

  # check if the game is over
  if ($game->gameover) {
    #...
  }

  # get the winning players as Games::MancalaX::Player objects
  # returns empty list if game isn't over
  @winners = $game->winners;

  # get a player's current score (number of tokens in their goal)
  $score = $player->score;

  # get an arrayref of the slots on a player's side, in order,
  # not counting their goal, as a Games::MancalaX::Slot object
  $slots = $player->slots;

  # get a player's goal as a Games::MancalaX::Slot object
  $slot = $player->goal;

  # get the number of tokens currently in the slot
  $count = $slot->tokens;

  # get all the plays in the current game, in order
  @plays = $game->plays;

  # get all the plays in the current game as a single string
  $gamestr = $game->gamestr;

  # create a game that's already been partially played
  # note that gamestr does not include game settings
  # if gamestr didn't use default settings, must specify those, too
  # mismatched gamestr and settings will probably cause a fatal error
  Games::MancalaX->newgame(
    'gamestr' => $gamestr
  );

=head1 DESCRIPTION

MancalaX provides an object-oriented interface for programming games
of mancala.  It can be used to easily program a traditional 2-player
game with 6 slots per side and 4 tokens in each slot to start, but 
the real joy comes from its ability to adjust the number of players, 
the number of slots on each side of the board, and the number
of starting tokens in each slot.

For the basic rules of mancala, please search the web.  The only rule 
clarification necessary for multiple players is that, when your last 
token in a play is dropped in an empty slot on your side of the board, 
you capture tokens from the next player to play (you still capture from
the "opposite" slot, e.g. with six slots per side, slot 2 captures from
the next player's slot 5.)  This means a two player game works exactly 
like a traditional two player game of mancala.

Number of players must be at least 2, otherwise it's not a game.

Number of slots on each side must be at least 2 in order to prevent
a trivial win on the first move, since the game is over when all slots
on one side are empty.  Number of slots on each side currently can be
no more than 9, to allow expression of every possible playable
game for a given configuration as a unique integer (this may be expanded 
to include zero and/or alphabet characters in the future.)

Number of starting tokens per slot must be at least 3, to prevent a
trivial win on the first move with two slots per side.

Other combinations of players/slots/tokens might also yield trivial
wins, I haven't done the math in detail--but if you'd like to explore 
that question, this module can surely help!

In the future, hopefully this will include AI to allow playing against
a computer informed by a stored database of games.  This is the reason
for the focus on easy stringification of games.

=cut

sub newgame {
  my $self = shift;
  return Games::MancalaX::Game->new(@_);
}

=head1 CAVEATS

Currently only traditional two player games have been tested.

Report any bugs to the email address listed below.

=head1 COPYRIGHT

Copyright 2017 Jonathan Prykop

I'd probably readily put this out under GPL or similar if someone's 
interested in building on it, but until I figure out where I'm going
with this, all rights reserved.  If you're interested, please email 
jonathan at prykop dot com.

=cut

no Moose;
__PACKAGE__->meta->make_immutable;
