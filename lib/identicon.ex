defmodule Identicon do
  @moduledoc """
  Generates a squared avatar image in 250px by passing a string as argument to the program.

  A example `sample.png` generated in img folder
  """

  @doc """
  Generate in root folder a image .png according to string used.
  Check the file generated `example.png`

  ## Examples

      iex> Identicon.main "leo"
      :ok

  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
  Save in root folder with input as name file `sample.png`.

  ## Examples
      iex> hash = Identicon.hash_input "leo"
      iex> color = Identicon.pick_color hash
      iex> grid = Identicon.build_grid color
      iex> filtered = Identicon.filter_odd_squares grid
      iex> pixels = Identicon.build_pixel_map filtered
      iex> image = Identicon.draw_image pixels
      iex> saved = Identicon.save_image(image, "leo")
      iex> saved
      :ok

  """
  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  @doc """
  Returns the positions to use in image creation.

  ## Examples
      iex> hash = Identicon.hash_input "leo"
      iex> color = Identicon.pick_color hash
      iex> grid = Identicon.build_grid color
      iex> filtered = Identicon.filter_odd_squares grid
      iex> pixels = Identicon.build_pixel_map filtered
      iex> image = Identicon.draw_image pixels
      iex> image != nil
      true

  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  @doc """
  Returns the positions to use in image creation.

  ## Examples
      iex> hash = Identicon.hash_input "leo"
      iex> color = Identicon.pick_color hash
      iex> grid = Identicon.build_grid color
      iex> filtered = Identicon.filter_odd_squares grid
      iex> pixels = Identicon.build_pixel_map filtered
      iex> pixels
      %Identicon.Image{
        color: {15, 117, 157},
        grid: [
            {234, 6},
            {108, 7},
            {234, 8},
            {76, 10},
            {118, 11},
            {206, 12},
            {118, 13},
            {76, 14},
            {220, 15},
            {144, 17},
            {220, 19},
            {202, 21},
            {202, 23}
        ],
        hex: [15, 117, 157, 209, 234, 108, 76, 118, 206, 220, 41, 144, 57, 202, 79, 35],
        pixel_map: [
            {{50, 50}, {100, 100}},
            {{100, 50}, {150, 100}},
            {{150, 50}, {200, 100}},
            {{0, 100}, {50, 150}},
            {{50, 100}, {100, 150}},
            {{100, 100}, {150, 150}},
            {{150, 100}, {200, 150}},
            {{200, 100}, {250, 150}},
            {{0, 150}, {50, 200}},
            {{100, 150}, {150, 200}},
            {{200, 150}, {250, 200}},
            {{50, 200}, {100, 250}},
            {{150, 200}, {200, 250}}
        ]
      }

  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Returns the grid.

  ## Examples
      iex> hash = Identicon.hash_input "leo"
      iex> color = Identicon.pick_color hash
      iex> grid = Identicon.build_grid color
      iex> grid
      %Identicon.Image{
        color: {15, 117, 157},
        grid: [
            {15, 0},
            {117, 1},
            {157, 2},
            {117, 3},
            {15, 4},
            {209, 5},
            {234, 6},
            {108, 7},
            {234, 8},
            {209, 9},
            {76, 10},
            {118, 11},
            {206, 12},
            {118, 13},
            {76, 14},
            {220, 15},
            {41, 16},
            {144, 17},
            {41, 18},
            {220, 19},
            {57, 20},
            {202, 21},
            {79, 22},
            {202, 23},
            {57, 24}
        ],
        hex: [15, 117, 157, 209, 234, 108, 76, 118, 206, 220, 41, 144, 57, 202, 79, 35],
        pixel_map: nil
      }

  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Returns odds values from grid.

  ## Examples
      iex> hash = Identicon.hash_input "leo"
      iex> color = Identicon.pick_color hash
      iex> grid = Identicon.build_grid color
      iex> filtered = Identicon.filter_odd_squares grid
      iex> filtered
      %Identicon.Image{
        color: {15, 117, 157},
        grid: [
            {234, 6},
            {108, 7},
            {234, 8},
            {76, 10},
            {118, 11},
            {206, 12},
            {118, 13},
            {76, 14},
            {220, 15},
            {144, 17},
            {220, 19},
            {202, 21},
            {202, 23}
        ],
        hex: [15, 117, 157, 209, 234, 108, 76, 118, 206, 220, 41, 144, 57, 202, 79, 35],
        pixel_map: nil
      }

  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {code, _index} ->
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Returns mirrored list from 3 elements.

  ## Examples
      iex> row = [10, 20, 30]
      iex> mirrored = Identicon.mirror_row row
      iex> mirrored
      [10, 20, 30, 20, 10]

  """
  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  @doc """
  Returns the color that will be used in image.

  ## Examples
      iex> hash = Identicon.hash_input "leo"
      iex> color = Identicon.pick_color hash
      iex> color
      %Identicon.Image{
        color: {15, 117, 157},
        grid: nil,
        hex: [15, 117, 157, 209, 234, 108, 76, 118, 206, 220, 41, 144, 57, 202, 79, 35],
        pixel_map: nil
      }

  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
  Returns a hash in structure `Identicon.Image`

  ## Examples

  ## Examples
      iex> hash = Identicon.hash_input "leo"
      iex> hash
      %Identicon.Image{
        color: nil,
        grid: nil,
        hex: [15, 117, 157, 209, 234, 108, 76, 118, 206, 220, 41, 144, 57, 202, 79, 35],
        pixel_map: nil
      }

  """
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
