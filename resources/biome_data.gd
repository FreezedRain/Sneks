class_name BiomeData extends Resource

export (String) var name
export (TileSet) var tileset
export (String) var move_particle
export (Color) var color_top
export (Color) var color_bottom

func _init(name: String = 'test', tileset: TileSet = null,
    move_particle: String = '', color_top: Color = Color.black, color_bottom: Color = Color.black):
    self.name = name
    self.tileset = tileset
    self.move_particle = move_particle
    self.color_top = color_top
    self.color_bottom = color_bottom