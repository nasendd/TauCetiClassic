/obj/item/device/transfer_valve
	icon = 'icons/obj/assemblies.dmi'
	name = "tank transfer valve"
	icon_state = "valve_1"
	item_state = "ttv"
	desc = "Regulates the transfer of air between two tanks."
	flags = HEAR_TALK
	var/obj/item/weapon/tank/tank_one
	var/obj/item/weapon/tank/tank_two
	var/obj/item/device/attached_device
	var/mob/attacher = null
	var/valve_open = 0
	var/toggle = 1

/obj/item/device/transfer_valve/proc/process_activation(obj/item/device/D)

/obj/item/device/transfer_valve/IsAssemblyHolder()
	return 1

/obj/item/device/transfer_valve/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/tank))
		if(tank_one && tank_two)
			to_chat(user, "<span class='warning'>There are already two tanks attached, remove one first.</span>")
			return

		if(!tank_one)
			tank_one = I
			user.drop_from_inventory(I, src)
			to_chat(user, "<span class='notice'>You attach the tank to the transfer valve.</span>")
		else if(!tank_two)
			tank_two = I
			user.drop_from_inventory(I, src)
			to_chat(user, "<span class='notice'>You attach the tank to the transfer valve.</span>")

		update_icon()
		nanomanager.update_uis(src) // update all UIs attached to src

//TODO: Have this take an assemblyholder
	else if(isassembly(I))
		var/obj/item/device/assembly/A = I
		if(A.secured)
			to_chat(user, "<span class='notice'>The device is secured.</span>")
			return
		if(attached_device)
			to_chat(user, "<span class='warning'>There is already an device attached to the valve, remove it first.</span>")
			return
		user.drop_from_inventory(A, src)
		attached_device = A
		to_chat(user, "<span class='notice'>You attach the [A] to the valve controls and secure it.</span>")
		A.holder = src
		A.toggle_secure()	//this calls update_icon(), which calls update_icon() on the holder (i.e. the bomb).

		bombers += "[key_name(user)] attached a [A] to a transfer valve."
		message_admins("[key_name_admin(user)] attached a [A] to a transfer valve. [ADMIN_JMP(user)]")
		log_game("[key_name(user)] attached a [A] to a transfer valve.")
		attacher = user
		nanomanager.update_uis(src) // update all UIs attached to src

	else
		return ..()

/obj/item/device/transfer_valve/hear_talk(mob/living/M, msg)
	if(!attached_device)	return
	attached_device.hear_talk(M,msg)
	return

/obj/item/device/transfer_valve/attack_self(mob/user)
	ui_interact(user)

/obj/item/device/transfer_valve/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)

	// this is the data which will be sent to the ui
	var/data[0]
	data["attachmentOne"] = tank_one ? tank_one.name : null
	data["attachmentTwo"] = tank_two ? tank_two.name : null
	data["valveAttachment"] = attached_device ? attached_device.name : null
	data["valveOpen"] = valve_open ? 1 : 0

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "transfer_valve.tmpl", "Tank Transfer Valve", 460, 280)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		//ui.set_auto_update(1)

/obj/item/device/transfer_valve/Topic(href, href_list)
	..()
	if ( usr.incapacitated() )
		return 0
	if (src.loc != usr)
		return 0
	if(tank_one && href_list["tankone"])
		split_gases()
		valve_open = 0
		tank_one.loc = get_turf(src)
		tank_one = null
		update_icon()
	else if(tank_two && href_list["tanktwo"])
		split_gases()
		valve_open = 0
		tank_two.loc = get_turf(src)
		tank_two = null
		update_icon()
	else if(href_list["open"])
		toggle_valve()
	else if(attached_device)
		if(href_list["rem_device"])
			attached_device.loc = get_turf(src)
			attached_device:holder = null
			attached_device = null
			update_icon()
		if(href_list["device"])
			attached_device.attack_self(usr)
	add_fingerprint(usr)
	return 1 // Returning 1 sends an update to attached UIs

/obj/item/device/transfer_valve/process_activation(obj/item/device/D)
	if(toggle)
		toggle = 0
		toggle_valve()
		spawn(50) // To stop a signal being spammed from a proxy sensor constantly going off or whatever
			toggle = 1

/obj/item/device/transfer_valve/update_icon()
	cut_overlays()
	underlays = null

	if(!tank_one && !tank_two && !attached_device)
		icon_state = "valve_1"
		return
	icon_state = "valve"

	if(tank_one)
		add_overlay("[tank_one.icon_state]")
	if(tank_two)
		var/icon/J = new(icon, icon_state = "[tank_two.icon_state]")
		J.Shift(WEST, 13)
		underlays += J
	if(attached_device)
		add_overlay("device")

/obj/item/device/transfer_valve/proc/merge_gases()
	tank_two.air_contents.volume += tank_one.air_contents.volume
	var/datum/gas_mixture/temp
	temp = tank_one.air_contents.remove_ratio(1)
	tank_two.air_contents.merge(temp)

/obj/item/device/transfer_valve/proc/split_gases()
	if (!valve_open || !tank_one || !tank_two)
		return
	var/ratio1 = tank_one.air_contents.volume/tank_two.air_contents.volume
	var/datum/gas_mixture/temp
	temp = tank_two.air_contents.remove_ratio(ratio1)
	tank_one.air_contents.merge(temp)
	tank_two.air_contents.volume -=  tank_one.air_contents.volume

	/*
	Exadv1: I know this isn't how it's going to work, but this was just to check
	it explodes properly when it gets a signal (and it does).
	*/

/obj/item/device/transfer_valve/proc/toggle_valve()
	if(valve_open==0 && (tank_one && tank_two))
		valve_open = 1
		var/turf/bombturf = get_turf(src)
		var/area/A = get_area(bombturf)

		var/attacher_name = ""
		if(!attacher)
			attacher_name = "Unknown"
		else
			attacher_name = "[attacher.name]([attacher.ckey])"

		var/log_str = "Bomb valve opened in <A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[A.name]</a> "
		log_str += "with [attached_device ? attached_device : "no device"] attacher: [attacher_name]"

		if(attacher)
			log_str += "(<A href='byond://?_src_=holder;adminmoreinfo=\ref[attacher]'>?</A>)"

		var/mob/mob = get_mob_by_key(src.fingerprintslast)
		var/last_touch_info = ""
		if(mob)
			last_touch_info = "(<A href='byond://?_src_=holder;adminmoreinfo=\ref[mob]'>?</A>)"

		log_str += " Last touched by: [src.fingerprintslast][last_touch_info]"
		bombers += log_str
		message_admins(log_str)
		log_game("Bomb valve opened in [A.name] with [attached_device ? attached_device : "no device"] attacher: [attacher_name], last touched by [mob ? "[key_name(mob)]" : "[src.fingerprintslast][last_touch_info]"]")
		merge_gases()
		spawn(20) // In case one tank bursts
			for (var/i=0,i<5,i++)
				update_icon()
				sleep(10)
			update_icon()

	else if(valve_open==1 && (tank_one && tank_two))
		split_gases()
		valve_open = 0
		update_icon()

// this doesn't do anything but the timer etc. expects it to be here
// eventually maybe have it update icon to show state (timer, prox etc.) like old bombs
/obj/item/device/transfer_valve/proc/c_state()
	return

// todo: check /obj/item/weapon/tank/ex_act(severity), need to pass explosion to content
/obj/item/device/transfer_valve/ex_act(severity)
	if(tank_one && tank_one.reaction_in_progress || tank_two && tank_two.reaction_in_progress) // give it time to explode
		return // nope, spacemans wants to explode multiple bombs at the same time

	return ..()
