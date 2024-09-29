defmodule RenewexRouting.EdgeRouter do
  alias RenewexRouting.Target
  alias RenewexRouting.Adjusment

  def align_edge_to_socket(
        %{position_x: source_x, position_y: source_y},
        %{position_x: target_x, position_y: target_y},
        _
      ) do
    %Adjusment{
      update: %{},
      keep: %{
        source_x: source_x,
        source_y: source_y,
        target_x: target_x,
        target_y: target_y
      }
    }
  end

  def align_edge_to_socket(
        %{position_x: source_x, position_y: source_y} = source,
        %Target{box: target_box, socket: target_socket, stencil: target_stencil},
        waypoints
      ) do
    relevant_waypoint = Enum.at(waypoints, -1, source)

    %{position_x: target_x, position_y: target_y} =
      align_to_socket(target_box, target_socket, relevant_waypoint, target_stencil)

    %Adjusment{
      update: %{
        target_x: target_x,
        target_y: target_y
      },
      keep: %{
        source_x: source_x,
        source_y: source_y
      }
    }
  end

  def align_edge_to_socket(
        %Target{box: source_box, socket: source_socket, stencil: source_stencil},
        %{position_x: target_x, position_y: target_y} = target,
        waypoints
      ) do
    relevant_waypoint = Enum.at(waypoints, 0, target)

    %{position_x: source_x, position_y: source_y} =
      align_to_socket(source_box, source_socket, relevant_waypoint, source_stencil)

    %Adjusment{
      update: %{
        source_x: source_x,
        source_y: source_y
      },
      keep: %{
        target_x: target_x,
        target_y: target_y
      }
    }
  end

  def align_edge_to_socket(
        %Target{box: source_box, socket: source_socket, stencil: source_stencil},
        %Target{box: target_box, socket: target_socket, stencil: target_stencil},
        []
      ) do
    relevant_waypoint_target =
      align_to_socket(source_box, source_socket)

    relevant_waypoint_source =
      align_to_socket(target_box, source_socket)

    %{position_x: source_x, position_y: source_y} =
      align_to_socket(source_box, source_socket, relevant_waypoint_source, source_stencil)

    %{position_x: target_x, position_y: target_y} =
      align_to_socket(target_box, target_socket, relevant_waypoint_target, target_stencil)

    %Adjusment{
      update: %{
        source_x: source_x,
        source_y: source_y,
        target_x: target_x,
        target_y: target_y
      },
      keep: %{}
    }
  end

  def align_edge_to_socket(
        %Target{box: source_box, socket: source_socket, stencil: source_stencil},
        %Target{box: target_box, socket: target_socket, stencil: target_stencil},
        waypoints
      ) do
    relevant_waypoint_source = Enum.at(waypoints, 0)
    relevant_waypoint_target = Enum.at(waypoints, -1)

    %{position_x: source_x, position_y: source_y} =
      align_to_socket(source_box, source_socket, relevant_waypoint_source, source_stencil)

    %{position_x: target_x, position_y: target_y} =
      align_to_socket(target_box, target_socket, relevant_waypoint_target, target_stencil)

    %Adjusment{
      update: %{
        source_x: source_x,
        source_y: source_y,
        target_x: target_x,
        target_y: target_y
      },
      keep: %{}
    }
  end

  def align_to_socket(box, socket) do
    target_x =
      RenewexRouting.Position.build_coord(
        box,
        :x,
        false,
        RenewexRouting.Position.unify_coord(:x, socket)
      )

    target_y =
      RenewexRouting.Position.build_coord(
        box,
        :y,
        false,
        RenewexRouting.Position.unify_coord(:y, socket)
      )

    %{position_x: target_x, position_y: target_y}
  end

  def align_to_socket(box, socket, relevant_waypoint, stencil) do
    target_x =
      RenewexRouting.Position.build_coord(
        box,
        :x,
        false,
        RenewexRouting.Position.unify_coord(:x, socket)
      )

    target_y =
      RenewexRouting.Position.build_coord(
        box,
        :y,
        false,
        RenewexRouting.Position.unify_coord(:y, socket)
      )

    RenewexRouting.RayTracer.nearest(
      stencil,
      box,
      {target_x, target_y},
      {relevant_waypoint.position_x, relevant_waypoint.position_y}
    )
  end
end
