defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "new game" do
    assert %Hangman.Game{} = Hangman.new_game()
  end

  test "good move" do
    game = %Hangman.Game{
      game_state: :initializing,
      last_guess: "",
      letters: ["_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"],
      secret: ["l", "i", "m", "i", "t", "a", "t", "i", "o", "n", "s"],
      turns_left: 7,
      used_chars: MapSet.new(),
      word_chars: MapSet.new(["a", "i", "l", "m", "n", "o", "s", "t"])
    }
    assert {%Hangman.Game{game_state: :good_guess}, tally} = Hangman.make_move(game, "m")
  end

  test "bad move" do
    game = %Hangman.Game{
      game_state: :initializing,
      last_guess: "",
      letters: ["_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"],
      secret: ["l", "i", "m", "i", "t", "a", "t", "i", "o", "n", "s"],
      turns_left: 7,
      used_chars: MapSet.new(),
      word_chars: MapSet.new(["a", "i", "l", "m", "n", "o", "s", "t"])
    }
    assert {%Hangman.Game{game_state: :bad_guess}, tally} = Hangman.make_move(game, "z")
  end

  test "won" do
    game = %Hangman.Game{
      game_state: :good_guess,
      last_guess: "s",
      letters: ["_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"],
      secret: ["l", "i", "m", "i", "t", "a", "t", "i", "o", "n", "s"],
      turns_left: 7,
      used_chars: MapSet.new(["a", "i", "l", "m", "n", "o", "s"]),
      word_chars: MapSet.new(["a", "i", "l", "m", "n", "o", "s", "t"])
    }
    assert {%Hangman.Game{game_state: :won}, tally} = Hangman.make_move(game, "t")
  end

  test "lost" do
    game = %Hangman.Game{
      game_state: :bad_guess,
      last_guess: "x",
      letters: ["_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"],
      secret: ["l", "i", "m", "i", "t", "a", "t", "i", "o", "n", "s"],
      turns_left: 1,
      used_chars: MapSet.new(["a", "i", "l", "m", "n", "o", "s"]),
      word_chars: MapSet.new(["a", "i", "l", "m", "n", "o", "s", "t"])
    }
    assert {%Hangman.Game{game_state: :lost}, tally} = Hangman.make_move(game, "z")
  end

  test "already used" do
    game = %Hangman.Game{
      game_state: :bad_guess,
      last_guess: "x",
      letters: ["_", "_", "_", "_", "_", "_", "_", "_", "_", "_", "_"],
      secret: ["l", "i", "m", "i", "t", "a", "t", "i", "o", "n", "s"],
      turns_left: 3,
      used_chars: MapSet.new(["a", "i", "l", "m", "n", "o", "s"]),
      word_chars: MapSet.new(["a", "i", "l", "m", "n", "o", "s", "t"])
    }
    assert {%Hangman.Game{game_state: :already_used}, tally} = Hangman.make_move(game, "a")
  end

end
