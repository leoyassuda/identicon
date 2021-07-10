defmodule Identicon.Image do
  @moduledoc """
  A struct representing a person.
  """

  @enforce_keys []
  defstruct hex: nil,
            color: nil,
            grid: nil,
            pixel_map: nil

  @typedoc "A image"
  @type t() :: %__MODULE__{
          hex: List | nil,
          color: Tuple | nil,
          grid: List | nil,
          pixel_map: List | nil
        }
end
