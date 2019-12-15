return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.3.1",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 15,
  height = 11,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 2,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      filename = "tiles.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 8,
      image = "tiles.png",
      imagewidth = 256,
      imageheight = 96,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 24,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 1,
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 15,
      height = 11,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
        10, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 10,
        10, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6, 10,
        10, 21, 1, 1, 19, 15, 20, 1, 1, 1, 1, 1, 1, 6, 10,
        10, 22, 1, 1, 16, 1, 16, 1, 1, 1, 1, 1, 1, 6, 10,
        10, 24, 15, 15, 17, 1, 18, 15, 20, 1, 19, 15, 15, 13, 10,
        10, 22, 1, 1, 1, 1, 1, 1, 16, 1, 16, 1, 1, 6, 10,
        10, 23, 1, 1, 1, 1, 1, 1, 18, 15, 17, 1, 1, 6, 10,
        10, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6, 10,
        10, 7, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 9, 10,
        10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10
      }
    }
  }
}
