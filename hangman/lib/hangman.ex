defmodule Hangman do
  @moduledoc """
  Documentation for Hangman.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Hangman.hello()
      :world

  """
  defdelegate new_game(), to: Game, as: :new_game

  defdelegate tally(game), to: Game, as: :tally

  defdelegate make_move(game, guess), to: Game, as: :make_move

end
