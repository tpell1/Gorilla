## Nodes
Contains all the code for the nodes which can be added to a level. The classes are divided into four types (Checkpoints, menus, presets, and sprites).
#### Checkpoints
These consist of nodes which signify the user meeting a key objective, it could be completing a level or a place where the user can stop and save they're progress.
#### Menus
Contains the code which determines how each menu will look like, they behave similarly to **LevelScene** in that they are subclasses of **SKNode** and add their own children. However most of **GameScene**'s logic will not work while menus are in use.
#### Presets
These are subclasses of **SKNode** which contain useful combinations of other nodes, examples include enemies with their own platforms and the ends of levels with a flag and an obstacle.
#### Sprites
Classes which represent important objects in the game, this folder contains code for characters, blocks, enemies, and items. They handle collisions and contain methods which **GameScene** uses to make the game progress.
