/obj/machinery/computer/operating
	name = "Operating Computer"
	density = TRUE
	anchored = TRUE
	icon_state = "operating"
	state_broken_preset = "crewb"
	state_nopower_preset = "crew0"
	light_color = "#315ab4"
	circuit = /obj/item/weapon/circuitboard/operating
	var/mob/living/carbon/human/victim = null
	var/obj/machinery/optable/table = null

/obj/machinery/computer/operating/atom_init()
	. = ..()
	for(var/newdir in cardinal)
		table = locate(/obj/machinery/optable, get_step(src, newdir))
		if(table)
			table.computer = src
			break

/obj/machinery/computer/operating/ui_interact(mob/user)
	if ( (get_dist(src, user) > 1 ) || (stat & (BROKEN|NOPOWER)) )
		if (!issilicon(user) && !isobserver(user))
			user.unset_machine()
			user << browse(null, "window=op")
			return

	var/dat = ""
	if(src.table && (table.check_victim()))
		src.victim = src.table.victim
		dat += {"
			<B>Patient Information:</B><BR>
			<BR>
			<B>Name:</B> [src.victim.real_name]<BR>
			<B>Age:</B> [src.victim.age]<BR>
			<B>Blood Type:</B> [src.victim.dna.b_type]<BR>
			<BR>
			<B>Health:</B> [src.victim.health]<BR>
			<B>Brute Damage:</B> [ceil(victim.getBruteLoss())]<BR>
			<B>Toxins Damage:</B> [ceil(victim.getToxLoss())]<BR>
			<B>Fire Damage:</B> [ceil(victim.getFireLoss())]<BR>
			<B>Suffocation Damage:</B> [ceil(victim.getOxyLoss())]<BR>
			<B>Patient Status:</B> [src.victim.stat ? "Non-Responsive" : "Stable"]<BR>
			<B>Heartbeat rate:</B> [victim.get_pulse(GETPULSE_TOOL)]<BR>
			"}
	else
		src.victim = null
		dat += {"
			<B>Patient Information:</B><BR>
			<BR>
			<B>No Patient Detected</B>
			"}

	var/datum/browser/popup = new(user, "window=op", "Operating Computer")
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/operating/process()
	if(..())
		updateDialog()
