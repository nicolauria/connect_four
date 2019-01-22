## Install

cd into root and run
```
rake install
```

## Run Program

See game options below for additional features. For the main program:
```
captains_mistress
```

## Game Options
set **width** & **height** of game board
```
captains_mistress --width 10 --height 8
```

set **length** of winning streak
```
captains_mistress --length 5
```

turn on **strict** mode (winning streak must be exact length)
```
captains_mistress --strict
```

all above options can be combined
```
captains_mistress --width 10 --height 8 --length 5 --strict
```

## Program Code

game options specified in exe/captains_mistress<br>
program contained in lib/captains_mistress/app.rb

## Tests (Rspec)

currently there are 4 tests that validate the **check_game_for_winner?(col)** method
