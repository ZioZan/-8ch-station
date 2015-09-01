
//code for pool tiles

/turf/simulated/floor/pool
	name = "Pool"
	icon = 'icons/turf/pool.dmi'
	icon_state = "smooth"
	ignoredirt = 1
	smooth = 1
	canSmoothWith = null
	//can_be_unanchored = 1 not sure if it's needed
	floor_tile = /obj/item/stack/tile/pool
	reagents = new(0) //reagents inside the tile
	var/chem_dose = 2 //reagents to remove per tick
	var/chem_share = 0 //ammount of chems to give neighbours, changed dynamically.
	flags = OPENCONTAINER
	var/pool_count = 0


/turf/simulated/floor/pool/New()
	SSobj.processing += src
	create_reagents(200)
	reagents.maximum_volume = 200
	var/image/water_effect = image('icons/effects/water.dmi', src, "water_pool")
	overlays += water_effect
	..()

/turf/simulated/floor/pool/update_icon()
	if(smooth)
		smooth_icon(src)
		smooth_icon_neighbors(src)

/turf/simulated/floor/pool/process()
	if(smooth)
		smooth_icon(src)
		smooth_icon_neighbors(src)

	for(var/mob/living/L in src)
		reagents.reaction(L, TOUCH)
		reagents.remove_any(chem_dose/10)		//reaction() doesn't use up the reagents

	for(var/obj/item/O in src)	//This will make acid melt items. Might need to decrease the scope of it though.
		reagents.reaction(O, TOUCH)
		reagents.remove_any(chem_dose)

	//find adjacent pools to spread chems.
	pool_count = 1
	reagents.maximum_volume = 200
	for(var/turf/simulated/floor/pool/T in orange(1,src))
		pool_count += 1
		reagents.maximum_volume += 200
		T.reagents.trans_to(src, T.reagents.total_volume)
	//spread those chems
	chem_share = reagents.total_volume/pool_count
	for(var/turf/simulated/floor/pool/T in orange(1,src))
		reagents.trans_to(T,chem_share)
		T.reagents.update_total()
	reagents.maximum_volume = 200
	reagents.update_total()

	color = mix_color_from_reagents(reagents)