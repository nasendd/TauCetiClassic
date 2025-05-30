/obj/structure/survivor_cryopod
	name = "old cryopod"
	desc = "A man-sized pod for entering suspended animation. Looks old and dusty"
	icon = 'icons/obj/Cryogenic3.dmi'
	icon_state = "sleeper"
	density = TRUE
	anchored = TRUE

	var/searching = FALSE
	var/opened = FALSE
	var/open_state = "sleeper-open"
	var/survivor_memory = "You don't remember anything that happened before you entered this statis pod"
	var/fixed_name
	var/fixed_gender

/obj/structure/survivor_cryopod/opened
	icon_state = "sleeper-open"
	opened = TRUE
	density = FALSE

/obj/structure/survivor_cryopod/attack_hand(mob/user)
	if(user.is_busy(src))
		return

	user.SetNextMove(CLICK_CD_INTERACT)

	if(searching)
		to_chat(user, "<span class='notice'>Cryosleep interruption is in progress, please wait...</span>")
		return

	if(opened)
		to_chat(user, "<span class='notice'>Cryopod is empty</span>")
		return

	to_chat(user, "<span class='notice'>You attempt to engage cryopod's systems</span>")
	if(!do_after(user, 50, target = src))
		return

	visible_message("<span class='notice'>Automatic cryosleep interruption process has begun, please stand by...</span>")
	searching = TRUE
	request_player()
	addtimer(CALLBACK(src, PROC_REF(stop_search)), 350)

/obj/structure/survivor_cryopod/proc/request_player()
	var/list/candidates = pollGhostCandidates("Survivor role is available. Would you like to play?", ROLE_GHOSTLY, IGNORE_SURVIVOR, 250, TRUE)
	for(var/mob/M in candidates) // No random
		searching = FALSE
		opened = TRUE
		spawn_survivor(M)
		break

/obj/structure/survivor_cryopod/proc/spawn_survivor(mob/M)
	var/mob/living/carbon/human/H = new(loc, HUMAN)
	H.SetSleeping(2000 SECONDS)
	H.drowsyness = 1000

	H.randomize_appearance()

	if(fixed_gender)
		switch(fixed_gender)
			if("male")
				H.gender = MALE
			if("female")
				H.gender = FEMALE

		H.update_body(update_preferences = TRUE)

	if(fixed_name)
		H.name = fixed_name
		H.real_name = fixed_name

	H.dna.ready_dna(H)
	H.dna.UpdateSE()
	H.forceMove(src)

	equip_survivor(H)

	H.mind = M.mind
	H.ckey = M.ckey

	visible_message("<span class='notice'>The cryopod hums and hisses as it slowly opens</span>")
	playsound(src, 'sound/misc/riginternaloff.ogg', VOL_EFFECTS_MASTER, null, FALSE)

	sleep(50) // Cinematic pauses
	to_chat(H, "<span class='notice'>Your name is: [H.real_name]</span>")
	sleep(30)
	to_chat(H, "<span class='notice'>[survivor_memory]</span>")
	sleep(30)

	H.SetSleeping(10 SECONDS)
	H.drowsyness = 20

	density = FALSE
	H.forceMove(loc)
	icon_state = open_state

/obj/structure/survivor_cryopod/proc/stop_search()
	if(searching)
		playsound(src, 'sound/misc/riginternaloff.ogg', VOL_EFFECTS_MASTER, null, FALSE)
		visible_message("<span class='notice'>The cryopod hums and hisses as it opens, revealing... nothing. This cryopod is empty</span>")
		searching = FALSE
		opened = TRUE
		density = FALSE
		icon_state = open_state

/obj/structure/survivor_cryopod/proc/equip_survivor(mob/living/carbon/human/H)
	return

/obj/structure/survivor_cryopod/nasa
	fixed_name = "Major Tom" // ground control to maaaajor tom

/obj/structure/survivor_cryopod/nasa/equip_survivor(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(H), SLOT_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), SLOT_SHOES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), SLOT_WEAR_MASK)

	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/nasavoid(H), SLOT_WEAR_SUIT)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/nasavoid(H), SLOT_HEAD)
	H.equip_to_slot_or_del(new /obj/item/weapon/tank/jetpack/oxygen(H), SLOT_BACK)

/obj/structure/survivor_cryopod/civilian/equip_survivor(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(H), SLOT_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), SLOT_SHOES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), SLOT_WEAR_MASK)

	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/globose(H), SLOT_WEAR_SUIT)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/globose(H), SLOT_HEAD)
	H.equip_to_slot_or_del(new /obj/item/weapon/tank/emergency_oxygen(H), SLOT_S_STORE)
