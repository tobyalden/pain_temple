package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import scenes.*;

class Sword extends Entity
{
    public function new() {
        super();
        mask = new Hitbox(16, 32);
        graphic = new ColoredRect(16, 4, 0xFF0000);
        graphic.alpha = 0.33;
    }
}
