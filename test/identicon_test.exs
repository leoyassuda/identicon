defmodule IdenticonTest do
  use ExUnit.Case
  doctest Identicon

  @input "leo"

  test "should returns a hash" do
    hash = Identicon.hash_input(@input)
    hex = [15, 117, 157, 209, 234, 108, 76, 118, 206, 220, 41, 144, 57, 202, 79, 35]
    assert hash.hex == hex
  end

  test "should returns a color rgb" do
    image =
      Identicon.hash_input(@input)
      |> Identicon.pick_color()

    rgbExpected = {15, 117, 157}

    assert image.color == rgbExpected
  end

  test "should returns a row mirrored" do
    row = [10, 20, 30]
    mirrored = Identicon.mirror_row(row)
    rowExpected = [10, 20, 30, 20, 10]

    assert mirrored == rowExpected
  end

  test "should returns a grid" do
    image =
      Identicon.hash_input(@input)
      |> Identicon.pick_color()
      |> Identicon.build_grid()

    gridExpected = [
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
    ]

    assert image.grid == gridExpected
  end

  test "should returns a grid filtered" do
    image =
      Identicon.hash_input(@input)
      |> Identicon.pick_color()
      |> Identicon.build_grid()
      |> Identicon.filter_odd_squares()

    filteredExpected = [
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
    ]

    assert image.grid == filteredExpected
  end

  test "should returns a pixel map" do
    image =
      Identicon.hash_input(@input)
      |> Identicon.pick_color()
      |> Identicon.build_grid()
      |> Identicon.filter_odd_squares()
      |> Identicon.build_pixel_map()

    pixel_map_expected = [
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

    assert image.pixel_map == pixel_map_expected
  end

  test "should returns a binary" do
    image =
      Identicon.hash_input(@input)
      |> Identicon.pick_color()
      |> Identicon.build_grid()
      |> Identicon.filter_odd_squares()
      |> Identicon.build_pixel_map()
      |> Identicon.draw_image()

    assert image != nil
  end

  test "should returns ok if process can save the image" do
    image =
      Identicon.hash_input(@input)
      |> Identicon.pick_color()
      |> Identicon.build_grid()
      |> Identicon.filter_odd_squares()
      |> Identicon.build_pixel_map()
      |> Identicon.draw_image()
      |> Identicon.save_image(@input)

    assert image == :ok
  end

  test "should returns ok if the main function is processed" do
    image = Identicon.main(@input)

    assert image == :ok
  end
end
