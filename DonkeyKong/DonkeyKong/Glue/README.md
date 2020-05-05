## Glue
This folder contains code which pieces together the project. It contains all of the logic required for the game environment and handles moving in between levels and scenes.
#### AppDelegate.swift
Manages the apps shared behaviours. It determines what the app must do when moved into background, or when the app is about to be terminated for example. It is initialised early and remains active throughout the apps whole lifecycle.
#### GameScene.swift
This contains all of the logic for the game environment, it is responsible for loading in all levels and handling key events (collision and touchscreen). It creates all of the HUD and also is responsible for keeping track of the main character, though most of its logic is handled by its own class (**MarioSprite.swift**).
#### GameViewController.swift
The only view controller in the entire app, this is responsible for loading and displaying the two scenes (**GameScene**, and **LevelSelectScene**). It also reads the **levels.plist** file and sends the data to **GameScene**.
