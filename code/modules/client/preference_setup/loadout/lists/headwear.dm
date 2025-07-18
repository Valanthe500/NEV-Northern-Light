/datum/gear/head
	display_name = "bandana, pirate-red"
	path = /obj/item/clothing/head/bandana
	slot = slot_head
	sort_category = "Hats and Headwear"

/datum/gear/head/bandana_green
	display_name = "bandana, green"
	path = /obj/item/clothing/head/bandana/green

/datum/gear/head/bandana_orange
	display_name = "bandana, orange"
	path = /obj/item/clothing/head/bandana/orange

/datum/gear/head/beret
	display_name = "beret, red"
	path = /obj/item/clothing/head/beret

/datum/gear/head/beret/purp
	display_name = "beret, purple"
	path = /obj/item/clothing/head/beret/purple

/datum/gear/head/beret/moebius
	display_name = "beret, Lazarus"
	path = /obj/item/clothing/head/beret/moebius
	allowed_roles = list(JOBS_SCIENCE, JOBS_MEDICAL)

/datum/gear/head/beret/oberth
	display_name = "beret, Oberth" //Uberth
	path = /obj/item/clothing/head/beret/german

/datum/gear/head/beret/ntsec
	display_name = "beret, old security"
	path = /obj/item/clothing/head/beret/oldsec

/datum/gear/head/beret/bsec
	display_name = "beret, Operative"
	path = /obj/item/clothing/head/beret/sec/navy/officer
	allowed_roles = list(JOBS_SECURITY)

/datum/gear/head/beret/bsec_warden
	display_name = "beret, Sergeant"
	path = /obj/item/clothing/head/beret/sec/navy/warden
	allowed_roles = list("Aegis Commander","Aegis Gunnery Sergeant")

/datum/gear/head/beret/bsec_hos
	display_name = "beret, Lieutenant"
	path = /obj/item/clothing/head/beret/sec/navy/hos
	allowed_roles = list("Aegis Commander")

/datum/gear/head/beret/eng
	display_name = "beret, yellow enginering"
	path = /obj/item/clothing/head/beret/engineering
	allowed_roles = list(JOBS_ENGINEERING)

/datum/gear/head/beret/eng/old
	display_name = "beret, orange engineering"
	path = /obj/item/clothing/head/beret/engineering/old
	allowed_roles = list(JOBS_ENGINEERING)

/datum/gear/head/cap/flat
	display_name = "cap, brown-flat"
	path = /obj/item/clothing/head/flatcap

/datum/gear/head/cap/corp
	display_name = "cap, corporate security"
	path = /obj/item/clothing/head/soft/sec/corp
	allowed_roles = list("Aegis Operative","Aegis Commander","Aegis Gunnery Sergeant", "Inspector")

/datum/gear/head/cap/sec
	display_name = "cap, old security"
	path = /obj/item/clothing/head/soft/sec
	allowed_roles = list(ASSISTANT_TITLE)

/datum/gear/head/cap/rainbow
	display_name = "cap, rainbow"
	path = /obj/item/clothing/head/soft/rainbow

/datum/gear/head/cap/color_presets
	display_name = "cap, color presets"
	path = /obj/item/clothing/head/soft/blue

/datum/gear/head/cap/color_presets/New()
	..()
	var/cap = list(
		"White"			=	/obj/item/clothing/head/soft/mime,
		"Grey"			=	/obj/item/clothing/head/soft/grey,
		"Brown-Flat"	=	/obj/item/clothing/head/flatcap,
		"Red"			=	/obj/item/clothing/head/soft/red,
		"Orange"		=	/obj/item/clothing/head/soft/orange,
		"Yellow"		=	/obj/item/clothing/head/soft/yellow,
		"Green"			=	/obj/item/clothing/head/soft/green,
		"Blue"			=	/obj/item/clothing/head/soft/blue,
		"Blue Station"	=	/obj/item/clothing/head/mailman,
		"Purple"		=	/obj/item/clothing/head/soft/purple,
	)
	gear_tweaks += new /datum/gear_tweak/path(cap)

/datum/gear/head/hairflower
	display_name = "hair flower pin, red"
	path = /obj/item/clothing/head/hairflower

/datum/gear/head/hardhat/color_presets
	display_name = "hardhat, color presets"
	path = /obj/item/clothing/head/hardhat/blue
	cost = 2

/datum/gear/head/hardhat/color_presets/New()
	..()
	var/hardhat = list(
		"Red"		=	/obj/item/clothing/head/hardhat/red,
		"Orange"	=	/obj/item/clothing/head/hardhat/orange,
		"Yellow"	=	/obj/item/clothing/head/hardhat,
		"Blue"		=	/obj/item/clothing/head/hardhat/blue,
	)
	gear_tweaks += new /datum/gear_tweak/path(hardhat)

/datum/gear/head/welding
	display_name = "welding mask"
	path = /obj/item/clothing/head/welding
	cost = 2

/datum/gear/head/boater
	display_name = "hat, boatsman"
	path = /obj/item/clothing/head/boaterhat

/datum/gear/head/bowler
	display_name = "hat, bowler"
	path = /obj/item/clothing/head/bowler

/datum/gear/head/fez
	display_name = "hat, fez"
	path = /obj/item/clothing/head/fez

/datum/gear/head/tophat
	display_name = "hat, tophat"
	path = /obj/item/clothing/head/that

/datum/gear/head/fedora
	display_name = "fedora"
	path = /obj/item/clothing/head/fedora

/datum/gear/head/trilby
	display_name = "feather trilby"
	path = /obj/item/clothing/head/feathertrilby

/datum/gear/head/philosopher_wig
	display_name = "natural philosopher wig"
	path = /obj/item/clothing/head/philosopher_wig

/datum/gear/head/cap/ushanka
	display_name = "cap, ushanka"
	path = /obj/item/clothing/head/ushanka

/datum/gear/head/cap/ushanka/New()
    ..()
    var/ushanka = list(
        "Tan"	= /obj/item/clothing/head/ushanka,
        "Black" = /obj/item/clothing/head/ushanka/black
    )
    gear_tweaks += new /datum/gear_tweak/path(ushanka)

/datum/gear/head/cap/secfield
	display_name = "cap, Aegis field"
	path = /obj/item/clothing/head/soft/sec2soft
	allowed_roles = list("Aegis Operative","Aegis Commander","Aegis Gunnery Sergeant", "Inspector")

/datum/gear/head/cap/sarge
	display_name = "cap, Aegis sergeant"
	path = /obj/item/clothing/head/soft/sarge2soft
	allowed_roles = list("Aegis Commander","Aegis Gunnery Sergeant")

/datum/gear/head/dermal
	display_name = "dermal armour patch"
	path = /obj/item/clothing/head/armor/helmet/dermal
	allowed_roles = list("Aegis Commander","Aegis Gunnery Sergeant")
	cost = 2

/datum/gear/head/cyberpunkgoggle
	display_name = "Type-34C Semi-Enclosed Headwear"
	path = /obj/item/clothing/head/armor/helmet/visor/cyberpunkgoggle
	cost = 2

/datum/gear/head/cap/military
    display_name = "military cap, color presets"
    path = /obj/item/clothing/head/soft/green2soft

/datum/gear/head/cap/military/New()
    ..()
    var/battledress_serb = list(
        "Green" = /obj/item/clothing/head/soft/green2soft,
        "Tan" = /obj/item/clothing/head/soft/tan2soft
    )
    gear_tweaks += new /datum/gear_tweak/path(battledress_serb)

/datum/gear/head/tanker_helmet/color_presets
	display_name = "tanker helmet, color presets"
	path = /obj/item/clothing/head/armor/helmet/tanker
	cost = 2

/datum/gear/head/tanker_helmet/color_presets/New()
	..()
	var/tanker_helmet = list(
		"Black"		=	/obj/item/clothing/head/armor/helmet/tanker,
		"Green"		=	/obj/item/clothing/head/armor/helmet/tanker/green,
		"Brown"		=	/obj/item/clothing/head/armor/helmet/tanker/brown,
		"Gray"		=	/obj/item/clothing/head/armor/helmet/tanker/gray,
	)
	gear_tweaks += new /datum/gear_tweak/path(tanker_helmet)



/datum/gear/head/cowboy
    display_name = "cowboy hat, color and size presets"
    path = /obj/item/clothing/head/cowboy

/datum/gear/head/cowboy/New()
    ..()
    var/cowboy = list(
		"Brown"			= /obj/item/clothing/head/cowboy,
		"Black"			= /obj/item/clothing/head/cowboy/black,
		"White"			= /obj/item/clothing/head/cowboy/white,
		"Wide, brown"	= /obj/item/clothing/head/cowboy/wide,
		"Wide, black"	= /obj/item/clothing/head/cowboy/wide/black,
		"Wide, white"	= /obj/item/clothing/head/cowboy/wide/white
	)
    gear_tweaks += new /datum/gear_tweak/path(cowboy)

/datum/gear/head/festive
	display_name = "festive paper hat"
	path = /obj/item/clothing/head/festive

/datum/gear/head/church/chaplain
	display_name = "chaplain hood"
	path = /obj/item/clothing/head/chaplain_hood
	allowed_roles = list(JOBS_CHURCH)

/datum/gear/head/church/nun
	display_name = "nun hood"
	path = /obj/item/clothing/head/nun_hood

/datum/gear/head/surgery/color_presets
	display_name = "surgery cap, color presets"
	path = /obj/item/clothing/head/surgery
	allowed_roles = list(JOBS_LAZARUS)

/datum/gear/head/surgery/color_presets/New()
	..()
	var/surgery = list(
		"Dark Green"	=	/obj/item/clothing/head/surgery/green,
		"Baby Blue"		=	/obj/item/clothing/head/surgery/blue,
		"Deep Purple"	=	/obj/item/clothing/head/surgery/purple,
	)
	gear_tweaks += new /datum/gear_tweak/path(surgery)

/datum/gear/head/nurse
	display_name = "nurse hat"
	path = /obj/item/clothing/head/nursehat
	allowed_roles = list(JOBS_LAZARUS)

/datum/gear/head/hastur
	display_name = "hastur hood"
	path = /obj/item/clothing/head/hasturhood

/datum/gear/head/plague
	display_name = "plague doctor hat"
	path = /obj/item/clothing/head/plaguedoctorhat


/datum/gear/head/beaverhat
	display_name = "beaver hat"
	path = /obj/item/clothing/head/beaverhat

/datum/gear/head/piratehat
	display_name = "pirate hat"
	path = /obj/item/clothing/head/hgpiratecap

/datum/gear/head/witch
	display_name = "witch hat"
	path = /obj/item/clothing/head/witchwig

/datum/gear/head/bearpelt
	display_name = "bear pelt hat"
	path = /obj/item/clothing/head/bearpelt
	cost = 2

/datum/gear/head/kitty
	display_name = "kitty ears"
	path = /obj/item/clothing/head/kitty

//Eclipse Edit Begins - Adding in new custom commissioned clothes.
/datum/gear/head/hijab
	display_name = "hijab"
	path = /obj/item/clothing/head/hijab

//Eclipse Edit Continues - world code port
/datum/gear/head/worldport/wizard
	display_name = "wizard hat selection"
	path = /obj/item/clothing/head/worldport/magic
	slot = slot_head
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/head/worldport/main
	display_name = "maid headdress"
	path = /obj/item/clothing/head/worldport/maid
	slot = slot_head

/datum/gear/head/worldport/circlet
	display_name = "wood circlet"
	path = /obj/item/clothing/head/worldport/circlet
	slot = slot_head

/datum/gear/head/worldport/headdress
	display_name = "black and gold headdress"
	path = /obj/item/clothing/head/worldport/headdress
	slot = slot_head

/datum/gear/head/worldport/crown
	display_name = "crown selection"
	path = /obj/item/clothing/head/worldport/crown
	slot = slot_head
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/head/worldport/flowercrown
	display_name = "flower crown selection"
	path = /obj/item/clothing/head/worldport/flowercrown
	slot = slot_head
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/head/worldport/hat
	display_name = "expanded hat selection"
	path = /obj/item/clothing/head/worldport/hat
	slot = slot_head
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/head/worldport/polychrome/maang
	display_name = "polychrome maang tikka"
	path = /obj/item/clothing/head/worldport/polychrome/maang
	slot = slot_head
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/worldport/polychrome/maid
	display_name = "polychrome maid headdress"
	path = /obj/item/clothing/head/worldport/maid
	slot = slot_head
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/worldport/religious/hijab
	display_name = "polychrome classic hijab"
	path = /obj/item/clothing/head/worldport/religious/hijab
	slot = slot_head
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/worldport/religious/kippa
	display_name = "polychrome kippa"
	path = /obj/item/clothing/head/worldport/religious/kippa
	slot = slot_head
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/worldport/religious/taqiyah
	display_name = "polychrome taqiyah"
	path = /obj/item/clothing/head/worldport/religious/taqiyah
	slot = slot_head
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/head/worldport/religious/turban
	display_name = "polychrome turban"
	path = /obj/item/clothing/head/worldport/religious/turban
	slot = slot_head
	flags = GEAR_HAS_COLOR_SELECTION

//Eclipse Edit Ends - Adding in new custom commissioned clothes.
