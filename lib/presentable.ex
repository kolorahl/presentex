defprotocol Presentable do
  @doc "Returns a 'presentable' data object for client rendering."
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

  defp nested({key, val}) do
    {key, Presentable.present(val)}
  end

  defp nested(val), do: Presentable.present(val)
end

defimpl Presentable, for: Map do
  @doc "Present each element of the map, retaining the original key."
  def present(map) do
    Enum.into(map, %{}, fn({k, v}) ->
      {k, Presentable.present(v)}
    end)
  end
end

defimpl Presentable, for: Any do
  @doc """
  Returns the data as-is.
  """
  def present(data), do: data
end
