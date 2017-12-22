# Brainfuck
A simple brainfuck interpreter written in Elixir

# Running
Run `iex -S mix` and then use the module in the following way:
```elixir
  iex> Brainfuck.interpret "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++."
  "Hello World!\n"

  iex> Brainfuck.read                                                                            
  Input brainfuck code
  ++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.
  Hello World!

  :ok
```
