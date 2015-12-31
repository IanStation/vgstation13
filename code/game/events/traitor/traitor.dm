/datum/antag/traitor
  type = "traitor"
  difficulty_rating = 50

/datum/antag/traitor/New(var/datum/mind/M)
  . = ..()
  if(. != 1)
    return 0
  player.special_role = "traitor"
  to_chat(player, "The Syndicate have activated you, their sleeper agent! Time to complete those objectives.")

/datum/events/traitor
	// this includes admin-appointed traitors and multitraitors. Easy!
	var/list/datum/mind/traitors = list()
	var/list/datum/mind/implanter = list()
	var/list/datum/mind/implanted = list()

/datum/dynamic_mode/traitor
	name = "traitor"
	config_tag = "traitor"
	restricted_jobs = list("Cyborg","Mobile MMI")//They are part of the AI if he is traitor so are they, they use to get double chances
	protected_jobs = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")//AI", Currently out of the list as malf does not work for shit
