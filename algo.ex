defmodule Algo do
  
  @comment """
  Given a 10 digit phone number, you must return all possible words or combination of words from the provided dictionary, 
  that can be mapped back as a whole to the number.

  With this we can generate numbers like 1-800-motortruck which is easier to remember then 1-800-6686787825
  The phone number mapping to letters is as follows:

  2 = a b c
  3 = d e f
  4 = g h i
  5 = j k l
  6 = m n o
  7 = p q r s
  8 = t u v
  9 = w x y z

  The phone numbers will never contain a 0 or 1. 
  Words have to be at least 3 characters.

  To get give you an initial verification, the following must be true:

  6686787825 should return the following list [["motor", "usual"], ["noun", "struck"], ["nouns", "truck"], ["nouns", "usual"], ["onto", "struck"], "motortruck"]
  2282668687 should return the following list [["act", "contour"], ["acta", "mounts"], ["bat", "amounts"], ["bat", "contour"], ["cat", "contour"], "catamounts"]
  """

  def first_attempt(%{
    :iterable => ""
  }), do: IO.inspect({:DONE})

  def first_attempt(%{
    :actual => actual,
    :iterable => iterable,
    :found => nil 
  } = foo) do
  
    case (
      (dictionary |> map_words) 
      |> Enum.find(& (&1 |> IO.inspect(label: :FIRST)  == iterable |> String.graphemes |> IO.inspect(label: :FIRST))))  do
  
      nil -> foo |> Map.merge(%{:iterable => iterable |> String.slice(0..1)}) |> first_attempt

      f -> IO.inspect({:FOUND, f})
    end
  end
  
  def map_words(words),
    do: words |> Enum.map(& map_word(&1))

  def map_word(word),
  do: word
  |> String.downcase
  |> String.graphemes 
  |> Enum.map(fn char ->
      case char |> char_existence_in_list do
        {i, _} -> i |> Integer.to_string
        _ -> 0
      end
    end)

  def char_existence_in_list(char),
  do: map_words_atoms()
      |> Enum.find(fn {i, chars} -> char in chars end)

  def map_words_atoms,
    do: %{ 
      2 => ["a","b","c"],
      3 => ["d", "e", "f"],
      4 => ["g", "h", "i"],
      5 => ["j", "k", "l"],
      6 => ["m", "n", "o"],
      7 => ["p", "q", "r", "s"],
      8 => ["t", "u", "v"],
      9 => ["w", "x", "y", "z"]
    }

  def dictionary,
    do: [
  "ZEBU",
  "ABU",
  "ANDY",
  "WWALTER",
  "JAMES",
  "ROB",
  "ERIC",
  "TOM",
  "BROCK",
  "OBAMA",
  "TRUMP",
  "HILTON",
  "CLINTON",
  "ZENDAYA",
  "TIMBERLAKE",
  "SENORITA",
  "HIPPY",
  "TUPAC",
  "LILJIMMY",
  "FOO",
  "BAR",
  "SHIRT",
  "SHORTY",
  "KENEDDY",
  "ROBMYGOD"
  ]

  def log,
    do: IO.inspect({:LOG})
end


Algo.map_words(Algo.dictionary) |> IO.inspect
Algo.first_attempt(%{
  :actual => "9328",
  :iterable => "9328",
  :found => nil
}) |> IO.inspect
