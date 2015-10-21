defprotocol Presentable do
  @moduledoc """
  Defines a protocol meant to take complex data structures and present them as
  simple data types. I personally find it very useful for converting custom
  structs to maps. Very good when you need to encode/decode messages between a
  client connection.
  """

  @doc "Returns a 'presentable' data object."
  @fallback_to_any true
  def present(model)
end

defimpl Presentable, for: List do
  @doc """
  Presents each individual element. In the case of a keyword list, presents each
  value while retaining the original key.
  """
  def present(list) do
    Enum.map(list, &nested/1)
  end

  defp nested({key, val}), do: {key, Presentable.present(val)}
  defp nested(val), do: Presentable.present(val)
end

defimpl Presentable, for: Map do
  @doc "Present each element of the map, retaining the original key."
  def present(map) do
    Enum.into(map, %{}, &present_value/1)
  end

  defp present_value({key, val}), do: {key, Presentable.present(val)}
end

defimpl Presentable, for: Any do
  @doc """
  Fallback case: return the data as-is, except for structs. For structs, remove
  the `__struct__` key and return the bare map.
  """
  def present(%{__struct__: _}=data), do: Map.delete(data, :__struct__)
  def present(data), do: data
end
