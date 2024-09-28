defmodule RenewexRouting.Position do
  def unify_coord(:x, obj) do
    %{
      value: obj.x_value,
      unit: obj.x_unit,
      offset: %{
        operation: obj.x_offset_operation,
        value_static: obj.x_offset_value_static,
        dynamic_value: obj.x_offset_dynamic_value,
        dynamic_unit: obj.x_offset_dynamic_unit
      }
    }
  end

  def unify_coord(:y, obj) do
    %{
      value: obj.y_value,
      unit: obj.y_unit,
      offset: %{
        operation: obj.y_offset_operation,
        value_static: obj.y_offset_value_static,
        dynamic_value: obj.y_offset_dynamic_value,
        dynamic_unit: obj.y_offset_dynamic_unit
      }
    }
  end

  def unify_coord(:rx, obj) do
    %{
      value: obj.rx_value,
      unit: obj.rx_unit,
      offset: %{
        operation: obj.rx_offset_operation,
        value_static: obj.rx_offset_value_static,
        dynamic_value: obj.rx_offset_dynamic_value,
        dynamic_unit: obj.rx_offset_dynamic_unit
      }
    }
  end

  def unify_coord(:ry, obj) do
    %{
      value: obj.ry_value,
      unit: obj.ry_unit,
      offset: %{
        operation: obj.ry_offset_operation,
        value_static: obj.ry_offset_value_static,
        dynamic_value: obj.ry_offset_dynamic_value,
        dynamic_unit: obj.ry_offset_dynamic_unit
      }
    }
  end

  def build_coord(box, axis, relative, coord) do
    origin = box_axis(axis, box)
    base = coord.value * unit(coord.unit, box)

    offset =
      op(
        coord.offset.operation,
        coord.offset.value_static,
        unit(coord.offset.dynamic_unit, box) * coord.offset.dynamic_value
      )

    if(relative, do: base, else: base + origin) + offset
  end

  def box_axis(:x, box), do: box.position_x
  def box_axis(:y, box), do: box.position_y

  def unit(:maxsize, box), do: max(box.width, box.height)
  def unit(:minsize, box), do: min(box.width, box.height)
  def unit(:width, box), do: box.width
  def unit(:height, box), do: box.height

  def op(:max, a, b), do: max(a, b)
  def op(:min, a, b), do: min(a, b)
  def op(:sum, a, b) when is_float(a) and is_float(b), do: a + b
end
