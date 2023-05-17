/obj/structure/closet/mopcloset
	name = "\improper Janitorial closet"
	desc = "A storage unit for explosion-protective space suits."
	icon = 'zzz_modular_eclipse/icons/obj/closet.dmi'
	icon_state = "mop"
	rarity_value = 5
	spawn_tags = SPAWN_TAG_CLOSET


/obj/structure/closet/mopcloset/populate_contents()
	new /obj/structure/mopbucket(src)
	new /obj/item/mop(src)
	new /obj/item/storage/bag/trash(src)
	new /obj/item/soap/nanotrasen(src)
	new /obj/item/device/lightreplacer(src)
	new /obj/item/caution(src)
