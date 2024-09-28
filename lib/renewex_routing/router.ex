defmodule RenewexRouting.EdgeRouter do
  def align_to_socket(box, socket, relevant_waypoint, socket_schema \\ nil) do
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

    stencil =
      case socket_schema do
        nil -> nil
        %{stencil: s} -> s
      end

    RenewexRouting.RayTracer.nearest(
      stencil,
      box,
      {target_x, target_y},
      {relevant_waypoint.position_x, relevant_waypoint.position_y}
    )
  end
end
