defmodule RenewexRouting do
  def schemas_by_name() do
    RenewexRouting.Predefined.all()
    |> Enum.map(&{&1.name, &1})
    |> Map.new()
  end

  def schemas_by_id() do
    RenewexRouting.Predefined.all()
    |> Enum.map(&{&1.id, &1})
    |> Map.new()
  end

  def schema_by_name(name) do
    map = schemas_by_name()
    Map.get(map, name)
  end

  def socket_by_name(schema_name, socket_name) do
    schema = schema_by_name(schema_name)

    Enum.find(schema.sockets, nil, &(&1.name == socket_name))
  end

  def schema_by_id(id) do
    map = schemas_by_id()
    Map.get(map, id)
  end

  def supported_sfs() do
    RenewexRouting.Sdf.supported_functions()
  end

  def align_edge_to_socket(
        source,
        target,
        waypoints
      ) do
    RenewexRouting.EdgeRouter.align_edge_to_socket(
      source,
      target,
      waypoints
    )
  end
end
