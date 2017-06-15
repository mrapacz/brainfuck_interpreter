defmodule Brainfuck do

	@doc "Interprets brainfuck code assuming it is syntactically and semantically correct"
  def interpret(code) when is_binary(code) do
    interpret(%{code_length: String.length(code), code: code, code_ptr: 0, data: %{}, data_ptr: 0, brackets: match_brackets(code)})
  end
  def interpret(%{code_ptr: code_ptr, code_length: code_length}) when code_ptr == code_length, do: :ok
  def interpret(state) when is_map(state) do
      state
      |> initialize_data
      |> perform_operation
      |> move_code_ptr
      |> interpret
    end

	@doc "Parses the code and returns a <key, value> map of <bracket_index, matchin_bracket_index>"
  def match_brackets(code), do: match_brackets(code, 0, [], %{})
  def match_brackets(code, index, opening_brackets, bracket_map) do
    if index == String.length(code) do
        bracket_map
    else
      case String.at(code, index) do
        "[" -> match_brackets(code, index + 1, [index | opening_brackets], bracket_map)
        "]" -> [opening_bracket | other_brackets] = opening_brackets
               closing_bracket = index
               updated_bracket_map =
                 bracket_map
                 |> Map.put(opening_bracket, closing_bracket)
                 |> Map.put(closing_bracket, opening_bracket)
               match_brackets(code, index + 1, other_brackets, updated_bracket_map)
        _ -> match_brackets(code, index + 1, opening_brackets, bracket_map)
      end
    end
  end

	@doc "Moves code pointer to the right"
  defp move_code_ptr(state) do
    Map.update!(state, :code_ptr, &(&1 + 1))
  end

	@doc "If the value of the current data cell has not yet been initialised, it initialises it to zero"
  defp initialize_data(state) do
    if is_nil get_in(state, [:data, state.data_ptr])do
      put_in(state, [:data, state.data_ptr], 0)
    else
      state
    end
  end

  ### brainfuck ops ###

  @doc "Performs action corresponding to the current character in the brainfuck code"
  defp perform_operation(state) do
    current_character = String.at(state.code, state.code_ptr)
    case current_character do
       "," -> read_char(state)
       "." -> print_char(state)
       "+" -> increment_data(state)
       "-" -> decrement_data(state)
       ">" -> increment_pointer(state)
       "<" -> decrement_pointer(state)
       "[" -> open_bracket(state)
       "]" -> close_bracket(state)
    end
  end

	@doc "Reads a single character from the input and puts it into the current data cell"
  defp read_char(state) do
    char = IO.gets(1)
    put_in(state, [:data, state.data_ptr], char)
  end

	@doc "Prints a character whose ASCII value corresponds to the one in the current data cell"
  defp print_char(state) do
    current_data = get_in(state, [:data, state.data_ptr])
    IO.write <<current_data>>
    state
  end

	@doc "Increments the value stored in the current data cell"
  defp increment_data(state) do
    update_in(state, [:data, state.data_ptr], &(&1 + 1))
  end

	@doc "Decrements the value stored in the current data cell"
  defp decrement_data(state) do
    update_in(state, [:data, state.data_ptr], &(&1 - 1))
  end

	@doc "Moves the data pointer to the right"
  defp increment_pointer(state) do
    Map.update!(state, :data_ptr, &(&1 + 1))
  end

	@doc "Moves the data pointer to the left"
  defp decrement_pointer(state) do
    Map.update!(state, :data_ptr, &(&1 - 1))
  end

	@doc "Moves the code pointer to the matching bracket"
  defp move_to_matching_bracket(state) do
    Map.put(state, :code_ptr, get_in(state, [:brackets, state.code_ptr]))
  end

	@doc "Moves to the matching closing bracket if the value in the current data cell equals zero, otherwise does nothing"
  defp open_bracket(state) do
    current_data_value = get_in(state, [:data, state.data_ptr])
    if current_data_value == 0 do
      move_to_matching_bracket(state)
    else
      state
    end
  end

	@doc "Moves to the matching opening bracket if the value in the current data cell equals zero, otherwise does nothing"
  defp close_bracket(state) do
    current_data_value = get_in(state, [:data, state.data_ptr])
      if current_data_value != 0 do
        move_to_matching_bracket(state)
      else
        state
      end
  end

	@doc "Reads brainfuck code from the input and interprets it"
  def read do
    code = IO.gets("Input brainfuck code\n") |> String.trim
    interpret code
  end
end