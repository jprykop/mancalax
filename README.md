# mancalax

MancalaX is a perl package for programming games of mancala.

It's currently only had a couple days of development, but it should work
properly for standard two-player games.

It includes an incredibly simple command line interface for playing a 
two player game (with both players sharing a keyboard) that exists 
mainly to test the underlying modules (it's not a particularly 
pleasant interface for actual play.)

Though still untested, the underlying module code supports adjusting
the number of players, the number of slots on each side of the board,
and the number of tokens that start in each slot.  The only rule 
clarification necessary for multiple players is that, when your last
token in a play is dropped in an empty slot on your side of the board,
you capture tokens from the next player to play.  This means a two player
game works exactly like a traditional two player game of mancala.

Hopefully soon it will include an AI to allow computer players,
hooks for storing game data in a database, and a web interface.

Copyright 2017 Jonathan Prykop

I'd probably readily put this out under GPL or similar if someone's 
interested in building on it, but until I figure out where I'm going
with this, all rights reserved.  If you're interested, please email 
jonathan at prykop dot com.