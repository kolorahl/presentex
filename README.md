# presentex

A "Presenter" package for Elixir. Convert structures to maps for easy
encoding/decoding.

## What is a Presenter?

A *presenter* is some code that helps present your data structures to other bits
of your code. This is usually most handy when you are encoding or decoding
structs to some other format, like JSON. You don't want that metadata,
specifically the `__struct__` key, making it into your JSON strings (or maybe
you do, and that's cool if you want it there).

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

The core macro is `attributes/1`. You can actually use this macro without any
parameters, which merely drops the `__struct__` key from the struct. Otherwise,
this function will expect a list of attributes. The resulting presentation of
the struct will only include the attributes passed into the macro.

Attributes have two ways of being specified: as an atom, referring to a key in
the struct, and as a tuple, in the form of `{atom, function}`. The default
behavior of `Presenter` is to pass the value of an attribute to
`Presentable.present/1`, but you can change this value transform to whatever you
want by supplying your own function.
