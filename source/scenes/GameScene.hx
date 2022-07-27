package scenes;

import entities.*;
import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import haxepunk.utils.*;
import openfl.Assets;

class GameScene extends Scene
{
    private var level:Level;
    private var player:Player;

    override public function begin() {
        level = add(new Level("level"));
        for(entity in level.entities) {
            add(entity);
            if(entity.name == "player") {
                player = cast(entity, Player);
                add(player.sword);
                trace('adding sword');
            }
        }
    }

    override public function update() {
        super.update();
    }
}
