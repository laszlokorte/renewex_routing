defmodule RenewexRoutingTest do
  alias RenewexRouting.Target
  alias RenewexRouting.Adjusment
  use ExUnit.Case
  doctest RenewexRouting

  @box_a %{
    position_x: 130,
    position_y: 170,
    width: 122,
    height: 64
  }
  @box_b %{
    position_x: 370,
    position_y: 520,
    width: 200,
    height: 11
  }

  @box_c %{
    position_x: 0,
    position_y: 0,
    width: 100,
    height: 50
  }
  @box_d %{
    position_x: 400,
    position_y: 0,
    width: 100,
    height: 50
  }

  @box_e %{
    position_x: 0,
    position_y: 0,
    width: 100,
    height: 50
  }
  @box_f %{
    position_x: 400,
    position_y: 25,
    width: 100,
    height: 50
  }

  test "no bonding" do
    assert %Adjusment{
             update: %{},
             keep: %{source_x: 30, source_y: 70, target_x: 50, target_y: 110}
           } ==
             RenewexRouting.align_edge_to_socket(
               %{position_x: 30, position_y: 70},
               %{position_x: 50, position_y: 110},
               []
             )
  end

  test "exact source bonding" do
    socket = RenewexRouting.socket_by_name("simple", "center-socket")

    assert %Adjusment{
             keep: %{target_x: 50, target_y: 110},
             update: %{source_x: 191, source_y: 202.0}
           } ==
             RenewexRouting.align_edge_to_socket(
               %Target{box: @box_a, socket: socket, stencil: nil},
               %{position_x: 50, position_y: 110},
               []
             )
  end

  test "exact target bonding" do
    socket = RenewexRouting.socket_by_name("simple", "center-socket")

    assert %Adjusment{
             keep: %{source_x: 50, source_y: 110},
             update: %{target_x: 191.0, target_y: 202.0}
           } ==
             RenewexRouting.align_edge_to_socket(
               %{position_x: 50, position_y: 110},
               %Target{box: @box_a, socket: socket, stencil: nil},
               []
             )
  end

  test "exact both side bonding" do
    socket = RenewexRouting.socket_by_name("simple", "center-socket")

    assert %Adjusment{
             keep: %{},
             update: %{target_x: 470.0, target_y: 525.5, source_x: 191.0, source_y: 202.0}
           } ==
             RenewexRouting.align_edge_to_socket(
               %Target{box: @box_a, socket: socket, stencil: nil},
               %Target{box: @box_b, socket: socket, stencil: nil},
               []
             )
  end

  test "stencil source bonding" do
    schema = RenewexRouting.schema_by_name("simple-rect")
    socket = RenewexRouting.socket_by_name("simple-rect", "center-socket")

    assert :rect = schema.stencil

    assert %Adjusment{
             keep: %{target_x: 300, target_y: 25},
             update: %{source_x: 100, source_y: 25}
           } ==
             RenewexRouting.align_edge_to_socket(
               %Target{box: @box_c, socket: socket, stencil: schema.stencil},
               %{position_x: 300, position_y: 25},
               []
             )
  end

  test "stencil target bonding" do
    schema = RenewexRouting.schema_by_name("simple-rect")
    socket = RenewexRouting.socket_by_name("simple-rect", "center-socket")

    assert :rect = schema.stencil

    assert %Adjusment{
             keep: %{source_x: 10, source_y: 25},
             update: %{target_x: 400, target_y: 25}
           } ==
             RenewexRouting.align_edge_to_socket(
               %{position_x: 10, position_y: 25},
               %Target{box: @box_d, socket: socket, stencil: schema.stencil},
               []
             )
  end

  test "stencil both side bonding" do
    schema = RenewexRouting.schema_by_name("simple-rect")
    socket = RenewexRouting.socket_by_name("simple-rect", "center-socket")

    assert :rect = schema.stencil

    assert %Adjusment{
             keep: %{},
             update: %{target_x: 400, target_y: 25, source_x: 100, source_y: 25}
           } ==
             RenewexRouting.align_edge_to_socket(
               %Target{box: @box_c, socket: socket, stencil: schema.stencil},
               %Target{box: @box_d, socket: socket, stencil: schema.stencil},
               []
             )
  end

  test "stencil both side bonding 3x3" do
    schema = RenewexRouting.schema_by_name("simple-rect")
    socket_a = RenewexRouting.socket_by_name("simple-rect", "center-socket")
    socket_b = RenewexRouting.socket_by_name("3x3 sockets", "top")

    assert :rect = schema.stencil

    assert %Adjusment{
             keep: %{},
             update: %{target_x: 450, target_y: 25, source_x: 100, source_y: 25}
           } ==
             RenewexRouting.align_edge_to_socket(
               %Target{box: @box_e, socket: socket_a, stencil: schema.stencil},
               %Target{box: @box_f, socket: socket_b, stencil: schema.stencil},
               []
             )
  end
end
