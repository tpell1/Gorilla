## Levels
The classes in here contain all of the data **GameScene** requires to display a level. They contain one key method `addChildren()` which adds all of the levels elements to the levels root node, which is itself (as they are subclasses of **SKNode**).
#### LevelScene.swift
The superclass, it inherits from **SKNode** and provides methods that **GameScene** can use to add a level to a scene. `addChildren()` instantiates the levels elements and then adds them as children to the node using `self.addChild(childNode)`, and `setFrame(rect: CGRect)` takes the devices currently visible coordinates and uses this as a base for positions of the levels elements. This ensures that levels are all consistent compared to each other in coordinate space. **LevelScene** also acts as level one of the game.
#### LevelTwo.swift
This class represents level two of the game, it is a subclass of **LevelScene**. **LevelTwo** overrides `addChildren()` to customise what elements the level contains.
#### LevelReader.swift
This class is a subclass of **LevelScene**, it does not represent any one level. It is used to convert data read in from *Levels.plist* into an instance of **LevelScene** which can be rendered by **GameScene**.
