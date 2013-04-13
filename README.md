[DarkFunction Editor](http://darkfunction.com/editor/) - Loader
============================

##Sprites and Animations loader for Haxe NME.##

This library was developed to easy load and use sprites and animations generated by [DarkFunction Editor](http://darkfunction.com/editor/).
It depends on NME library: [nme](http://nme.io).

**To install the dependencies:**
```
haxelib install nme
```

Installing
----------

Just download and extract this library into your project folder and use it. Or install it via haxelib:

```
haxelib git df-loader https://github.com/rogersanctus/df-loader.git haxelib
```

A simple SpriteSheet test:
--------------------------

```as3
var sprs: Spritesheet = new Spritesheet( Assets.getText("teste.sprites"), "path_to_images" );

var renderer = new DfRenderer(sprs);

// Create tilesprites with the sprites names from the generated xml file
var spr1 = new DfSprite("/sprite/0");
var spr2 = new DfSprite("/sprite/1");

spr1.x = 64;
spr2.x = 128;

// Add sprites to the renderer
renderer.addChild(spr1);
renderer.addChild(spr2);

// Add the renderer view to the sprite
addChild(renderer.view);

// Render the renderer
renderer.render();
```

*The teste.sprites file:*
```xml
<?xml version="1.0"?>
<!-- Generated by darkFunction Editor (www.darkfunction.com) -->
<img name="teste.png" w="64" h="32">
  <definitions>
    <dir name="/">
      <dir name="sprite">
        <spr name="0" x="0" y="0" w="32" h="32"/>
        <spr name="1" x="32" y="0" w="32" h="32"/>
      </dir>
    </dir>
  </definitions>
</img>
```

_More samples at examples directory._

Known issues
------------

- Rotations on animations will not work as expected when each cell (frame) have more than one sprite
  with position different from the animation center point. Also if some sprite was previously rotated,
  a new rotation will not consider the previous rotation.
