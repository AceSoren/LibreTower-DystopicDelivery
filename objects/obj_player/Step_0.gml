switch state
{
	case states.normal:
		scr_plr_normal()
		break;
	case states.ouch:
		scr_plr_hurt()
		break;
	case states.grab:
		scr_plr_grab()
		break;
}


mask_index = crouched ? spr_player_crouchmask : spr_player_mask
walkspeed = 0.3 / (crouched + 1)
if dogravity {
	var thing = instance_place(x, y + 1, obj_solid)
	if thing and thing.mask_index != spr_blank onground = true else onground = false // to-do: not this

	if !onground {
		vsp += 0.35
	}
	scr_plr_collision()
}

if canmove { // disable moving, jumping, grabbing, and entering doors
	if keyboard_check_pressed(vk_up) {
		var possibleDoor = instance_place(x,y,obj_door)
		if possibleDoor {
			global.targetDest = possibleDoor.targetDest
			room_goto(possibleDoor.targetRoom)
		}
	}

	if keyboard_check_pressed(ord("Z")) {
		if onground {
			var holdingUp = crouched ? 0 : keyboard_check(vk_up)
			scr_playsound(holdingUp ? sfx_hjump : sfx_jump)
			vsp -= 9 + 1 * holdingUp
			onground = false
			changeSprite(spr_player_fall)
		}
	}
	
	if keyboard_check_pressed(ord("X")) {
		if state != states.stunned and state != states.grab {
			statetimer = 45
			state = states.grab
			scr_playsound(sfx_grab, true)
		}
	}

}

if canmove and keyboard_check_pressed(ord("C")) and state != states.taunt {
	canmove = false
	dogravity = false
	prevstate = state
	state = states.taunt
	sprite_index = spr_player_taunt
	image_index = random_range(0, sprite_get_number(sprite_index))
	image_speed = 0
	alarm[0] = 30
}

if state != states.ouch and place_meeting(x,y, obj_hurtblock) {
	hurtplayer(-6 * image_xscale, -4, true)
}

if keyboard_check_pressed(vk_escape) {
	instance_create_layer(0,0,"Instances",obj_pause)
}