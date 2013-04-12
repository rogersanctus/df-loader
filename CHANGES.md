Changelog
=========

The entire project was changed since last commit.

 - Now the classes names begin with Df (the acronym of DarkFunction), so the Animation class is now
   DfAnimation. This was done to allow the project to be easy used with other libraries.
 - The project now uses concepts of the Tilelayer library and all the credit for the code that uses those concepts go to the [author](https://github.com/elsassph).
 - The following classes were added:
    * DfRenderer: Who render batched sprites to the main sprite (or the sprite you wish to draw on).
	* DfBasicContainer: Defines object that can contains other objects inside. This one don't return the total size of the objects contained.
	* DfBasicSprite: Defines a basic sprite object.
	* DfAnimationDef: Added to separate the different functions that were on the old Animation class. This one is only a definition of an animation.
 - Changes on the old classes:
    * DfAnimation: Extends DfBasicContainer.
		- Now animations can be get by only creating a DfAnimation object and adding it to the renderer object.
		- This way you can add more than one animation from the same animation definition without having to clone it.
		- Added flip horizontally and flip vertically operation to the animation. Which will flip the entire animation and it contained sprites.
		- Get the size of the animation based on the total area that contain the internal sprites.
	* DfSprite: Extends DfBasicSprite.
		- Added a NME Matrix object to hold the sprite transformations until a getMatrix call.
		- Added a bounds property to get the sprite bounds even after transformations.
	* DfSpritesheet: Extends NME Tilesheet.