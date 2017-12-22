defmodule BrainfuckTest do
  use ExUnit.Case
  doctest Brainfuck

  test "Interpret working correctly" do
    assert Brainfuck.interpret(
             "++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>."
           ) == "Hello World!\n"
  end
end
