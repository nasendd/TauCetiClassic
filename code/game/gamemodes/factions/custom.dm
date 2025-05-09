/datum/faction/custom
	name = "Custom Faction"
	ID = "Custom"
	var/spoiler_open = FALSE

/datum/faction/custom/proc/show_setting(datum/mind/M)
	var/dat = ""
	dat += "<center><B>Settings of Faction</B></center><HR><BR>"
	dat += "<B><A href='byond://?src=\ref[src];set_custom_name=1;custom_mind=\ref[M]'>Название</A>:</B> [name]<BR>"
	dat += "<B><A href='byond://?src=\ref[src];set_custom_logo=1;custom_mind=\ref[M]'>Логотип</A>:</B> [logo_state]<BR>"
	dat += "<B><A href='byond://?src=\ref[src];open_custom_logos=1;custom_mind=\ref[M]'>[spoiler_open ? "Закрыть" : "Открыть"] доступные логотипы</A>:</B><HR>"
	if(spoiler_open)
		for(var/name in icon_states('icons/misc/logos.dmi'))
			if(!name)
				continue
			var/icon/logo = icon('icons/misc/logos.dmi', name)
			dat += "[bicon(logo, css = "style='position:relative; top:10;'")] - [name] <BR>"

	var/datum/browser/popup = new(usr, "setup_faction", "Faction Settings", 500, 700)
	popup.set_content(dat)
	popup.open()

/datum/faction/custom/extraPanelButtons(datum/mind/M)
	var/dat = ..()
	dat += " - <A href='byond://?src=\ref[src];open_menu=1;custom_mind=\ref[M]'>(Open Menu)</a>"
	return dat

/datum/faction/custom/Topic(href, href_list)
	if(!check_rights(R_ADMIN))
		return

	var/datum/mind/M = locate(href_list["custom_mind"])
	if(!M)
		return
	if(href_list["set_custom_name"])
		var/new_name = input(usr, "Введите название", "Настройки Роли", name)
		if(!new_name)
			return
		name = new_name

	else if(href_list["set_custom_logo"])
		var/new_logo = input(usr, "Введите лого", "Настройки Роли", logo_state)
		if(!new_logo)
			return
		logo_state = new_logo

	else if(href_list["open_custom_logos"])
		spoiler_open = !spoiler_open

	else if(href_list["open_menu"])
		show_setting(M)
		return

	show_setting(M)
