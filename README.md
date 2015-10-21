# presentex

A "Presenter" package for Elixir. Convert structures to maps for easy
encoding/decoding.

## What is a Presenter?

A *presenter* is some code that helps present you data structures to other bits
of your code. This is usually most handy when you are encoding or decoding
structs to some other format, like JSON. You don't want that metadata, like
`__struct__` making it into your JSON strings (or maybe you do, that's cool).

## How do I use Presentex?

Presentex has two core systems:

1. The `Presentable` protocol.
2. The `Presenter` module.

The `Presentable` protocol defines how we convert structs to a map. This exists
so that you can write your own implementations of `Presentable` without using
the macros defined in `Presenter`.

The `Presenter` module defines a set of macros that help generate
implementations of the `Presentable` protocol.

## Specifying Attributes

Using `attribute/2` will set up *how* to transform attributes. Using
`attribute/1` and `attributes/1` will set up *which* attributes to transform.

If you want *everything* in your struct to appear in your presentable map (minus
the struct metadata), then you simply include `use Presenter` and be done,
possibly modifying the *how* with `attribute/2`.

If you want to omit certain attributes from the final presentation, use
`attributes/1`. You may combine that macro with `attribute/2`, but the
`attributes/1` function can take in tuples that are equivalent to calling
`attribute/2`. It's basically combining both functions into one format.

## Examples!

```elixir
defmodule User do
  use Presenter

  defstruct [name: "User", password: "derp", lists: []]

  attributes [:name, {:lists, &lists_to_map/1}]

  defp lists_to_map(lists) do
    Enum.into(lists, %{}, fn(list) ->
      {list.title, list}
    end)
  end
end

defmodule TodoList do
  use Presenter

  defstruct [title: "Todo", items: []]

  attribute :items, TodoItem
end

defmodule TodoItem do
  use Presenter

  defstruct [text: "Item", completed: false]
end
```

The above example shows three possible ways to use `Presenter`.

### Plain

THe magic of creating the implemntation happens during the `before_compile`
phase, so simply adding `use Presenter` will generate a default protocol
implemntation. This mainly just strips `__struct__` from the bare map.

### With Modules

The `attribute/2` macro takes an atom (struct key) and either a function or a
module. In the case of a module, it assumes this module will also have an
implementation of `Presentable` and will invoke that protocol on the
attribute. If the attribute is a list, it will invoke the protocol for each
element in the list. If it's a `Dict` type, it will invoke the protocol for each
value in every key-value pair in the underlying data structure.

### With Functions

As mentioned above, you can pass a function as the second parameter in the
`attribute/2` macro. The function must take a single parameter - the value of
the attribute - and return the presentable representation of that value. This
allows for fine-tuned control over how an attribute should be represented.

### Advanced

You may use `attributes/1` to specify both *which* attributes to show and,
optionally, *how* to show each attribute. The format of the list expected by the
macro is:

```elixir
[atom | {atom, module | function}]
```

Specifying an atom is equivalent to saying "include the attribute with this key
using default presentation." Specifying a tuple is equivalent to saying "include
the attribute with this key and then call `attribute/2`."
