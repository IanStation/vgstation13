/var/global/antags = list()

/datum/antag
  var/type = null
  var/datum/mind/player = null
  var/disabled = 0 //Irreversably brainwashed out of being bad or something I don't know

/datum/antag/New(var/datum/mind/M)
  for(var/datum/antag/A in antags)
    if(A.player == M)
      admin_log("Tried to assign [M.name]|[M.key] as an antag, but he was already an antag.")
      return 0
  player = M
  antags += src
  return 1


//OVERRIDE ME AS NEEDED. This should work for antags such as traitors and xenos.
/datum/antag/proc/is_active()
  if(disabled) return 0
  if(player.current && istype(player.current, /mob/living)
    if(player.current.isUnconscious)
      return 0
  return 1
