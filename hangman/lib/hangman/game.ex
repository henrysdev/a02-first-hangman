defmodule Hangman.Game do

  defstruct(
    secret:      [],
    word_chars:  MapSet.new(),
    used_chars:  MapSet.new(),
    game_state:  :initializing,
    turns_left:  7,
    letters:     [],
    last_guess:  ""
  )

  def new_game() do
    secret  = Dictionary.random_word() |> String.codepoints
    %Hangman.Game{
      secret:     secret,
      word_chars: MapSet.new(secret),
      letters:    String.duplicate("_", length(secret)) |> String.codepoints
    }
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters:    game.letters,
      used:       game.used_chars |> MapSet.to_list(),
      last_guess: game.last_guess
    }
  end

  #               won?   old?   good?  turns_left
  defp next_state(true,  false, true,  turns), do: {:won, turns}
  defp next_state(_____, true,  ____,  turns), do: {:already_used, turns}
  defp next_state(false, false, true,  turns), do: {:good_guess, turns}
  defp next_state(false, false, false, 1),     do: {:lost, 0}
  defp next_state(false, false, false, turns), do: {:bad_guess, turns-1}
  
  defp fill_in(guess, [_h1 | t1], [guess | t2]), do: [guess | fill_in(guess, t1, t2)]
  defp fill_in(guess, [h1 | t1], [ _h2 | t2]),   do: [h1 | fill_in(guess, t1, t2)]
  defp fill_in(_guess, [], []), do: []

  def make_move(%Hangman.Game{game_state: :won} = game, _),  do: {game, tally(game)}
  def make_move(%Hangman.Game{game_state: :lost} = game, _), do: {game, tally(game)}
  def make_move(game, guess) do
    good? = MapSet.member?(game.word_chars, guess)
    old? = MapSet.member?(game.used_chars, guess)
    used_chars = MapSet.new(game.used_chars) |> MapSet.put(guess)
    won?  = MapSet.intersection(used_chars, game.word_chars) == game.word_chars
    
    {game_state, turns_left} = next_state(won?, old?, good?, game.turns_left)
    letters = fill_in(guess, game.letters, game.secret)
    
    updated_game = %Hangman.Game{
      game_state: game_state,
      turns_left: turns_left,
      letters:    letters,
      last_guess: guess,
      used_chars: used_chars,
      word_chars: game.word_chars,
      secret:     game.secret,
    }
    {updated_game, tally(updated_game)}
  end

end