// This will mostly contain helper procs and stuff for dynamic event handling.

/proc/get_living_heads()
	var/list/heads = list()
	for(var/mob/living/carbon/human/player in mob_list)
		if(player.stat!=2 && player.mind && (player.mind.assigned_role in command_positions))
			heads += player.mind
	return heads

/proc/get_non_antag_crew()
  var/crew = list()
  for(var/mob/living/carbon/human/man in player_list) if(man.client && man.mind)
    if(man.mind.special_role_text) // If man's an antag
      continue
    else crew += man
  return crew
