/* Code for the Wild West map by Brotemis
 * Contains:
 *		Wish Granter
 *		Meat Grinder
 */

/*
 * Wish Granter
 */
/obj/machinery/wish_granter_dark
	name = "Wish Granter"
	desc = "You're not so sure about this, anymore..."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"

	anchored = TRUE
	density = TRUE
	use_power = NO_POWER_USE

	var/chargesa = 1
	var/insistinga = 0

/obj/machinery/wish_granter_dark/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(.)
		return
	user.SetNextMove(CLICK_CD_INTERACT)
	if(chargesa <= 0)
		to_chat(user, "The Wish Granter lies silent.")
		return 1

	else if(!ishuman(user))
		to_chat(user, "You feel a dark stirring inside of the Wish Granter, something you want nothing of. Your instincts are better than any man's.")
		return 1

	else if(is_special_character(user))
		to_chat(user, "Even to a heart as dark as yours, you know nothing good will come of this.  Something instinctual makes you pull away.")
		return 1

	else if (!insistinga)
		to_chat(user, "Your first touch makes the Wish Granter stir, listening to you.  Are you really sure you want to do this?")
		insistinga++

	else
		chargesa--
		insistinga = 0
		var/wish = input("You want...","Wish") as null|anything in list("Power","Wealth","Immortality","To Kill","Peace")
		switch(wish)
			if("Power")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart.")
				if (!(LASEREYES in user.mutations))
					user.mutations.Add(LASEREYES)
					to_chat(user, "<span class='notice'>You feel pressure building behind your eyes.</span>")
				if (!(COLD_RESISTANCE in user.mutations))
					user.mutations.Add(COLD_RESISTANCE)
					to_chat(user, "<span class='notice'>Your body feels warm.</span>")
				if (!(XRAY in user.mutations))
					user.mutations.Add(XRAY)
					user.update_sight()
					to_chat(user, "<span class='notice'>The walls suddenly disappear.</span>")
				user.set_species(SHADOWLING)
			if("Wealth")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart.")
				new /obj/structure/closet/syndicate/resources/everything(loc)
				user.set_species(SHADOWLING)
			if("Immortality")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart.")
				user.verbs += /mob/living/carbon/proc/immortality
				user.set_species(SHADOWLING)
			if("To Kill")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your wickedness, claiming your soul and warping your body to match the darkness in your heart.")
				create_and_setup_role(/datum/role/traitor/wishgranter, user)
				user.set_species(SHADOWLING)
			if("Peace")
				to_chat(user, "<B>Whatever alien sentience that the Wish Granter possesses is satisfied with your wish. There is a distant wailing as the last of the Faithless begin to die, then silence.</B>")
				to_chat(user, "You feel as if you just narrowly avoided a terrible fate...")
				for(var/mob/living/simple_animal/hostile/faithless/F in alive_mob_list)
					F.health = -10
					F.stat = DEAD
					F.icon_state = "faithless_dead"


///////////////Meatgrinder//////////////


/obj/effect/meatgrinder
	name = "Meat Grinder"
	desc = "What is that thing?"
	density = TRUE
	anchored = TRUE
	layer = 3
	icon = 'icons/mob/animal.dmi'
	icon_state = "blob"
	var/triggered = 0

/obj/effect/meatgrinder/atom_init()
	. = ..()
	icon_state = "blob"

/obj/effect/meatgrinder/Crossed(atom/movable/AM)
	. = ..()
	Bumped(AM)

/obj/effect/meatgrinder/Bumped(mob/M)

	if(triggered) return

	if(ishuman(M) || ismonkey(M))
		for(var/mob/O in viewers(world.view, src.loc))
			O << "<font color='red'>[M] triggered the \icon[src] [src]</font>"
		triggered = 1
		trigger_act()

/obj/effect/meatgrinder/proc/trigger_act(mob)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	for(var/mob/O in viewers(world.view, src.loc))
		s.set_up(3, 1, src)
		s.start()
		explosion(mob, 1, 0, 0, 0)
		spawn(0)
			qdel(src)

/obj/effect/meatgrinder
	name = "Meat Grinder"
	icon_state = "blob"


/////For the Wishgranter///////////

/mob/living/carbon/proc/immortality()
	set category = "Immortality"
	set name = "Resurrection"

	var/mob/living/carbon/C = usr
	if(C.stat == CONSCIOUS)
		C << "<span class='notice'>You're not dead yet!</span>"
		return
	C << "<span class='notice'>Death is not your end!</span>"

	spawn(rand(800,1200))
		if(C.stat == DEAD)
			dead_mob_list -= C
			alive_mob_list += C
		C.stat = CONSCIOUS
		C.tod = null
		C.resetToxLoss()
		C.resetOxyLoss()
		C.resetCloneLoss()
		C.SetParalysis(0)
		C.SetStunned(0)
		C.SetWeakened(0)
		C.radiation = 0
		C.heal_overall_damage(C.getBruteLoss(), C.getFireLoss())
		C.reagents.clear_reagents()
		C << "<span class='notice'>You have regenerated.</span>"
		C.visible_message("<span class='warning'>[usr] appears to wake from the dead, having healed all wounds.</span>")
		C.update_canmove()
	return 1
