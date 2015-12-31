/var/global/antags = list()

/datum/antag
  var/type = null
  var/difficulty_rating = 0
  var/datum/mind/player = null

/datum/antag/New(var/datum/mind/M)
  for(var/datum/antag/A in antags)
    if(A.player == M)
      admin_log("Tried to assign [M.name]|[M.key] as an antag, but he was already an antag.")
      return 0
  player = M
  antags += src
  return 1
