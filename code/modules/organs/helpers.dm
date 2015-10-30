/mob/proc/getorgan()
	return

/mob/living/carbon/getorgan(organ)
	if(organsystem) //If the mob has an organ system, you should give the name of the organ, i.e. "brain"
		return organsystem.getorgan(organ)
	return (locate(organ) in internal_organs) //If the mob does not have an organ system, we fall back on the old system where you give the path, i.e. /obj/item/organ/brain

/mob/proc/add_organ()
	return

/mob/living/carbon/add_organ(organ)
	if(organsystem)
		return organsystem.add_organ(organ)	//Adds an organ HARDPOINT to the organsystem (used for suborgans)
	else return 0

mob/living/carbon/exists(var/organname)
	if(organsystem)
		var/datum/organ/O = getorgan(organname)
		return O.exists()
	else
		return 1

/mob/proc/getlimb()
	return

/mob/living/carbon/human/getlimb(typepath)
	return (locate(typepath) in organs)

mob/proc/exists(var/organname)
	return 1

//Delete this later maybe

/mob/proc/getorganszone(zone)
	return

/mob/proc/getorganslot(slot)
	return

/mob/living/carbon/getorganszone(zone, var/subzones = 0)
	var/list/returnorg = list()
	if(subzones)
		if(zone == "head")
			returnorg = getorganszone("eyes") + getorganszone("mouth")
			// We don't have mouth organs now, but who knows?
		if(zone == "chest")
			returnorg = getorganszone("groin")

	for(var/obj/item/organ/internal/O in internal_organs)
		if(zone == O.zone)
			returnorg += O
	return returnorg

/mob/living/carbon/getorganslot(slot)
	for(var/obj/item/organ/internal/O in internal_organs)
		if(slot == O.slot)
			return O

proc/isorgan(atom/A)
	return istype(A, /obj/item/organ/internal)