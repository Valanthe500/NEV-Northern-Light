#define CRUCIFORM_TYPE obj/item/implant/core_implant/cruciform

//Create a list of what can be created via construction ritual
GLOBAL_LIST_INIT(nt_blueprints, init_nt_blueprints())

/proc/init_nt_blueprints()
	var/list/list = list()
	for(var/blueprint_type in typesof(/datum/nt_blueprint))
		if(blueprint_type == /datum/nt_blueprint)
			continue
		if(blueprint_type == /datum/nt_blueprint/machinery)
			continue
		var/datum/nt_blueprint/pb = new blueprint_type()
		list[pb.name] = pb
	. = list

//Create a list of what the blueprints actually make, and the materials required to make them. Blueprints list generation turns them into text format, not datums.
GLOBAL_LIST_INIT(nt_constructs, init_nt_constructs())

/proc/init_nt_constructs()
	var/list/nt_constructs = list()
	for(var/name in GLOB.nt_blueprints)
		var/datum/nt_blueprint/accessed = GLOB.nt_blueprints[name]
		nt_constructs[accessed.build_path] = accessed.materials
	. = nt_constructs

/datum/ritual/cruciform/priest/acolyte/blueprint_check
	name = "Divine Guidance"
	phrase = "Dirige me in veritate tua, et doce me, quia tu es Deus salvator meus, et te sustinui tota die."
	desc = "Building needs mainly faith but resources as well. Find out what it takes."
	power = 5

/datum/ritual/cruciform/priest/acolyte/blueprint_check/perform(mob/living/carbon/human/user, obj/item/implant/core_implant/C, list/targets)
	var/construction_key = input("Select construction", "") as null|anything in GLOB.nt_blueprints
	var/datum/nt_blueprint/blueprint = GLOB.nt_blueprints[construction_key]
	var/list/listed_components = list()
	for(var/requirement in blueprint.materials)
		var/atom/placeholder = requirement
		if(!ispath(placeholder))
			continue
		listed_components += list("[blueprint.materials[placeholder]] [initial(placeholder.name)]")
	to_chat(user, SPAN_NOTICE("[blueprint.name] requires: [english_list(listed_components)]."))

/datum/ritual/cruciform/priest/acolyte/construction
	name = "Manifestation"
	phrase = "Omnia autem quae arguuntur a lumine manifestantur omne enim quod manifestatur lumen est."
	desc = "Build and expand. Shape your faith into something more sensible."
	power = 40

/datum/ritual/cruciform/priest/acolyte/construction/perform(mob/living/carbon/human/user, obj/item/implant/core_implant/C, list/targets)
	var/construction_key = input("Select construction", "") as null|anything in GLOB.nt_blueprints
	var/datum/nt_blueprint/blueprint = GLOB.nt_blueprints[construction_key]
	var/turf/target_turf = get_step(user,user.dir)
	if(!blueprint)
		fail("You decided not to test your faith.",user,C,targets)
		return
	if(!items_check(user, target_turf, blueprint))
		fail("Something is missing.",user,C,targets)
		return
	if(istype(blueprint,/datum/nt_blueprint/machinery/eotp) && eotp != null)
		fail("You cannot build a second Eye of the Protector in this area. The Last Shelter forbids it.")
		return

	user.visible_message(SPAN_NOTICE("You see as [user] passes their hands over something."),SPAN_NOTICE("You see your faith take physical form as you concentrate on [blueprint.name] image"))

	var/obj/effect/overlay/nt_construction/effect = new(target_turf, blueprint.build_time)

	if(!do_after(user, blueprint.build_time, target_turf))
		fail("You feel something is judging you upon your impatience",user,C,targets)
		effect.failure()
		return
	if(!items_check(user, target_turf, blueprint))
		fail("Something got stolen!",user,C,targets)
		effect.failure()
		return
	//magic has to be a bit innacurate

	for(var/item_type in blueprint.materials)
		var/t = locate(item_type) in target_turf.contents
		if(istype(t, /obj/item/stack))
			var/obj/item/stack/S = t
			S.use(blueprint.materials[item_type])
		else
			qdel(t)

	effect.success()
	user.visible_message(SPAN_NOTICE("You hear a soft humming sound as [user] finishes his ritual."),SPAN_NOTICE("You take a deep breath as the divine manifestation finishes."))
	var/build_path = blueprint.build_path
	new build_path(target_turf)

/datum/ritual/cruciform/priest/acolyte/deconstruction
	name = "Uproot"
	phrase = "Dominus dedit, Dominus abstulit."
	desc = "Mistakes are to be a lesson, but first we must correct it by deconstructing its form."
	power = 40

/datum/ritual/cruciform/priest/acolyte/deconstruction/perform(mob/living/carbon/human/user, obj/item/implant/core_implant/C, list/targets)
	if(!GLOB.nt_constructs) //Makes sure the list we curated earlier actually exists
		fail("You have no idea what constitutes a church construct.",user,C,targets)
		return

	var/obj/reclaimed //Variable to be defined later as the removed construct
	var/loot //Variable to be defined later as materials resulting from deconstruction
	var/turf/target_turf = get_step(user,user.dir) //Gets the turf in front of the user

	//Find the NT Structure in front of the player
	for(reclaimed in target_turf)
		if(reclaimed.type in GLOB.nt_constructs)
			loot = GLOB.nt_constructs[reclaimed.type]
			break

	if(isnull(loot))
		fail("There is no mistake to remove here.",user,C,targets)
		return
	if(reclaimed.type == /obj/machinery/power/eotp && !(is_preacher(user) || is_inquisidor(user)))
		fail("The power of moving such holy buildings is only placed in the power of the upmost faithful!")
		return
	user.visible_message(SPAN_NOTICE("[user] places one hand on their chest, and the other stretched forward."),SPAN_NOTICE("You take back what is, returning it to what was."))

	var/obj/effect/overlay/nt_construction/effect = new(target_turf, 5 SECONDS)

	if(!do_after(user, 5 SECONDS, target_turf)) //"Sit still" timer
		fail("You feel something is judging you upon your impatience",user,C,targets)
		effect.failure()
		return

	if(QDELETED(reclaimed) || reclaimed.loc != target_turf)
		fail("It's no longer there.", user, C, targets)
		effect.failure()
		return

	//Lets spawn and drop the materials resulting from deconstruction
	for(var/obj/scrap as anything in loot)
		if(ispath(scrap, /obj/item/stack))
			var/obj/item/stack/mat = new scrap(target_turf)
			mat.amount = loot[scrap]
		else
			scrap = new scrap(target_turf)

	effect.success()
	user.visible_message(SPAN_NOTICE("Clanking of parts hit the floor as [user] finishes their prayer and the machine falls apart."),SPAN_NOTICE("Collect the evidence, and begin to atone."))

	qdel(reclaimed)

/datum/ritual/cruciform/priest/acolyte/construction/proc/items_check(mob/user,turf/target, datum/nt_blueprint/blueprint)
	var/list/turf_contents = target.contents

	for(var/item_type in blueprint.materials)
		var/located_raw = locate(item_type) in turf_contents
		//single item check is handled there, rest of func is for stacked items or items with containers
		if(!located_raw)
			return FALSE

		var/required_amount = blueprint.materials[item_type]
        // I hope it is fast enough
        // could have initialized it in glob
		if(item_type in typesof(/obj/item/stack/))
			var/obj/item/stack/stacked = located_raw
			if(stacked.amount < required_amount)
				return FALSE
	return TRUE
/datum/nt_blueprint/
	var/name = "Report me"
	var/build_path
	var/list/materials
	var/build_time = 3 SECONDS

/datum/nt_blueprint/canister
	name = "Biomatter Canister"
	build_path = /obj/structure/reagent_dispensers/biomatter
	materials = list(
		/obj/item/stack/material/steel = 8,
		/obj/item/stack/material/plastic = 2
	)
/datum/nt_blueprint/canister/large
	name = "Large Biomatter Canister"
	build_path = /obj/structure/reagent_dispensers/biomatter/large
	materials = list(
		/obj/item/stack/material/steel = 16,
		/obj/item/stack/material/plastic = 4,
		/obj/item/stack/material/plasteel = 2,
	)
	build_time = 5 SECONDS

/datum/nt_blueprint/machinery

/datum/nt_blueprint/machinery/obelisk
	name = "Obelisk"
	build_path = /obj/machinery/power/nt_obelisk
	materials = list(
		/obj/item/stack/material/plasteel = 10,
		/obj/item/stack/material/gold = 5,
		/CRUCIFORM_TYPE = 1
	)
	build_time = 8 SECONDS

/datum/nt_blueprint/machinery/eotp
	name = "Eye of the Protector"
	build_path = /obj/machinery/power/eotp
	materials = list(
		/obj/item/device/last_shelter = 1,
		/obj/item/stack/material/gold = 15,
		/obj/item/stack/material/plasteel = 50,
		/obj/item/stack/material/biomatter = 100,
		/CRUCIFORM_TYPE = 1

	)
/datum/nt_blueprint/machinery/bioprinter
	name = "Biomatter Printer"
	build_path = /obj/machinery/autolathe/bioprinter
	materials = list(
		/obj/item/stack/material/steel = 10,
		/obj/item/stack/material/glass = 2,
		/obj/item/stack/material/silver = 6,
		/obj/item/storage/toolbox/mechanical = 1
	)
	build_time = 5 SECONDS
/datum/nt_blueprint/machinery/solidifier
	name = "Biomatter Solidifier"
	build_path = /obj/machinery/biomatter_solidifier
	materials = list(
		/obj/item/stack/material/steel = 20,
		/obj/item/stack/material/silver = 5,
		/obj/structure/reagent_dispensers/biomatter = 1
	)
	build_time = 9 SECONDS
// Eclipse Change: removing the cloner from the ritual list, in Eclipse it's a Lazarus toy.
/*
//cloner
/datum/nt_blueprint/machinery/cloner
	name = "Cloner Pod"
	build_path = /obj/machinery/neotheology/cloner
	materials = list(
		/obj/item/stack/material/glass = 15,
		/obj/item/stack/material/plasteel = 10,
		/obj/item/stack/material/gold = 5,
		/obj/item/stack/material/glass/reinforced = 10,
	)
	build_time = 10 SECONDS
/datum/nt_blueprint/machinery/reader
	name = "Cruciform Reader"
	build_path = /obj/machinery/neotheology/reader
	materials = list(
		/obj/item/stack/material/steel = 10,
		/obj/item/stack/material/plasteel = 5,
		/obj/item/stack/material/silver = 10,
		/CRUCIFORM_TYPE = 1
	)
	build_time = 10 SECONDS
*/

/datum/nt_blueprint/machinery/biocan
	name = "Biomass tank"
	build_path = /obj/machinery/neotheology/biomass_container
	materials = list(
		/obj/item/stack/material/gold = 5,
		/obj/item/stack/material/plasteel = 5,
		/obj/structure/reagent_dispensers/biomatter/large = 1
	)
	build_time = 8 SECONDS
//generator
/datum/nt_blueprint/machinery/biogen
	name = "Biomatter Power Generator"
	build_path = /obj/machinery/multistructure/biogenerator_part/generator
	materials = list(
		/obj/item/stack/material/plasteel = 5,
		/obj/item/stack/material/gold = 5,
		/obj/item/stack/material/steel = 20,
		/obj/item/stack/material/biomatter = 5,
		/obj/structure/reagent_dispensers/biomatter = 1
	)
	build_time = 15 SECONDS
/datum/nt_blueprint/machinery/biogen_console
	name = "Biomatter Power Generator: Console"
	build_path = /obj/machinery/multistructure/biogenerator_part/console
	materials = list(
		/obj/item/stack/material/glass = 5,
		/obj/item/stack/material/plastic = 15,
		/obj/item/stack/cable_coil = 30 //! TODO: proper recipe
	)
	build_time = 6 SECONDS
/datum/nt_blueprint/machinery/biogen_port
	name = "Biomatter Power Generator: Port"
	build_path = /obj/machinery/multistructure/biogenerator_part/port
	materials = list(
		/obj/item/stack/material/steel = 10,
		/obj/item/reagent_containers/glass/bucket = 1
	)
	build_time = 5 SECONDS
//bioreactor
/datum/nt_blueprint/machinery/bioreactor_loader
	name = "Biomatter Reactor: Loader"
	build_path = /obj/machinery/multistructure/bioreactor_part/loader
	materials = list(
		/obj/item/stack/material/steel = 10,
		/obj/item/stack/material/silver = 3,
		/obj/item/stack/material/glass = 2,
		/obj/structure/reagent_dispensers/biomatter = 1
	)
	build_time = 8 SECONDS

/datum/nt_blueprint/machinery/bioreactor_unloader
	name = "Biomatter Reactor: Unloader" //Basically a hopper
	build_path = /obj/machinery/multistructure/bioreactor_part/unloader
	materials = list(
		/obj/item/stack/material/steel = 10
	)
	build_time = 2 SECONDS

/datum/nt_blueprint/machinery/bioreactor_metrics
	name = "Biomatter Reactor: Metrics"
	build_path = /obj/machinery/multistructure/bioreactor_part/console
	materials = list(
		/obj/item/stack/material/steel = 2,
		/obj/item/stack/material/silver = 5,
		/obj/item/stack/material/glass = 4,
		/obj/item/stack/cable_coil = 30 //! TODO: proper recipe
	)
	build_time = 7 SECONDS

/datum/nt_blueprint/machinery/bioreactor_port
	name = "Biomatter Reactor: Port"
	build_path = /obj/machinery/multistructure/bioreactor_part/bioport
	materials = list(
		/obj/item/stack/material/silver = 5,
		/obj/item/reagent_containers/glass/bucket = 1
	)
	build_time = 6 SECONDS


/datum/nt_blueprint/machinery/platform
	name = "Biomatter Reactor: Bioreactor Platform"
	build_path = /obj/machinery/multistructure/bioreactor_part/platform
	materials = list(
		/obj/item/stack/material/steel = 10,
		/obj/item/stack/rods = 2
	)
	build_time = 8 SECONDS

/datum/nt_blueprint/machinery/bioreactor_platform
	name = "Biomatter Reactor: Biomatter Canister Platform"
	build_path = /obj/machinery/multistructure/bioreactor_part/biotank_platform
	materials = list(
		/obj/item/stack/material/steel = 10,
		/obj/item/stack/material/plastic = 4,
		/obj/item/stack/tile/floor = 1
	)
	build_time = 8 SECONDS

/datum/nt_blueprint/machinery/door_silver
	name = "Common Door"
	build_path = /obj/machinery/door/holy
	materials = list(
		/obj/item/stack/material/steel = 5,
		/obj/item/stack/material/biomatter = 20,
		/obj/item/stack/material/silver = 2,
		/obj/item/stack/material/gold = 1
	)
	build_time = 8 SECONDS

/datum/nt_blueprint/machinery/door_gold
	name = "Clergy Door"
	build_path = /obj/machinery/door/holy/preacher
	materials = list(
		/obj/item/stack/material/steel = 5,
		/obj/item/stack/material/biomatter = 20,
		/obj/item/stack/material/gold = 3
	)
	build_time = 8 SECONDS

/datum/nt_blueprint/machinery/door_public
	name = "Public Door"
	build_path = /obj/machinery/door/holy/public
	materials = list(
		/obj/item/stack/material/steel = 5,
		/obj/item/stack/material/biomatter = 20,
		/obj/item/stack/material/silver = 3
	)
	build_time = 8 SECONDS

/datum/nt_blueprint/machinery/altar
	name = "Altar"
	build_path = /obj/machinery/optable/altar
	materials = list(
		/obj/item/stack/material/steel = 10,
		/obj/item/stack/material/biomatter = 50,
		/obj/item/stack/material/silver = 5,
		/CRUCIFORM_TYPE = 1
	)
	build_time = 10 SECONDS
