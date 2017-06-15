defmodule Brainfuck do

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

	defp move_code_ptr(state) do
	  Map.update!(state, :code_ptr, &(&1 + 1))
	end

	defp initialize_data(state) do
		if is_nil get_in(state, [:data, state.data_ptr])do
			put_in(state, [:data, state.data_ptr], 0)
		else
			state
		end
	end

	### brainfuck ops ###
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

	defp read_char(state) do
		char = IO.gets(1)
		put_in(state, [:data, state.data_ptr], char)
	end

	defp print_char(state) do
		current_data = get_in(state, [:data, state.data_ptr])
	  IO.puts <<current_data>>
		state
	end

	defp increment_data(state) do
		update_in(state, [:data, state.data_ptr], &(&1 + 1))
	end

	defp decrement_data(state) do
		update_in(state, [:data, state.data_ptr], &(&1 - 1))
	end

	defp increment_pointer(state) do
    Map.update!(state, :data_ptr, &(&1 + 1))
  end

  defp decrement_pointer(state) do
    Map.update!(state, :data_ptr, &(&1 - 1))
  end

  defp move_to_matching_bracket(state) do
		Map.put(state, :code_ptr, get_in(state, [:brackets, state.code_ptr]))
  end

	defp open_bracket(state) do
		current_data_value = get_in(state, [:data, state.data_ptr])
    if current_data_value == 0 do
			move_to_matching_bracket(state)
		else
			state
		end
	end

	defp close_bracket(state) do
		current_data_value = get_in(state, [:data, state.data_ptr])
      if current_data_value != 0 do
  			move_to_matching_bracket(state)
  		else
  			state
  		end
	end

	def read do
	  code = IO.gets("Input brainfuck code\n") |> String.trim
	  interpret code
	end
end