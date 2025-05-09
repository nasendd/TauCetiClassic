/*****************************Money bag********************************/

/obj/item/weapon/moneybag
	icon = 'icons/obj/storage.dmi'
	name = "Money bag"
	icon_state = "moneybag"
	flags = CONDUCT
	force = 10.0
	throwforce = 2.0
	w_class = SIZE_NORMAL

/obj/item/weapon/moneybag/attack_hand(user)
	var/amt_gold = 0
	var/amt_silver = 0
	var/amt_diamond = 0
	var/amt_iron = 0
	var/amt_phoron = 0
	var/amt_uranium = 0
	var/amt_clown = 0
	var/amt_platinum
	var/amt_hydrogen

	for (var/obj/item/weapon/coin/C in contents)
		if (istype(C,/obj/item/weapon/coin/diamond))
			amt_diamond++;
		if (istype(C,/obj/item/weapon/coin/phoron))
			amt_phoron++;
		if (istype(C,/obj/item/weapon/coin/iron))
			amt_iron++;
		if (istype(C,/obj/item/weapon/coin/silver))
			amt_silver++;
		if (istype(C,/obj/item/weapon/coin/gold))
			amt_gold++;
		if (istype(C,/obj/item/weapon/coin/uranium))
			amt_uranium++;
		if (istype(C,/obj/item/weapon/coin/bananium))
			amt_clown++;
		if (istype(C,/obj/item/weapon/coin/platinum))
			amt_platinum++;
		if (istype(C,/obj/item/weapon/coin/mythril))
			amt_hydrogen++;

	var/dat = ""
	if (amt_gold)
		dat += text("Gold coins: [amt_gold] <A href='byond://?src=\ref[src];remove=gold'>Remove one</A><br>")
	if (amt_silver)
		dat += text("Silver coins: [amt_silver] <A href='byond://?src=\ref[src];remove=silver'>Remove one</A><br>")
	if (amt_iron)
		dat += text("Metal coins: [amt_iron] <A href='byond://?src=\ref[src];remove=iron'>Remove one</A><br>")
	if (amt_diamond)
		dat += text("Diamond coins: [amt_diamond] <A href='byond://?src=\ref[src];remove=diamond'>Remove one</A><br>")
	if (amt_phoron)
		dat += text("Phoron coins: [amt_phoron] <A href='byond://?src=\ref[src];remove=phoron'>Remove one</A><br>")
	if (amt_uranium)
		dat += text("Uranium coins: [amt_uranium] <A href='byond://?src=\ref[src];remove=uranium'>Remove one</A><br>")
	if (amt_clown)
		dat += text("Bananium coins: [amt_clown] <A href='byond://?src=\ref[src];remove=clown'>Remove one</A><br>")
	if (amt_platinum)
		dat += text("Platinum coins: [amt_platinum] <A href='byond://?src=\ref[src];remove=platinum'>Remove one</A><br>")
	if (amt_hydrogen)
		dat += text("Mythril coins: [amt_hydrogen] <A href='byond://?src=\ref[src];remove=hydrogen'>Remove one</A><br>")

	var/datum/browser/popup = new(user, "moneybag", "The contents of the moneybag reveal...")
	popup.set_content(dat)
	popup.open()

/obj/item/weapon/moneybag/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/coin))
		var/obj/item/weapon/coin/C = I
		to_chat(user, "<span class='notice'>You add the [C.name] into the bag.</span>")
		user.drop_from_inventory(C)
		contents += C
		return
	if(istype(I, /obj/item/weapon/moneybag))
		var/obj/item/weapon/moneybag/C = I
		for (var/obj/O in C.contents)
			contents += O
		to_chat(user, "<span class='notice'>You empty the [C.name] into the bag.</span>")
		return
	return ..()

/obj/item/weapon/moneybag/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if(href_list["remove"])
		var/obj/item/weapon/coin/COIN
		switch(href_list["remove"])
			if("gold")
				COIN = locate(/obj/item/weapon/coin/gold,src.contents)
			if("silver")
				COIN = locate(/obj/item/weapon/coin/silver,src.contents)
			if("iron")
				COIN = locate(/obj/item/weapon/coin/iron,src.contents)
			if("diamond")
				COIN = locate(/obj/item/weapon/coin/diamond,src.contents)
			if("phoron")
				COIN = locate(/obj/item/weapon/coin/phoron,src.contents)
			if("uranium")
				COIN = locate(/obj/item/weapon/coin/uranium,src.contents)
			if("clown")
				COIN = locate(/obj/item/weapon/coin/bananium,src.contents)
			if("platinum")
				COIN = locate(/obj/item/weapon/coin/platinum,src.contents)
			if("hydrogen")
				COIN = locate(/obj/item/weapon/coin/mythril,src.contents)
		if(!COIN)
			return
		COIN.loc = src.loc
	return



/obj/item/weapon/moneybag/vault

/obj/item/weapon/moneybag/vault/atom_init()
	. = ..()
	for (var/i in 1 to 4)
		new /obj/item/weapon/coin/silver(src)
	for (var/i in 1 to 2)
		new /obj/item/weapon/coin/gold(src)
	new /obj/item/weapon/coin/platinum(src)
