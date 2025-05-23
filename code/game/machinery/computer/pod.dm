/obj/machinery/computer/pod
	name = "Pod Launch Control"
	desc = "A controll for launching pods. Some people prefer firing Mechas."
	icon_state = "computer_generic"
	light_color = "#00b000"
	circuit = /obj/item/weapon/circuitboard/pod
	var/id = 1.0
	var/obj/machinery/mass_driver/connected = null
	var/timing = 0.0
	var/time = 30.0
	var/title = "Mass Driver Controls"


/obj/machinery/computer/pod/atom_init()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/pod/atom_init_late()
	for(var/obj/machinery/mass_driver/M in mass_driver_list)
		if(M.id == id)
			connected = M

/obj/machinery/computer/pod/proc/alarm()
	if(stat & (NOPOWER|BROKEN))
		return

	if(!connected)
		to_chat(viewers(), "Cannot locate mass driver connector. Cancelling firing sequence!")
		return

	for(var/obj/machinery/door/poddoor/M in poddoor_list)
		if(M.id == id)
			M.open()

	sleep(20)

	for(var/obj/machinery/mass_driver/M in mass_driver_list)
		if(M.id == id)
			M.power = connected.power
			M.drive()

	sleep(50)
	for(var/obj/machinery/door/poddoor/M in poddoor_list)
		if(M.id == id)
			M.close()
			return
	return

/obj/machinery/computer/pod/ui_interact(mob/user)
	var/dat = "<TT>"
	if(connected)
		var/d2
		if(timing)	//door controls do not need timers.
			d2 = "<A href='byond://?src=\ref[src];time=0'>Stop Time Launch</A>"
		else
			d2 = "<A href='byond://?src=\ref[src];time=1'>Initiate Time Launch</A>"
		var/second = time % 60
		var/minute = (time - second) / 60
		dat += "<HR>\nTimer System: [d2]\nTime Left: [minute ? "[minute]:" : null][second] <A href='byond://?src=\ref[src];tp=-30'>-</A> <A href='byond://?src=\ref[src];tp=-1'>-</A> <A href='byond://?src=\ref[src];tp=1'>+</A> <A href='byond://?src=\ref[src];tp=30'>+</A>"
		var/temp = ""
		var/list/L = list( 0.25, 0.5, 1, 2, 4, 8, 16 )
		for(var/t in L)
			if(t == connected.power)
				temp += "[t] "
			else
				temp += "<A href = 'byond://?src=\ref[src];power=[t]'>[t]</A> "
		dat += "<HR>\nPower Level: [temp]<BR>\n<A href = 'byond://?src=\ref[src];alarm=1'>Firing Sequence</A><BR>\n<A href = 'byond://?src=\ref[src];drive=1'>Test Fire Driver</A><BR>\n<A href = 'byond://?src=\ref[src];door=1'>Toggle Outer Door</A><BR>"
	else
		dat += "<BR>\n<A href = 'byond://?src=\ref[src];door=1'>Toggle Outer Door</A><BR>"
	dat += "</TT>"

	var/datum/browser/popup = new(user, "computer", "[title]", 400, 500)
	popup.set_content(dat)
	popup.open()


/obj/machinery/computer/pod/process()
	if(!..())
		return
	if(timing)
		if(time > 0)
			time = round(time) - 1
		else
			alarm()
			time = 0
			timing = 0
		updateDialog()
	return


/obj/machinery/computer/pod/Topic(href, href_list)
	. = ..()
	if(!.)
		return

	if(href_list["power"])
		var/t = text2num(href_list["power"])
		t = min(max(0.25, t), 16)
		if(connected)
			connected.power = t
	if(href_list["alarm"])
		alarm()
	if(href_list["drive"])
		for(var/obj/machinery/mass_driver/M in mass_driver_list)
			if(M.id == id)
				M.power = connected.power
				M.drive()

	if(href_list["time"])
		timing = text2num(href_list["time"])
	if(href_list["tp"])
		var/tp = text2num(href_list["tp"])
		time += tp
		time = min(max(round(time), 0), 120)
	if(href_list["door"])
		for(var/obj/machinery/door/poddoor/M in poddoor_list)
			if(M.id == id)
				if(M.density)
					M.open()
				else
					M.close()
	updateUsrDialog()


/obj/machinery/computer/pod/old
	icon_state = "computer_old"
	name = "DoorMex Control Computer"
	title = "Door Controls"

/obj/machinery/computer/pod/old/syndicate
	name = "ProComp Executive IIc"
	icon_state = "computer_regular"
	desc = "The Syndicate operate on a tight budget. Operates external airlocks."
	title = "External Airlock Controls"
	req_access = list(access_syndicate)

/obj/machinery/computer/pod/old/swf
	name = "Magix System IV"
	desc = "An arcane artifact that holds much magic. Running E-Knock 2.2: Sorceror's Edition."
