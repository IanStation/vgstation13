#define DIFFICULTY_PER_CREW 10 // This is the difficulty that each non-Antag crew member will add to the calculated difficulty rating.
#define DIFFICULTY_PER_HEAD 20 // Heads count for two! So that events are more likely when heads are alive than dead.
#define DIFFICULTY_FOR_AI 50
#define DIFFICULTY_PER_BORG 15

var/global/datum/dynamic_coordinator/coordinator = null

/datum/dynamic_coordinator/coordinator
  var/list/running_events = list()
  var/list/possible_events = typesof(/datum/events) - /datum/events

/datum/dynamic_coordinator/coordinator/proc/calculate_difficulty()
  var/difficulty = 0
  var/crew_count = 0 // Crew should be considered anyone who isn't an antag or head.
  var/head_count = get_living_heads().len
  difficulty += head_count * DIFFICULTY_PER_HEAD


/datum/dynamic_coordinator/coordinator/setup()
  var/calculated_difficulty = calculate_difficulty()



/datum/dynamic_coordinator/coordinator
