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


  defp det_game_state(true,  false, 1) do
    {:won, 0}
  end
  defp det_game_state(false, false, 1) do
    {:lost, 0}
  end
  defp det_game_state(true,  false,  turns) when turns > 0 do
    {:good_guess, turns - 1}
  end
  defp det_game_state(false, false,  turns) when turns > 0 do
    {:bad_guess, turns - 1}
  end
  defp det_game_state(_____, true, turns) when turns > 0 do
    {:already_used, turns}
  end

  
  defp fill_in(letter, [ h1 | t1 ], [ letter | t2 ]) do
    [ letter | fill_in(letter, t1, t2) ]
  end
  defp fill_in(letter, [ h1 | t1 ], [ h2 | t2 ]) do
    [ h1 | fill_in(letter, t1, t2) ]
  end

  defp update_letters(game_state, letter, secret, letters) 
    when game_state in [:bad_guess, :already_used, :lost] do
      letters
  end

  defp update_letters(game_state, letter, secret, letters)
    when game_state in [:good_guess, :won] do
      fill_in(letter, secret, letters)
  end


  # returns a tuple containing the updated game
  # state and a tally
  def make_move(game, guess) do
    in_word = MapSet.member?(game.word_chars, guess)
    old_let = MapSet.member?(game.used_chars, guess)
    
    {game_state, turns_left} = det_game_state(in_word, old_let, game.turns_left)
    used_chars = game.used_chars
    MapSet.put(used_chars, guess)

    letters = update_letters(game_state, guess, game.secret, game.letters)

    game = %Hangman.Game{
      game_state: game_state,
      turns_left: turns_left,
      letters:    letters,
      used_chars: used_chars,
      last_guess: guess
    }

    { game, tally(game) }

  end

end