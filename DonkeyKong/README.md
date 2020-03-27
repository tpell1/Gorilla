## Directory structure
|--Glue.   
|--Images.   
|--Levels.   
|--Nodes.   
 &nbsp;&nbsp;&nbsp; |--Checkpoints.   
 &nbsp;&nbsp;&nbsp; |--Menus.   
 &nbsp;&nbsp;&nbsp; |--Presets.   
 &nbsp;&nbsp;&nbsp; |--Sprites.   
 &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; |--Blocks.   
 &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; |--Characters.   
 &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; |--Items.   
|--Storyboards.   
|--Utilities.  

## DonkeyKong
This is the root directory for the source of the project. This folder contains only the propertylist files used for configuring the project. 

### Property lists
These are read by the program during runtime or when being built and contain dictionaries which describe various configuration options.
#### Levels.plist
This file consists of an array of dictionaries, each dictionary describes one level with its blocks, enemies, and various presets that can be used to build it. Each block/enemy/preset is its own dictionary inside of an array of its respective type. The dictionaries contain the required information for the program to load the whole level during runtime.
#### Config.plist
Contains a simple dictionary, this is read when the program first loads and allows the game to know the users current progress (Score, lives, level). It is also written to when the user loses a life or progresses to the next level. 
#### Info.plist
Contains information required for the swift compiler to build the project.
