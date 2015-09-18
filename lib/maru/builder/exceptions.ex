defmodule Maru.Builder.Exceptions do
  alias Maru.Router.Endpoint

  defmacro rescue_from(:all, [as: error_var], [do: block]) do
    quote do
      @exceptions {:all, unquote(error_var |> Macro.escape), unquote(block |> Macro.escape)}
    end
  end

  defmacro rescue_from(error, [as: error_var], [do: block]) do
    quote do
      @exceptions {unquote(error), unquote(error_var |> Macro.escape), unquote(block |> Macro.escape)}
    end
  end

  defmacro rescue_from(:all, [do: block]) do
    quote do
      @exceptions {:all, unquote(block |> Macro.escape)}
    end
  end

  defmacro rescue_from(error, [do: block]) do
    quote do
      @exceptions {unquote(error), unquote(block |> Macro.escape)}
    end
  end


  def make_rescue_block({:all, block}) do
    quote do
      _ ->
        resp = unquote(block)
        Endpoint.send_resp(var!(conn), resp)
    end
  end

  def make_rescue_block({error, block}) do
    quote do
      unquote(error) ->
        resp = unquote(block)
        Endpoint.send_resp(var!(conn), resp)
    end
  end

  def make_rescue_block({:all, error_var, block}) do
    quote do
      unquote(error_var) ->
        resp = unquote(block)
        Endpoint.send_resp(var!(conn), resp)
    end
  end

  def make_rescue_block({error, error_var, block}) do
    quote do
      unquote(error_var) in unquote(error) ->
        resp = unquote(block)
        Endpoint.send_resp(var!(conn), resp)
    end
  end
end