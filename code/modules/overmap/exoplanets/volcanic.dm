/obj/effect/overmap/sector/exoplanet/volcanic
	name = "volcanic exoplanet"
	desc = "A tectonically unstable planet, extremely rich in minerals."
	color = "#8e3900"
	planetary_area = /area/exoplanet/volcanic
	rock_colors = list(COLOR_DARK_GRAY)
	possible_themes = list()

/obj/effect/overmap/sector/exoplanet/volcanic/generate_map()
	..()
	for(var/zlevel in map_z)
		new /datum/random_map/automata/cave_system/mountains/volcanic(null,1,1,zlevel,maxx,maxy,0,1,1,planetary_area)
		var/datum/random_map/noise/exoplanet/M = new /datum/random_map/noise/exoplanet/volcanic(null,1,1,zlevel,maxx,maxy,0,1,1,planetary_area)
		get_biostuff(M)
		new /datum/random_map/noise/ore/filthy_rich(null,1,1,zlevel,maxx,maxy,0,1,1)
		for(var/_x = 1 to maxx)
			for(var/_y = 1 to maxy)
				var/turf/T = locate(_x,_y,zlevel)
				planetary_area.contents.Add(T)
				if(istype(T,/turf/simulated/mineral))
					var/turf/simulated/mineral/MT = T
					MT.mined_turf = prob(90) ? planetary_area.base_turf : /turf/simulated/floor/exoplanet/lava

/obj/effect/overmap/sector/exoplanet/volcanic/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T20C + rand(220, 800)
		atmosphere.update_values()

/obj/effect/overmap/sector/exoplanet/volcanic/adapt_seed(var/datum/seed/S)
	..()
	S.set_trait(TRAIT_REQUIRES_WATER,0)
	S.set_trait(TRAIT_HEAT_TOLERANCE, 1000 + S.get_trait(TRAIT_HEAT_TOLERANCE))

/obj/effect/overmap/sector/exoplanet/volcanic/adapt_animal(var/mob/living/simple_animal/A)
	..()
	A.heat_damage_per_tick = 0 //animals not hot, no burning in lava

/datum/random_map/noise/exoplanet/volcanic
	descriptor = "volcanic exoplanet"
	smoothing_iterations = 5
	land_type = /turf/simulated/floor/exoplanet/volcanic
	water_type = /turf/simulated/floor/exoplanet/lava
	water_level_min = 5
	water_level_max = 6
	plantcolors = list("#a23c05","#3f1f0d","#662929","#ba6222","#5c755e","#120309")

	fauna_prob = 1
	flora_prob = 7
	large_flora_prob = 0
	flora_diversity = 3
	fauna_types = list(/mob/living/simple_animal/thinbug)

//Squashing most of 1 tile lava puddles
/datum/random_map/noise/exoplanet/volcanic/cleanup()
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			var/current_cell = get_map_cell(x,y)
			if(noise2value(map[current_cell]) < water_level)
				continue
			var/frendos
			for(var/dx in list(-1,0,1))
				for(var/dy in list(-1,0,1))
					var/tmp_cell = get_map_cell(x+dx,y+dy)
					if(tmp_cell && tmp_cell != current_cell && noise2value(map[tmp_cell]) >= water_level)
						frendos = 1
						break
			if(!frendos)
				map[current_cell] = 1

/datum/random_map/noise/ore/filthy_rich
	deep_val = 0.6
	rare_val = 0.4

/area/exoplanet/volcanic
	forced_ambience = list('sound/ambience/magma.ogg')
	base_turf = /turf/simulated/floor/exoplanet/volcanic

/turf/simulated/floor/exoplanet/volcanic
	name = "volcanic floor"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "cold"

/datum/random_map/automata/cave_system/mountains/volcanic
	iterations = 2
	descriptor = "space volcanic mountains"
	wall_type =  /turf/simulated/mineral/volcanic
	mineral_turf =  /turf/simulated/mineral/random/volcanic
	rock_color = COLOR_DARK_GRAY

/turf/simulated/floor/exoplanet/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"
	movement_delay = 4
	var/list/victims

/turf/simulated/floor/exoplanet/lava/on_update_icon()
	return

/turf/simulated/floor/exoplanet/lava/Initialize()
	. = ..()
	set_light(0.95, 0.5, 2, l_color = COLOR_ORANGE)

/turf/simulated/floor/exoplanet/lava/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/turf/simulated/floor/exoplanet/lava/Entered(atom/movable/AM)
	..()
	if(locate(/obj/structure/catwalk/) in src)
		return
	if(AM.is_burnable())
		LAZYADD(victims, weakref(AM))
		START_PROCESSING(SSobj, src)

/turf/simulated/floor/exoplanet/lava/Exited(atom/movable/AM)
	LAZYREMOVE(victims, weakref(AM))

/turf/simulated/floor/exoplanet/lava/Process()
	if(locate(/obj/structure/catwalk/) in src)
		victims = null
		return PROCESS_KILL
	for(var/weakref/W in victims)
		var/atom/movable/AM = W.resolve()
		if(!(AM && AM.is_burnable()))
			victims -= W
			continue
		var/datum/gas_mixture/environment = return_air()
		var/pressure = environment.return_pressure()
		if(AM.lava_act(environment, 5000 + environment.temperature, pressure))
			victims -= W
	if(!LAZYLEN(victims))
		return PROCESS_KILL

/turf/simulated/floor/exoplanet/lava/get_footstep_sound(var/mob/caller)
	return get_footstep(FOOTSTEP_LAVA, caller)

/turf/simulated/mineral/volcanic
	name = "volcanic rock"
	color = COLOR_DARK_GRAY

/turf/simulated/mineral/random/volcanic
	name = "volcanic rock"
	color = COLOR_DARK_GRAY

/turf/simulated/mineral/random/high_chance/volcanic
	name = "volcanic rock"
	color = COLOR_DARK_GRAY
