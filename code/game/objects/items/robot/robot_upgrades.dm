// robot_upgrades.dm
// Contains various borg upgrades.

/obj/item/borg/upgrade
	name = "borg upgrade module."
	desc = "Protected by FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	item_state_world = "cyborg_upgrade_w"
	var/locked = 0
	var/require_module = 0
	var/installed = 0

/obj/item/borg/upgrade/proc/action(mob/living/silicon/robot/R)
	if(R.stat == DEAD)
		to_chat(usr, "<span class='warning'>The [src] will not function on a deceased robot.</span>")
		return 1
	return 0


/obj/item/borg/upgrade/reset
	name = "robotic module reset board"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"
	item_state_world = "cyborg_upgrade1_w"
	require_module = 1

/obj/item/borg/upgrade/reset/action(mob/living/silicon/robot/R)
	if(..())
		return 0

	R.uneq_all()
	R.icon_state = "robot"
	clearlist(R.module.channels)
	qdel(R.module)
	R.module = null
	R.module_icon.update_icon(R)
	R.sensor_huds = R.def_sensor_huds
	R.camera.remove_networks(list("Engineering","Medical","MINE"))
	R.updatename("Default")
	R.add_status_flags(CANPUSH)
	R.updateicon()

	return 1

/obj/item/borg/upgrade/rename
	name = "robot reclassification board"
	desc = "Used to rename a cyborg."
	icon_state = "cyborg_upgrade1"
	item_state_world = "cyborg_upgrade1_w"
	var/heldname = "default name"

/obj/item/borg/upgrade/rename/attack_self(mob/user)
	heldname = sanitize_safe(input(user, "Enter new robot name", "Robot Reclassification", input_default(heldname)), MAX_NAME_LEN)

/obj/item/borg/upgrade/rename/action(mob/living/silicon/robot/R)
	if(..()) return 0
	R.name = heldname
	R.custom_name = heldname
	R.real_name = heldname

	return 1

/obj/item/borg/upgrade/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "cyborg_upgrade1"
	item_state_world = "cyborg_upgrade1_w"


/obj/item/borg/upgrade/restart/action(mob/living/silicon/robot/R)
	if(R.health < 0)
		to_chat(usr, "You have to repair the robot before using this module!")
		return 0

	if(!R.key)
		for(var/mob/dead/observer/ghost in player_list)
			if(ghost.mind && ghost.mind.current == R)
				R.key = ghost.key

	R.stat = CONSCIOUS
	playsound(src, 'sound/misc/robot_restart.ogg', VOL_EFFECTS_MASTER, 70, FALSE)
	return 1


/obj/item/borg/upgrade/vtec
	name = "robotic VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	item_state_world = "cyborg_upgrade2_w"
	require_module = 1

/obj/item/borg/upgrade/vtec/action(mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.speed == -1)
		return 0

	R.speed--
	return 1


/obj/item/borg/upgrade/tasercooler
	name = "robotic Rapid Taser Cooling Module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	icon_state = "cyborg_upgrade3"
	item_state_world = "cyborg_upgrade3_w"
	require_module = 1


/obj/item/borg/upgrade/tasercooler/action(mob/living/silicon/robot/R)
	if(..()) return 0

	if(!istype(R.module, /obj/item/weapon/robot_module/security))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0

	var/obj/item/weapon/gun/energy/taser/cyborg/T = locate() in R.module
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		to_chat(usr, "This robot has had its taser removed!")
		return 0

	if(T.recharge_time <= 2)
		to_chat(R, "Maximum cooling achieved for this hardpoint!")
		to_chat(usr, "There's no room for another cooling unit!")
		return 0

	else
		T.recharge_time = max(2 , T.recharge_time - 4)

	return 1

/obj/item/borg/upgrade/jetpack
	name = "robot jetpack"
	desc = "A carbon dioxide jetpack suitable for low-gravity operations."
	icon_state = "cyborg_upgrade3"
	item_state_world = "cyborg_upgrade3_w"
	require_module = 1

/obj/item/borg/upgrade/jetpack/action(mob/living/silicon/robot/R)
	if(..()) return 0

	for(var/obj/item/weapon/tank/jetpack/J in R.module.modules)
		if(J && istype(J, /obj/item/weapon/tank/jetpack))
			to_chat(usr, "There's no room for another jetpack!")
			return 0
	var/obj/item/weapon/tank/jetpack/carbondioxide/jet = new(R.module)
	R.module.add_item(jet)
	/*for(var/obj/item/weapon/tank/jetpack/carbondioxide in R.module.modules) //we really need this?
		R.internals = jet*/
	//R.icon_state="Miner+j"
	return 1


/obj/item/borg/upgrade/syndicate
	name = "illegal equipment module"
	desc = "Unlocks the hidden, deadlier functions of a robot."
	icon_state = "cyborg_upgrade3"
	item_state_world = "cyborg_upgrade3_w"
	require_module = 1

/obj/item/borg/upgrade/syndicate/action(mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.emagged == 1)
		return 0

	R.throw_alert("hacked", /atom/movable/screen/alert/hacked)
	R.emagged = 1
	return 1

/obj/item/borg/upgrade/security
	name = "security safety protocols module"
	desc = "Unlocks the ability to become a security cyborg."
	icon_state = "cyborg_upgrade3"
	item_state_world = "cyborg_upgrade3_w"
	require_module = FALSE

/obj/item/borg/upgrade/security/action(mob/living/silicon/robot/R)
	if(..())
		return FALSE

	if(R.can_be_security)
		return FALSE

	R.can_be_security = TRUE
	return TRUE

/obj/item/borg/upgrade/hud_calibrator
	name = "Рекалибратор дисплея"
	desc = "Рекалибрует дисплей с помощью интерференции волн, улучшая опыт пользования визуальным интерфейсом."
	icon_state = "cyborg_upgrade2"
	item_state_world = "cyborg_upgrade2_w"
	require_module = TRUE

/obj/item/borg/upgrade/hud_calibrator/action(mob/living/silicon/robot/R)
	if(..())
		return FALSE
	var/founded_hud = FALSE
	for(var/obj/item/borg/sight/hud in R?.module?.modules)
		if(!(hud.sight_mode & BORGIGNORESIGHT))
			hud.sight_mode |= BORGIGNORESIGHT
			founded_hud = TRUE
	return founded_hud

