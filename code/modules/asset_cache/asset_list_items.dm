//DEFINITIONS FOR ASSET DATUMS START HERE. Heavily edited by NEV

/datum/asset/simple/tgui
	keep_local_name = TRUE
	assets = list(
		"tgui.bundle.js" = file("tgui/public/tgui.bundle.js"),
		"tgui.bundle.css" = file("tgui/public/tgui.bundle.css"),
	)

/datum/asset/simple/tgui_panel
	keep_local_name = TRUE
	assets = list(
		"tgui-panel.bundle.js" = file("tgui/public/tgui-panel.bundle.js"),
		"tgui-panel.bundle.css" = file("tgui/public/tgui-panel.bundle.css"),
	)

/datum/asset/simple/namespaced/tgfont
	assets = list(
		"tgfont.eot" = file("tgui/packages/tgfont/static/tgfont.eot"),
		"tgfont.woff2" = file("tgui/packages/tgfont/static/tgfont.woff2"),
	)
	parents = list(
		"tgfont.css" = file("tgui/packages/tgfont/static/tgfont.css"),
	)

/datum/asset/simple/irv
	assets = list(
		"jquery-ui.custom-core-widgit-mouse-sortable.min.js" = 'html/jquery/jquery-ui.custom-core-widgit-mouse-sortable.min.js',
	)

/datum/asset/group/irv
	children = list(
		/datum/asset/simple/jquery,
		/datum/asset/simple/irv
	)

/datum/asset/simple/jquery
	legacy = TRUE
	assets = list(
		"jquery.min.js" = 'html/jquery/jquery.min.js',
	)

/datum/asset/simple/namespaced/fontawesome
	assets = list(
		"fa-regular-400.eot"  = 'html/font-awesome/webfonts/fa-regular-400.eot',
		"fa-regular-400.woff" = 'html/font-awesome/webfonts/fa-regular-400.woff',
		"fa-solid-900.eot"    = 'html/font-awesome/webfonts/fa-solid-900.eot',
		"fa-solid-900.woff"   = 'html/font-awesome/webfonts/fa-solid-900.woff',
		"v4shim.css"          = 'html/font-awesome/css/v4-shims.min.css'
	)
	parents = list("font-awesome.css" = 'html/font-awesome/css/all.min.css')

/datum/asset/simple/goonchat
	legacy = TRUE
	assets = list(
		"json2.min.js"             = 'code/modules/goonchat/browserassets/js/json2.min.js',
		"browserOutput.js"         = 'code/modules/goonchat/browserassets/js/browserOutput.js',
		"browserOutput.css"	       = 'code/modules/goonchat/browserassets/css/browserOutput.css',
		"browserOutput_white.css"  = 'code/modules/goonchat/browserassets/css/browserOutput_white.css',
		"browserOutput_override.css"  = 'code/modules/goonchat/browserassets/css/browserOutput_override.css',
	)

/datum/asset/group/goonchat
	children = list(
		/datum/asset/simple/jquery,
		/datum/asset/simple/goonchat,
		/datum/asset/simple/namespaced/fontawesome
	)

/datum/asset/simple/namespaced/common
	assets = list("padlock.png" = 'icons/ui_icons/common/padlock.png')
	parents = list("common.css" = 'html/browser/common.css')

/* === ERIS STUFF === */
/datum/asset/spritesheet_batched/design_icons
	name = "design_icons"
	// we have a bunch of fucking designs that don't have icons and other bullshit that we just need to ignore
	ignore_associated_icon_state_errors = TRUE

	var/design_data_loaded = FALSE

/datum/asset/spritesheet_batched/design_icons/create_spritesheets()
	for(var/datum/design/design as anything in SSresearch.all_designs)
		var/key = sanitize_css_class_name("[design.build_path]")

		var/atom/item = design.build_path
		if(!ispath(item, /atom))
			continue

		var/icon_file = initial(item.icon)
		if(!icon_file)
			continue

		var/icon_state = initial(item.icon_state)

		insert_icon(key, uni_icon(icon_file, icon_state))

// Set up design nano data after all else is done
/datum/asset/spritesheet_batched/design_icons/queued_generation()
	. = ..()
	set_design_nano_data()

/datum/asset/spritesheet_batched/design_icons/ensure_ready()
	. = ..()
	set_design_nano_data()

/datum/asset/spritesheet_batched/design_icons/proc/set_design_nano_data()
	if(!design_data_loaded)
		for(var/datum/design/design as anything in SSresearch.all_designs)
			design.nano_ui_data["icon"] = icon_class_name(sanitize_css_class_name("[design.build_path]"))
		design_data_loaded = TRUE

/datum/asset/simple/materials/register()
	for(var/type in subtypesof(/obj/item/stack/material) - typesof(/obj/item/stack/material/cyborg))
		var/filename = sanitizeFileName("[type].png")
		var/icon/I = getFlatTypeIcon(type)
		assets[filename] = I
	..()

/datum/asset/simple/ores/register()
	for(var/type in subtypesof(/obj/item/ore)) //For when this is made into a stack type
		var/filename = sanitizeFileName("[type].png")
		var/icon/I = getFlatTypeIcon(type)
		assets[filename] = I
	..()

/datum/asset/simple/craft/register()
	var/list/craftStep = list()
	for(var/name in SScraft.categories)
		for(var/datum/craft_recipe/CR in SScraft.categories[name])
			if(CR.result)
				var/filename = sanitizeFileName("[CR.result].png")
				var/icon/I = getFlatTypeIcon(CR.result)
				assets[filename] = I

			for(var/datum/craft_step/CS in CR.steps)
				craftStep.Add(CS)
				if(CS.reqed_type)
					var/filename = sanitizeFileName("[CS.reqed_type].png")
					var/icon/I = getFlatTypeIcon(CS.reqed_type)
					assets[filename] = I
	..()

	// this is fucked but crafting has a circular dept unfortunantly. could unfuck with tgui port
	for(var/datum/craft_step/CS as anything in craftStep)
		if (!CS.reqed_material && !CS.reqed_type)
			continue
		CS.iconfile = SSassets.transport.get_asset_url(CS.reqed_material ? sanitizeFileName("[material_stack_type(CS.reqed_material)].png") : null, assets[sanitizeFileName("[CS.reqed_type].png")])
		CS.make_desc() // redo it

/datum/asset/simple/tool_upgrades/register()
	for(var/type in subtypesof(/obj/item/tool_upgrade))
		var/filename = sanitizeFileName("[type].png")
		var/icon/I = getFlatTypeIcon(type)
		assets[filename] = I
	..()

/datum/asset/simple/perks/register()
	for(var/type in subtypesof(/datum/perk))
		var/datum/perk/P = new type
		var/filename = sanitizeFileName("[type].png")
		var/icon/I = icon(P.icon, P.icon_state)
		assets[filename] = I
	..()
/* Used with circuits, something NEV seems to not have
/datum/asset/simple/codicon
	assets = list(
		"codicon.css" = 'html/codicon/codicon.css',
		"codicon.ttf" = 'html/codicon/codicon.ttf'
	)
*/
/datum/asset/simple/directories/nanoui
	dirs = list(
		"nano/js/",
		"nano/css/",
		"nano/images/",
		"nano/templates/",
		"nano/images/status_icons/",
		"nano/images/modular_computers/",
	)

/datum/asset/simple/directories/images_news
	dirs = list("news_articles/images/")

/datum/asset/simple/directories
	keep_local_name = TRUE
	var/list/dirs = list()

/datum/asset/simple/directories/register()
	// Crawl the directories to find files.
	for (var/path in dirs)
		var/list/filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) != "/") // Ignore directories.
				if(fexists(path + filename))
					assets[filename] = file(path + filename)
	..()

/datum/asset/simple/images_map
	keep_local_name = TRUE

/datum/asset/simple/images_map/register()
	var/list/mapnames = list()
	for(var/z in GLOB.maps_data.station_levels)
		mapnames += map_image_file_name(z)

	var/list/filenames = flist(MAP_IMAGE_PATH)
	for(var/filename in filenames)
		if(copytext(filename, length(filename)) != "/") // Ignore directories.
			var/file_path = MAP_IMAGE_PATH + filename
			if((filename in mapnames) && fexists(file_path))
				assets[filename] = fcopy_rsc(file_path)
	..()