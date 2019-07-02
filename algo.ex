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

  def attempt(%{:iterable => "", :found => found}), do: IO.inspect({:FOUND, found}) 

  def attempt(%{
    :actual => actual,
    :iterable => iterable,
    :found => found 
  } = foo) do

    case iterable |> find_word do
      nil -> 
        foo 
        |> slice_iterable
        |> attempt
  
      f -> 
        all_founds = found ++ (f |> handle_found)
        flen = f |> length

        case flen < actual |> String.length do
          true ->

            new_actual = 
              actual |> String.slice(0..flen) 


            foo
            |> Map.merge(%{
              :iterable => new_actual,
              :actual => new_actual,
              :found => all_founds
            })  
            |> attempt

          false ->
            foo
            |> slice_iterable 
            |> Map.merge(%{
              :found => all_founds
            })
            |> attempt
        end
    end    
  end

  def handle_found(found) do
    
    found
    |> find_original_word
  end

  def slice_iterable(%{:iterable => iterable} = map),
      do: map |> Map.merge(%{:iterable => iterable |> slice_word})
  
  def slice_word(word) do
    case word |> String.graphemes do
      [ _ | rest ] ->
        rest 
        |> Enum.reduce("", fn r, acc -> acc <> r end)
      _ ->
        ""
    end
  end

  def find_word(word),
      do: dictionary |> map_words |> Enum.find(& (&1 == word |> String.graphemes))

  def find_original_word(mapped_word),
  do: dictionary
      |> map_words_with_dict
      |> Enum.reduce([], fn {mapped, actual}, acc ->
        mapped = mapped |> List.flatten
        case mapped == mapped_word do
          true -> acc ++ [actual]
          _ -> acc
        end
      end)

  def map_words_with_dict(words),
  do: words
      |> Enum.reduce(%{}, fn word, acc ->
        acc
        |> Map.merge(%{
          map_words(word |> String.graphemes) => word
        })
      end)

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

  def dict_testing,
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

  def dictionary,
  do: File.read!("dictionary.txt") |> String.split("\n") |> Enum.take(1000)

  def test(number, expect),
  do: Algo.attempt(%{
    :actual => number,
    :iterable => number,
    :found => []
    }) == {:FOUND, expect}
    
end

Algo.test("22252222", ["ABBA", "ABAKA"]) |> IO.inspect(label: :RESULT_SHOULD_BE_TRUE)
