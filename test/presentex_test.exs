defmodule PresentexTest do
  use ExUnit.Case

  defmodule ImplicitAttrs do
    use Presenter
    defstruct [one: "swamp", two: 10, three: "thing"]
    attributes
  end

  defmodule ExplicitAtomOnly do
    use Presenter
    defstruct [one: "swamp", two: 10, three: "thing"]
    attributes [:one, :two]
  end

  defmodule ExplicitAttrs do
    use Presenter
    defstruct [one: "swamp", two: 10, three: "thing"]
    attributes [{:one, fn(x) -> String.length(x) end}, {:two, fn(x) -> x * x end}, :three]
  end

  test "works with implicit attribute list" do
    %{one: "swamp", two: 10, three: "thing"} = Presentable.present(%ImplicitAttrs{})
  end

  test "works with explicit attribute (atom-only) list" do
    %{one: "swamp", two: 10} = Presentable.present(%ExplicitAtomOnly{})
  end

  test "works with explicit attribute (mixed-type) list" do
    %{one: 5, two: 100, three: "thing"} = Presentable.present(%ExplicitAttrs{})
  end
end
