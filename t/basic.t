#!/usr/bin/perl

use strict;
use Test::More tests => 5;

BEGIN {
  use_ok('Games::MancalaX');
}

# try pre-loading a simple game that's already been won
# game isn't particularly well played, but it includes a capture and a goal drop,
# so it's useful for concurrently testing that functionality
my $game = Games::MancalaX->newgame('gamestr' => '3415113141516');
isa_ok($game,'Games::MancalaX::Game') or BAIL_OUT('could not load test game');
my ($winner) = $game->winners;
isa_ok($winner,'Games::MancalaX::Player') or BAIL_OUT('could not load test winner');
cmp_ok($winner->playernum,'==',2,'correct winner');
cmp_ok($winner->score,'==',13,'correct score');

exit();
