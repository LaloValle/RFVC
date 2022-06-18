from numpy import *

# bit-quads masks
MASK_WHITE = array([
    [ [255,255,255],[255,255,255] ],
    [ [255,255,255],[255,255,255] ]
])
MASK_1 = array([
    [ [0,0,0],      [255,255,255] ],
    [ [255,255,255],[255,255,255] ]
])
MASK_2 = array([
    [ [0,0,0],[0,0,0]       ],
    [ [0,0,0],[255,255,255] ]
])
MASK_3 = array([
    [ [255,255,255],[0,0,0]       ],
    [ [0,0,0],      [255,255,255] ]
])

# bit-quads directions masks
EMPTY_MASK = array([
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
])
# 4-Neighbours
EAST = array([
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[1,1,1] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
])
SOUTH = array([
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[1,1,1],[0,0,0] ],
])
WEST = array([
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [1,1,1],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
])
NORTH = array([
    [ [0,0,0],[1,1,1],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
])
DIRECTIONS_4_NEIGHBOURS_LABELS = ['East','North','West','South']
DIRECTIONS_4_NEIGHBOURS = [(index,direction) for index,direction in enumerate([EAST,NORTH,WEST,SOUTH])]
DIRECTION_XY_STEP_4 = [
    (1,0) , # EAST
    (0,-1) , # NORTH
    (-1,0), # WEST
    (0,1), # SOUTH
]
# 8-Neighbours
NORTH_EAST = array([
    [ [0,0,0],[0,0,0],[1,1,1] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ]
])
NORTH_WEST = array([
    [ [1,1,1],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ]
])
SOUTH_WEST = array([
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [1,1,1],[0,0,0],[0,0,0] ],
])
SOUTH_EAST = array([
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[1,1,1] ],
])
DIRECTIONS_8_NEIGHBOURS_LABELS = ['East','North-East','North','North-West','West','South-West','South','South-East']
DIRECTIONS_8_NEIGHBOURS = [(index,direction) for index,direction in enumerate([EAST,NORTH_EAST,NORTH,NORTH_WEST,WEST,SOUTH_WEST,SOUTH,SOUTH_EAST])]
DIRECTION_XY_STEP_8 = [
    (1,0) , # EAST
    (1,-1) , # NORTH-EAST
    (0,-1) , # NORTH
    (-1,-1) , # NORTH-WEST
    (-1,0), # WEST
    (-1,1), # SOUTH-WEST
    (0,1), # SOUTH
    (1,1), # SOUTH-EAST
]

# Colored bit-quad mask
# 4-Neighbours
COLOR_CENTER = array([
    [ [0,0,0],[0,0,0],[0,0,0]   ],
    [ [0,0,0],[0,0,255],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0]   ],
],uint8)
COLOR_EAST = array([
    [ [0,0,0],[0,0,0],[0,0,0]   ],
    [ [0,0,0],[0,0,0],[0,0,255] ],
    [ [0,0,0],[0,0,0],[0,0,0]   ],
],uint8)
COLOR_SOUTH = array([
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,255],[0,0,0] ],
],uint8)
COLOR_WEST = array([
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,255],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
],uint8)
COLOR_NORTH = array([
    [ [0,0,0],[0,0,255],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
],uint8)
# 4-Neighbours inverted
COLOR_CENTER_INVERTED = array([
    [ [0,0,0],[0,0,0],[0,0,0]   ],
    [ [0,0,0],[-255,-255,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0]   ],
],uint8)
COLOR_EAST_INVERTED = array([
    [ [0,0,0],[0,0,0],[0,0,0]   ],
    [ [0,0,0],[0,0,0],[-255,-255,0] ],
    [ [0,0,0],[0,0,0],[0,0,0]   ],
],uint8)
COLOR_SOUTH_INVERTED = array([
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[-255,-255,0],[0,0,0] ],
],uint8)
COLOR_WEST_INVERTED = array([
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [-255,-255,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
],uint8)
COLOR_NORTH_INVERTED = array([
    [ [0,0,0],[-255,-255,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
],uint8)
COLORED_4_NEIGHBOURS = [COLOR_EAST,COLOR_NORTH,COLOR_WEST,COLOR_SOUTH,COLOR_CENTER]
COLORED_4_NEIGHBOURS_INVERTED = [COLOR_EAST_INVERTED,COLOR_NORTH_INVERTED,COLOR_WEST_INVERTED,COLOR_SOUTH_INVERTED,COLOR_CENTER_INVERTED]
# 8-Neighbours
COLOR_NORTH_EAST = array([
    [ [0,0,0],[0,0,0],[0,0,255] ],
    [ [0,0,0],[0,0,0],[0,0,0]   ],
    [ [0,0,0],[0,0,0],[0,0,0]   ],
],uint8)
COLOR_NORTH_WEST = array([
    [ [0,0,255],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
],uint8)
COLOR_SOUTH_EAST = array([
    [ [0,0,0],[0,0,0],[0,0,0]   ],
    [ [0,0,0],[0,0,0],[0,0,0]   ],
    [ [0,0,0],[0,0,0],[0,0,255] ],
],uint8)
COLOR_SOUTH_WEST = array([
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,255],[0,0,0],[0,0,0] ],
],uint8)
# 8-Neighbours inverted
COLOR_NORTH_EAST_INVERTED = array([
    [ [0,0,0],[0,0,0],[-255,-255,0] ],
    [ [0,0,0],[0,0,0],[0,0,0]   ],
    [ [0,0,0],[0,0,0],[0,0,0]   ],
],uint8)
COLOR_NORTH_WEST_INVERTED = array([
    [ [-255,-255,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
],uint8)
COLOR_SOUTH_EAST_INVERTED = array([
    [ [0,0,0],[0,0,0],[0,0,0]   ],
    [ [0,0,0],[0,0,0],[0,0,0]   ],
    [ [0,0,0],[0,0,0],[-255,-255,0] ],
],uint8)
COLOR_SOUTH_WEST_INVERTED = array([
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [0,0,0],[0,0,0],[0,0,0] ],
    [ [-255,-255,0],[0,0,0],[0,0,0] ],
],uint8)
COLORED_8_NEIGHBOURS = [COLOR_EAST,COLOR_NORTH_EAST,COLOR_NORTH,COLOR_NORTH_WEST,COLOR_WEST,COLOR_SOUTH_WEST,COLOR_SOUTH,COLOR_SOUTH_EAST,COLOR_CENTER]
COLORED_8_NEIGHBOURS_INVERTED = [COLOR_EAST_INVERTED,COLOR_NORTH_EAST_INVERTED,COLOR_NORTH_INVERTED,COLOR_NORTH_WEST_INVERTED,COLOR_WEST_INVERTED,COLOR_SOUTH_WEST_INVERTED,COLOR_SOUTH_INVERTED,COLOR_SOUTH_EAST_INVERTED,COLOR_CENTER_INVERTED]


# Useful masks
WHITE_MASK = array([
    [ [255,255,255],[255,255,255],[255,255,255] ],
    [ [255,255,255],[255,255,255],[255,255,255] ],
    [ [255,255,255],[255,255,255],[255,255,255] ]
])
