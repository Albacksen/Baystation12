// folding/locking knives
/obj/item/weapon/material/kitchen/utensil/knife/folding
	name = "pocketknife"
	desc = "A small folding knife."
	icon = 'icons/obj/folding_knife.dmi'
	icon_state = "knife_preview"
	item_state = null
	force = 0.2 //force of folded obj
	force_divisor = 0.1 //force 6 when made of steel
	applies_material_colour = FALSE
	applies_material_name = FALSE
	unbreakable = TRUE
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("prodded", "tapped")
	hitsound = "swing_hit"
	edge = FALSE
	sharp = FALSE

	var/open = FALSE
	var/takes_colour = TRUE
	var/hardware_closed = "basic_hardware_closed"
	var/hardware_open = "basic_hardware"
	var/handle_icon = "basic_handle"
	var/can_backstab = FALSE

	var/valid_colors = list(COLOR_DARK_GRAY, COLOR_RED_GRAY, COLOR_BLUE_GRAY, COLOR_DARK_BLUE_GRAY, COLOR_GREEN_GRAY, COLOR_DARK_GREEN_GRAY)

/obj/item/weapon/material/kitchen/utensil/knife/folding/Initialize()
	if(takes_colour)
		color = pick(valid_colors)
	icon_state = handle_icon
	update_icon()
	. = ..()

/obj/item/weapon/material/kitchen/utensil/knife/folding/attack_self(mob/user)
	open = !open
	update_force()
	update_icon()
	if(open)
		user.visible_message("<span class='warning'>\The [user] opens \the [src].</span>")
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	else
		user.visible_message("<span class='notice'>\The [user] closes \the [src].</span>")
	add_fingerprint(user)

/obj/item/weapon/material/kitchen/utensil/knife/folding/attack(mob/living/M, mob/user, var/target_zone)
	..()
	if(ismob(M) && can_backstab)
		backstab(M, user, 60, BRUTE, DAM_SHARP, target_zone, TRUE)

/obj/item/weapon/material/kitchen/utensil/knife/folding/update_force()
	if(open)
		edge = 1
		sharp = 1
		hitsound = 'sound/weapons/bladeslice.ogg'
		w_class = ITEM_SIZE_NORMAL
		attack_verb = list("slashed", "stabbed")
		..()
	else
		force = initial(force)
		edge = initial(edge)
		sharp = initial(sharp)
		hitsound = initial(hitsound)
		w_class = initial(w_class)
		attack_verb = initial(attack_verb)

/obj/item/weapon/material/kitchen/utensil/knife/folding/on_update_icon()
	if(open)
		overlays.Cut()
		overlays += overlay_image(icon, hardware_open, flags=RESET_COLOR)
		item_state = "knife"
	else
		overlays.Cut()
		overlays += overlay_image(icon, hardware_closed, flags=RESET_COLOR)
		item_state = initial(item_state)
	if(blood_overlay)
		overlays += blood_overlay

//Subtypes
/obj/item/weapon/material/kitchen/utensil/knife/folding/wood
	name = "peasant knife"
	desc = "A small folding knife with a wooden handle and carbon steel blade. Knives like this have been used on Earth for centuries."
	hardware_closed = "peasant_hardware_closed"
	hardware_open = "peasant_hardware"
	handle_icon = "peasant_handle"
	valid_colors = list(WOOD_COLOR_GENERIC, WOOD_COLOR_RICH, WOOD_COLOR_BLACK, WOOD_COLOR_CHOCOLATE, WOOD_COLOR_PALE)

/obj/item/weapon/material/kitchen/utensil/knife/folding/balisong
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	force_divisor = 0.25 // 15 when wielded with hardness 60 (steel)
	thrown_force_divisor = 0.25 // 5 when thrown with weight 20 (steel)
	unbreakable = 0
	attack_cooldown_modifier = -1
	hardware_closed = "bfly_hardware_closed"
	hardware_open = "bfly_hardware"
	handle_icon = "bfly_handle"
	takes_colour = FALSE
	can_backstab = TRUE

/obj/item/weapon/material/kitchen/utensil/knife/folding/balisong/switchblade
	name = "switchblade"
	desc = "A classic switchblade with gold engraving. Just holding it makes you feel like a gangster."
	hardware_closed = "switch_hardware_closed"
	hardware_open = "switch_hardware"
	handle_icon = "switch_handle"