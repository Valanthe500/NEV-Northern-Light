#define OBELISK_UPDATE_TIME 5 SECONDS

var/list/disciples = list()

/obj/item/implant/core_implant/cruciform
	name = "Mekhanite Cruciform"
	icon_state = "cruciform_green"
	desc =  "Soul holder for every disciple. With the proper rituals, this can be implanted to induct a believer into the very heart of Mekhane."
//	description_info = "The cruciform ensures genetic purity, it will purge any cybernetic attachments, or mutation that are not part of the standard human genome"
	matter = list(MATERIAL_BIOMATTER = 10, MATERIAL_PLASTEEL = 5, MATERIAL_GOLD = 2)
	allowed_organs = list(BP_CHEST)
	implant_type = /obj/item/implant/core_implant/cruciform
	layer = ABOVE_MOB_LAYER
	access = list(access_nt_disciple)
	power = 50
	max_power = 50
	power_regen = 20/(1 MINUTES)
	price_tag = 500
	unacidable = 1
	var/obj/item/cruciform_upgrade/upgrade

	var/righteous_life = 0
	var/max_righteous_life = 100

/obj/item/implant/core_implant/cruciform/auto_restore_power()
	if(power >= max_power)
		return

	var/true_power_regen = power_regen
	true_power_regen += max(round(wearer.stats.getStat(STAT_COG) / 4), 0) * power_regen * 0.05
	true_power_regen += power_regen * 1.5 * righteous_life / max_righteous_life
	if(wearer && wearer.stats?.getPerk(/datum/perk/channeling))
		true_power_regen += power_regen * disciples.len / 5 // Proportional to the number of cruciformed people on board

	restore_power(true_power_regen)

/obj/item/implant/core_implant/cruciform/proc/register_wearer()
	RegisterSignal(wearer, COMSIG_CARBON_HAPPY, PROC_REF(on_happy), TRUE)
	RegisterSignal(wearer, COMSIG_GROUP_RITUAL, PROC_REF(on_ritual), TRUE)

/obj/item/implant/core_implant/cruciform/proc/unregister_wearer()
	UnregisterSignal(wearer, COMSIG_CARBON_HAPPY)
	UnregisterSignal(wearer, COMSIG_GROUP_RITUAL)

/obj/item/implant/core_implant/cruciform/proc/on_happy(datum/reagent/happy, signal)
	SIGNAL_HANDLER
	if(istype(happy, /datum/reagent/ethanol) && happy.id != "ntcahors")
		righteous_life = max(righteous_life - 0.1, 0)
	else if(istype(happy, /datum/reagent/drug))
		righteous_life = max(righteous_life - 0.5, 0)

/obj/item/implant/core_implant/cruciform/proc/on_ritual()
	SIGNAL_HANDLER
	righteous_life = min(righteous_life + 25, max_righteous_life)


/obj/item/implant/core_implant/cruciform/install(mob/living/target, organ, mob/user)
	. = ..()
	if(.)
		target.stats.addPerk(/datum/perk/sanityboost)
		register_wearer()

/obj/item/implant/core_implant/cruciform/uninstall()
	unregister_wearer()
	wearer.stats.removePerk(/datum/perk/sanityboost)
	wearer.stats.removePerk(/datum/perk/active_sanityboost)
	return ..()

/obj/item/implant/core_implant/cruciform/get_mob_overlay(gender)
	gender = (gender == MALE) ? "m" : "f"
	return image('icons/mob/human_races/cyberlimbs/neotheology.dmi', "[icon_state]_[gender]")

/obj/item/implant/core_implant/cruciform/hard_eject()
	if(!ishuman(wearer))
		return
	var/mob/living/carbon/human/H = wearer
	if(H.stat == DEAD)
		return
	H.adjustBrainLoss(55+rand(5))
	H.adjustOxyLoss(100+rand(50))
	if(part)
		H.apply_damage(100+rand(75), BURN, part, used_weapon = src)
	H.apply_effect(40+rand(20), IRRADIATE, check_protection = 0)
	var/datum/effect/effect/system/spark_spread/s = new
	s.set_up(3, 1, src)
	s.start()

/obj/item/implant/core_implant/cruciform/activate()
	var/observation_points = 200
	if(!wearer || active)
		return
	/* //eclipse edit
	if(get_active_mutation(wearer, MUTATION_GODBLOOD))
		spawn(2 MINUTES)
		for(var/mob/living/carbon/human/H in (disciples - wearer))
			to_chat(H, SPAN_WARNING("A distant scream pierced your mind. You feel that a vile mutant sneaked among the faithful."))
			playsound(wearer.loc, 'sound/hallucinations/veryfar_noise.ogg', 55, 1)
	*/
	else if(is_carrion(wearer))
		if(wearer.get_species() == SPECIES_MONKEY)
			observation_points /= 20
		playsound(wearer.loc, 'sound/hallucinations/wail.ogg', 55, 1)
		wearer.gib()
		if(eotp)  // le mutants reward
			eotp.addObservation(observation_points)
		return
	..()
	add_module(new CRUCIFORM_COMMON)
	update_data()
	disciples |= wearer
	var/datum/core_module/cruciform/cloning/M = get_module(CRUCIFORM_CLONING)
	if(M)
		M.write_wearer(wearer) //writes all needed data to cloning module
	if(ishuman(wearer)) //Eclipse add
		var/mob/living/carbon/human/H = wearer
		H.genetic_corruption = 0
	if(eotp)
		eotp.addObservation(observation_points*0.25)
	return TRUE

/obj/item/implant/core_implant/cruciform/examine(mob/user)
	..()
	var/datum/core_module/cruciform/cloning/data = get_module(CRUCIFORM_CLONING)
	if(data?.mind) // if there is cloning data and it has a mind
		to_chat(user, SPAN_NOTICE("This cruciform has been activated."))
		if(isghost(user) || (user in disciples))
			var/datum/mind/MN = data.mind
			if(MN.name) // if there is a mind and it also has a name
				to_chat(user, SPAN_NOTICE("It contains <b>[MN.name]</b>'s soul."))
			else
				to_chat(user, SPAN_DANGER("Something terrible has happened with this soul. Please notify somebody in charge."))
	else // no cloning data
		to_chat(user, "This cruciform has not yet been activated.")



/obj/item/implant/core_implant/cruciform/deactivate()
	if(!active || !wearer)
		return
	disciples.Remove(wearer)
	if(eotp)
		eotp.removeObservation(50)
	..()

/obj/item/implant/core_implant/cruciform/Process()
	..()
//	if(active && round(world.time) % 5 == 0)
//		remove_cyber()   -- Eclipse Edit
/* -- Eclipse Edit church is cool with mutants here
	if(wearer.mutation_index)
		var/datum/mutation/M = pick(wearer.active_mutations)
		M.cleanse(wearer)
		wearer.adjustFireLoss(rand(5,25))
*/
	if(wearer.stat == DEAD)
		deactivate()
	else if(ishuman(wearer)) //Eclipse add
		var/mob/living/carbon/human/H = wearer
		if(H.genetic_corruption > 49) //SEVEN BY SEVEN
			H.genetic_corruption -= 1

/obj/item/implant/core_implant/cruciform/proc/transfer_soul()
	if(!wearer || !activated)
		return FALSE
	var/datum/core_module/cruciform/cloning/data = get_module(CRUCIFORM_CLONING)
	//if(wearer.dna.unique_enzymes == data.dna.unique_enzymes) Mekhanites are ultratranshumanists - Eclipse edit
/*	for(var/mob/M in GLOB.player_list)
		if(M.ckey == data.ckey)
			if(M.stat != DEAD)
				return FALSE  */
	var/datum/mind/MN = data.mind
	if(!istype(MN))
		return
	MN.transfer_to(wearer)
	wearer.ckey = data.ckey
	for(var/datum/language/L in data.languages)
		wearer.add_language(L.name)
	update_data()
	if(activate())
		return TRUE

/* /obj/item/implant/core_implant/cruciform/proc/remove_cyber() Begin Eclipse Edit: our cruciforms don't reject augmentations
	if(!wearer)
		return
	for(var/obj/O in wearer)
		if(istype(O, /obj/item/organ/external))
			var/obj/item/organ/external/R = O
			if(!BP_IS_ROBOTIC(R))
				continue

			if(R.owner != wearer)
				continue
			wearer.visible_message(SPAN_DANGER("[wearer]'s [R.name] tears off."),
			SPAN_DANGER("Your [R.name] tears off."))
			R.droplimb()
		if(istype(O, /obj/item/implant))
			if(O == src)
				continue
			var/obj/item/implant/R = O
			if(R.wearer != wearer)
				continue
			if(R.cruciform_resist)
				continue
			wearer.visible_message(SPAN_DANGER("[R.name] rips through [wearer]'s [R.part]."),\
			SPAN_DANGER("[R.name] rips through your [R.part]."))
			R.part.take_damage(rand(20,40))
			R.uninstall()
			R.malfunction = MALFUNCTION_PERMANENT
		if(istype(O, /obj/item/organ/internal))
			var/obj/item/organ/internal/I = O
			if(!I.item_upgrades.len)
				continue
			if(I.owner != wearer)
				continue
			for(var/mod in I.item_upgrades)
				var/atom/movable/AM = mod
				SEND_SIGNAL_OLD(AM, COMSIG_REMOVE, I)
				I.take_damage(rand(6,12), BRUTE)
				if(I.parent)
					I.parent.take_damage(rand(2,5))
				wearer.visible_message(SPAN_NOTICE("<b>\The [AM]</b> rips through \the [wearer]'s flesh."), SPAN_NOTICE("<b>\The [AM]</b> rips through your flesh. Your [I.name] hurts."))
	if(ishuman(wearer))
		var/mob/living/carbon/human/H = wearer
		H.update_implants() End of Eclipse Edit */

/obj/item/implant/core_implant/cruciform/proc/update_data()
	if(!wearer)
		return

	add_module(new CRUCIFORM_CLONING)


//////////////////////////
//////////////////////////

/obj/item/implant/core_implant/cruciform/proc/make_common()
	remove_modules(CRUCIFORM_PRIEST)
	remove_modules(CRUCIFORM_INQUISITOR)
	remove_modules(CRUCIFORM_REDLIGHT)

/obj/item/implant/core_implant/cruciform/proc/make_priest()
	add_module(new CRUCIFORM_PRIEST)
	add_module(new CRUCIFORM_REDLIGHT)
	security_clearance = CLEARANCE_CLERGY

/obj/item/implant/core_implant/cruciform/proc/make_inquisitor()
	add_module(new CRUCIFORM_PRIEST)
	add_module(new CRUCIFORM_INQUISITOR)
	add_module(new /datum/core_module/cruciform/uplink())
	remove_modules(CRUCIFORM_REDLIGHT)
	security_clearance = CLEARANCE_CLERGY

/obj/item/implant/core_implant/cruciform/proc/make_acolyte()
	remove_modules(CRUCIFORM_AGROLYTE)
	remove_modules(CRUCIFORM_CUSTODIAN)
	add_module(new CRUCIFORM_ACOLYTE)

/obj/item/implant/core_implant/cruciform/proc/make_custodian()
	remove_modules(CRUCIFORM_AGROLYTE)
	remove_modules(CRUCIFORM_ACOLYTE)
	add_module(new CRUCIFORM_CUSTODIAN)

/obj/item/implant/core_implant/cruciform/proc/make_agrolyte()
	remove_modules(CRUCIFORM_ACOLYTE)
	remove_modules(CRUCIFORM_CUSTODIAN)
	add_module(new CRUCIFORM_AGROLYTE)

/obj/item/implant/core_implant/cruciform/proc/remove_specialization()
	remove_modules(CRUCIFORM_ACOLYTE)
	remove_modules(CRUCIFORM_AGROLYTE)
	remove_modules(CRUCIFORM_CUSTODIAN)
	update_rituals()
