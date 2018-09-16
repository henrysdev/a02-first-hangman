defmodule Hangman.Game do

  defstruct(
    secret_word: Dictionary.random_word(),
    game_state: :initializing,
    turns_left: 7,
    letters:    ["_"],
    used:       [],
    last_guess: "a"
  )

  def build_set(secret_word) do
    IO.puts("here")
    map = MapSet.new()
    charlist = String.codepoints(secret_word)
    build_set(map, charlist)
  end
  def build_set(map, [ h | _t ]) do
    MapSet.put(map, h)
    build_set(map, _t)
  end

  def new_game() do
    %Hangman.Game{}
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters:    game.letters,
      used:       game.used,
      last_guess: game.last_guess
    }
  end


  #defp handle_guess(guess, game) do
  #end

  # returns a tuple containing the updated game
  # state and a tally
  #def make_move(game, guess) do
  #  game.game_state = handle_guess(guess, game)
  #end

end