package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import scenes.*;

class Player extends Entity
{
    public static inline var RUN_SPEED = 3;
    public static inline var GRAVITY = 0.45;
    public static inline var MAX_FALL_SPEED = 6;
    public static inline var JUMP_POWER = 6;

    public var sword(default, null):Sword;
    private var sprite:Spritemap;
    private var velocity:Vector2;
    private var canDoubleJump:Bool;
    private var willAttack:Bool;
    private var attackStartup:Alarm;
    private var attackTimer:Alarm;

    public function new(x:Float, y:Float) {
        super(x, y);
        name = "player";
        mask = new Hitbox(16, 32);
        sprite = new Spritemap("graphics/player.png", 16 * 3, 16 * 2);
        sprite.add("idle", [0]);
        sprite.add("run", [1, 2, 3], 12);
        sprite.add("duck", [4]);
        sprite.add("jump", [5]);
        sprite.add("hurt", [6]);
        sprite.add("hold_up_two_hands", [7]);
        sprite.add("hold_up_one_hand", [8]);
        sprite.add("attack_startup", [9]);
        sprite.add("attack_active", [10]);
        sprite.add("attack_active_low", [11]);
        sprite.add("attack_down", [12]);
        sprite.add("attack_up", [13]);
        sprite.play("idle");
        sprite.x = -16;
        graphic = sprite;
        velocity = new Vector2();
        canDoubleJump = false;
        willAttack = false;
        attackStartup = new Alarm(0.1, function() {
            willAttack = true;
        });
        addTween(attackStartup);
        attackTimer = new Alarm(0.2);
        addTween(attackTimer);
        sword = new Sword();
    }

    override public function update() {
        movement();
        combat();
        animation();
        super.update();
    }

    private function combat() {
        if(Input.pressed("attack")) {
            if(!attackStartup.active && !attackTimer.active) {
                attackStartup.start();
            }
        }
        if(willAttack) {
            attackTimer.start();
            willAttack = false;
        }
        sword.x = sprite.flipX ? x - sword.width : x + width;
        sword.y = y + 10;
    }

    private function movement() {
        if(isOnGround()) {
            canDoubleJump = true;
            if(attackStartup.active || attackTimer.active) {
                velocity.x = 0;
            }
            else if(Input.check("left")) {
                velocity.x = -RUN_SPEED;
            }
            else if(Input.check("right")) {
                velocity.x = RUN_SPEED;
            }
            else {
                velocity.x = 0;
            }
            velocity.y = 0;
        }
        else {
            if(velocity.x < 0) {
                if(Input.check("right")) {
                    velocity.x = -RUN_SPEED / 2;
                }
            }
            else if(velocity.x > 0) {
                if(Input.check("left")) {
                    velocity.x = RUN_SPEED / 2;
                }
            }
            else {
                if(Input.check("right")) {
                    velocity.x = RUN_SPEED / 2;
                }
                if(Input.check("left")) {
                    velocity.x = -RUN_SPEED / 2;
                }
            }
        }

        if(Input.pressed("jump")) {
            if(isOnGround()) {
                velocity.y = -JUMP_POWER;
            }
            else if(canDoubleJump) {
                velocity.y = -JUMP_POWER * 0.9;
                if(Input.check("left")) {
                    velocity.x = -RUN_SPEED;
                }
                else if(Input.check("right")) {
                    velocity.x = RUN_SPEED;
                }
                else {
                    velocity.x = 0;
                }
                canDoubleJump = false;
            }
        }

        if(Math.abs(velocity.y) < 0.5) {
            velocity.y += GRAVITY / 2;
        }
        else {
            velocity.y += GRAVITY;
        }
        if(velocity.y > MAX_FALL_SPEED) {
            velocity.y = MAX_FALL_SPEED;
        }
        moveBy(velocity.x, velocity.y, ["walls"]);
    }

    private function animation() {
        if(attackTimer.active) {
            sprite.play("attack_active");
        }
        else if(attackStartup.active) {
            sprite.play("attack_startup");
        }
        else if(isOnGround()) {
            if(velocity.x != 0) {
                if(Input.check("left") || Input.check("right")) {
                    sprite.flipX = velocity.x < 0;
                }
                sprite.play("run");
            }
            else {
                sprite.play("idle");
            }
        }
        else {
            sprite.play("jump");
        }
    }

    private function isOnGround() {
        return collide("walls", x, y + 1) != null;
    }
}
