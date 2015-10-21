defmodule Presenter do
  @moduledoc """
  Include this module via `use Presenter` to add an auto-generated `Presentable`
  protocol implementation for any module that defines a struct.
  """

  @type attribute :: atom | {atom, function}
  @type attributes :: [attribute]

  @doc false
  defmacro __using__(_) do
    quote do
      import Presenter
    end
  end

  @spec attributes(attributes) :: Macro.t
  defmacro attributes(attributes \\ []) do
    quote do
      defimpl Presentable, for: __MODULE__ do
        def present(model) do
          attributes = prepare(model, unquote(attributes))
          Enum.into(attributes, %{}, fn
            ({attribute, transform}) ->
              present_attribute(model, attribute, transform)
            (attribute) ->
              present_attribute(model, attribute, &Presentable.present/1)
          end)
        end

        @spec prepare(Map.t, [atom]) :: Map.t
        defp prepare(model, []), do: Map.keys(model) |> List.delete(:__struct__)
        defp prepare(model, attributes), do: Enum.uniq_by(attributes, &attr_name/1)

        @spec attr_name(Presenter.attribute) :: atom
        defp attr_name({name, _}), do: name
        defp attr_name(name), do: name

        @spec present_attribute(Map.t, atom, function) :: {atom, term}
        defp present_attribute(model, attribute, transform) do
          value = Map.get(model, attribute)
          {attribute, transform.(value)}
        end
      end
    end
  end
end
