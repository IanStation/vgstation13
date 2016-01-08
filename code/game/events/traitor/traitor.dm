#define DIFFICULTY_PER_TRAITOR 50

/datum/antag/traitor
  type = "traitor"

/datum/antag/traitor/New(var/datum/mind/M)
  . = ..()
  if(. != 1)
    return 0
  player.special_role = "traitor"
  to_chat(player, "The Syndicate have activated you, their sleeper agent! Time to complete those objectives.")

/datum/events/traitor
	var/list/datum/mind/traitors = list()
	var/list/datum/mind/implanter = list()
	var/list/datum/mind/implanted = list()
  restricted_jobs = list("Cyborg","Mobile MMI")//They are part of the AI if he is traitor so are they, they use to get double chances
	protected_jobs = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")//AI", Currently out of the list as malf does not work for shit

/datum/events/traitor/get_difficulty()
  . = 0
  for(datum/mind/traitor/T in traitors)
    if(T)
      if(T.current.ckey && istype(T.current, /mob/living && !T.current.isUnconscious ))
        var/obj/item/weapon/implant/loyalty/L = locate(T.current)
        . += DIFFICULTY_PER_TRAITOR
