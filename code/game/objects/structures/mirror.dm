//wip wip wup
/obj/structure/mirror
	name = "mirror"
	desc = "Mirror mirror on the wall, who's the most robust of them all?"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = FALSE
	anchored = TRUE
	var/shattered = 0

	max_integrity = 200
	integrity_failure = 0.5
	resistance_flags = UNACIDABLE | CAN_BE_HIT


/obj/structure/mirror/attack_hand(mob/user)
	user.SetNextMove(CLICK_CD_MELEE)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.a_intent == INTENT_HARM)
			H.do_attack_animation(src)
			if(!H.gloves)
				var/obj/item/organ/external/BP = H.bodyparts_by_name[H.hand ? BP_L_ARM : BP_R_ARM]
				BP.take_damage(rand(0, 4))
			if(!shattered && prob(20))
				shatter()
			else
				playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', VOL_EFFECTS_MASTER)
		else
			H.visible_message("[user] stares into \the [src].")
	..()

/obj/structure/mirror/proc/shatter()
	if(shattered)
		return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, pick(SOUNDIN_SHATTER), VOL_EFFECTS_MASTER)
	desc = "Oh no, seven years of bad luck!"


/obj/structure/mirror/bullet_act(obj/item/projectile/Proj, def_zone)
	. = ..()
	if(prob(Proj.damage * 2))
		if(!shattered)
			shatter()
		else
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', VOL_EFFECTS_MASTER)

/obj/structure/mirror/attackby(obj/item/I, mob/user)
	user.do_attack_animation(src)
	user.SetNextMove(CLICK_CD_MELEE)
	if(shattered)
		playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', VOL_EFFECTS_MASTER)
		return

	if(prob(I.force * 2))
		visible_message("<span class='warning'>[user] smashes [src] with [I]!</span>")
		shatter()
	else
		visible_message("<span class='warning'>[user] hits [src] with [I]!</span>")
		playsound(src, 'sound/effects/Glasshit.ogg', VOL_EFFECTS_MASTER)

/obj/structure/mirror/play_attack_sound(damage_amount, damage_type, damage_flag)
	if(damage_type == BRUTE)
		if(shattered)
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', VOL_EFFECTS_MASTER)
		else
			playsound(src, 'sound/effects/Glasshit.ogg', VOL_EFFECTS_MASTER)
	else
		..()

/obj/structure/mirror/atom_break(damage_flag, mapload)
	. = ..()
	if(!shattered)
		shatter()

/obj/structure/mirror/deconstruct(disassembled = TRUE)
	if(flags & NODECONSTRUCT)
		return ..()
	if(!disassembled)
		new /obj/item/weapon/shard(loc)
	..()

/obj/structure/mirror/attack_alien(mob/user)
	user.do_attack_animation(src)
	user.SetNextMove(CLICK_CD_MELEE)
	if(isxenolarva(user) || isfacehugger(user))
		return
	if(shattered)
		playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', VOL_EFFECTS_MASTER)
		return
	user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
	shatter()


/obj/structure/mirror/attack_animal(mob/living/simple_animal/attacker)
	..()
	if(attacker.melee_damage <= 0)
		return
	if(shattered)
		playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', VOL_EFFECTS_MASTER)
		return
	attacker.visible_message("<span class='danger'>[attacker] smashes [src]!</span>")
	shatter()


/obj/structure/mirror/attack_slime(mob/user)
	if(!isslimeadult(user))
		return
	user.SetNextMove(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	if(shattered)
		playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', VOL_EFFECTS_MASTER)
		return
	user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
	shatter()



// Wo-o, some magic goes here
/obj/structure/mirror/magic
	name = "magic mirror"
	desc = "Turn and face the strange... face."
	icon_state = "magic_mirror"
//	var/list/choosable_races = list()

/obj/structure/mirror/magic/attack_hand(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	var/choice = input(user, "Something to change?", "Magical Grooming") as null|anything in list("name", "skin tone", "xenos skin",  "gender", "hair", "eyes", "height", "belly")

	switch(choice)
		if("name")
			var/newname = sanitize_safe(input(H, "Who are we again?", "Name change", H.name) as null|text, MAX_NAME_LEN)

			if(!newname)
				return

			H.real_name = newname
			H.name = newname
			if(H.dna)
				H.dna.real_name = newname
			if(H.mind)
				H.mind.name = newname

		if ("skin tone")
			var/new_tone = input("Выберите цвет кожи", "Skin tone") in global.skin_tones_by_ru_name
			var/datum/skin_tone/T = global.skin_tones_by_ru_name[new_tone]
			H.s_tone = T.name
			H.update_body(update_preferences = TRUE)
			H.check_dna(H)

		if("xenos skin")
			var/new_skin = input(H, "Please select xeno-body color", "Xenos Skin") as null|color
			if(new_skin)
				H.r_skin = hex2num(copytext(new_skin, 2, 4))
				H.g_skin = hex2num(copytext(new_skin, 4, 6))
				H.b_skin = hex2num(copytext(new_skin, 6, 8))
			H.update_body(update_preferences = TRUE)
			H.check_dna(H)
	/*	if("race")
			var/newrace
			var/racechoice = input(H, "What are we again?", "Race change") as null|anything in choosable_races
			newrace = species_list[racechoice]

			if(!newrace)
				return

			H.set_species(newrace, icon_update=0)

			if(H.dna.species.use_skintones)
				var/new_s_tone = input(user, "Choose your skin tone:", "Race change")  as null|anything in skin_tones

				if(new_s_tone)
					H.skin_tone = new_s_tone
					H.dna.update_ui_block(DNA_SKIN_TONE_BLOCK)

			if(MUTCOLORS in H.dna.species.specflags)
				var/new_mutantcolor = input(user, "Choose your skin color:", "Race change") as color|null
				if(new_mutantcolor)
					var/temp_hsv = RGBtoHSV(new_mutantcolor)

					if(ReadHSV(temp_hsv)[3] >= ReadHSV("#7f7f7f")[3]) // mutantcolors must be bright
						H.dna.features["mcolor"] = sanitize_hexcolor(new_mutantcolor)

					else
						to_chat(H, "<span class='notice'>Invalid color. Your color is not bright enough.</span>")

			H.update_body()
			H.update_mutcolor()
			H.update_mutations_overlay() // no hulk lizard
			*/

		if("gender")
			if(!(H.gender in list("male", "female"))) //blame the patriarchy
				return

			if(H.gender == "male")
				if(tgui_alert(H, "Become a Witch?", "Confirmation", list("Yes", "No")) == "Yes")
					H.gender = "female"
					to_chat(H, "<span class='notice'>Man, you feel like a woman!</span>")
				else
					return

			else
				if(tgui_alert(H, "Become a Warlock?", "Confirmation", list("Yes", "No")) == "Yes")
					H.gender = "male"
					to_chat(H, "<span class='notice'>Whoa man, you feel like a man!</span>")
				else
					return
			H.update_body(update_preferences = TRUE)
			H.check_dna(H)

		if("hair")
			var/hairchoice = tgui_alert(H, "Hair style or hair color?", "Change Hair", list("Style", "Color"))

			if(hairchoice == "Style") //So you just want to use a mirror then?
				var/userloc = H.loc
				//handle facial hair (if necessary)
				if(H.gender == MALE)
					var/new_style = input(user, "Select a facial hair style", "Grooming") as null|anything in get_valid_styles_from_cache(facial_hairs_cache, H.get_species(), H.gender)
					if(userloc != H.loc)
						return	//no tele-grooming
					if(new_style)
						H.f_style = new_style
				//handle normal hair
				var/new_style = input(user, "Select a hair style", "Grooming") as null|anything in get_valid_styles_from_cache(hairs_cache, H.get_species(), H.gender)
				if(userloc != H.loc)
					return	//no tele-grooming
				if(new_style)
					H.h_style = new_style
			else
				var/new_hair = input(H, "Choose your hair color", "Hair Color") as null|color
				if(new_hair)
					H.r_hair = hex2num(copytext(new_hair, 2, 4))
					H.g_hair = hex2num(copytext(new_hair, 4, 6))
					H.b_hair = hex2num(copytext(new_hair, 6, 8))

				if(H.gender == "male")
					var/new_facial = input(H, "Choose your facial hair color", "Hair Color") as null|color
					if(new_facial)
						H.r_facial = hex2num(copytext(new_facial, 2, 4))
						H.g_facial = hex2num(copytext(new_facial, 4, 6))
						H.b_facial = hex2num(copytext(new_facial, 6, 8))
			H.update_body(BP_HEAD, update_preferences = TRUE)
			H.check_dna(H)

		if("eyes")
			var/new_eyes = input(H, "Choose your eye color", "Eye Color") as null|color
			if(new_eyes)
				H.r_eyes = hex2num(copytext(new_eyes, 2, 4))
				H.g_eyes = hex2num(copytext(new_eyes, 4, 6))
				H.b_eyes = hex2num(copytext(new_eyes, 6, 8))
			H.update_body(BP_HEAD, update_preferences = TRUE)
			H.check_dna(H)
		if("height")
			var/new_height = input(H, "Choose your character's height:", "Character Height", H.height) as null|anything in heights_list
			if(new_height)
				H.height = new_height
				H.regenerate_icons()
				H.check_dna(H)
		if("belly")
			var/new_belly = input(H, "Choose your belly color (UNATHI ONLY)", "Belly Color") as null|color
			if(new_belly)
				H.r_belly = hex2num(copytext(new_belly, 2, 4))
				H.g_belly = hex2num(copytext(new_belly, 4, 6))
				H.b_belly = hex2num(copytext(new_belly, 6, 8))
			H.update_body(BP_HEAD, update_preferences = TRUE)
			H.check_dna(H)
