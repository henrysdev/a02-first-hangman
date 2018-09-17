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
    secret  = Dictionary.random_word()
      |> String.codepoints
    word_chars = MapSet.new(secret)
    letters = String.duplicate("_", length(secret))
      |> String.codepoints

    %Hangman.Game{
      secret:     secret,
      word_chars: word_chars,
      used_chars: MapSet.new(),
      letters:    letters
    }
  end


  def tally(game) do
    sorted_used = MapSet.to_list(game.used_chars)
      |> Enum.sort()
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters:    game.letters,
      used:       sorted_used,
      last_guess: game.last_guess
    }
  end


  defp det_game_state(true,  false,  turns)
    when turns > 0 do
      {:good_guess, turns}
  end

  defp det_game_state(false, false,  turns)
    when turns > 0 do
      {:bad_guess, turns - 1}
  end

  defp det_game_state(_____, true, turns)
    when turns > 0 do
      {:already_used, turns}
  end

  defp det_game_state(true,  false, 1) do
    {:won, 0}
  end

  defp det_game_state(false, false, 1) do
    {:lost, 0}
  end

  
  defp fill_in(letter, [ _h1 | t1 ], [ letter | t2 ]) do
    [ letter | fill_in(letter, t1, t2) ]
  end

  defp fill_in(letter, [ h1 | t1 ], [ _h2 | t2 ]) do
    [ h1 | fill_in(letter, t1, t2) ]
  end

  defp fill_in(_letter, [], []), do: []

  defp update_letters(game_state, _guess, letters, _secret) 
    when game_state in [:bad_guess, :already_used, :lost] do
      letters
  end

  defp update_letters(game_state, guess, letters, secret)
    when game_state in [:good_guess, :won] do
      fill_in(guess, letters, secret)
  end


  # returns a tuple containing the updated game
  # state and a tally
  def make_move(game, guess) do
    in_word?    = MapSet.member?(game.word_chars, guess)
    used_bfor?  = MapSet.member?(game.used_chars, guess)
    
    { game_state, turns_left } = det_game_state(in_word?, used_bfor?, game.turns_left)

    letters = update_letters(game_state, guess, game.letters, game.secret)

    new_shit = MapSet.new(game.used_chars)
      |> MapSet.put(guess)

    updated_game = %Hangman.Game{
      game_state: game_state,
      turns_left: turns_left,
      letters:    letters,
      secret:     game.secret,
      used_chars: new_shit,
      word_chars: game.word_chars,
      last_guess: guess
    }

    { updated_game, tally(updated_game) }

  end

end