/datum/find/generator
	source_materials = list("cordite","quadrinium","steel","titanium","aluminium","ferritic-alloy","plasteel","duranium")
	material_descriptors = list("rusted ","dusty ","archaic ","fragile ")
	possible_descriptors = list()
/datum/find/generator/proc/pick()
	var find_type = pick(
		5;/datum/find/type/bowl,
		5;/datum/find/type/utensil,
		5;/datum/find/type/statuette,
		5;/datum/find/type/instrument,
		5;/datum/find/type/blade,
		)



// Muh easily extendable code, so you can easily add whatever stupid eldritch utensils you want as variants (sporks, for instance)
/datum/find/variants
	var/name
	var/item_type

/datum/find/variants/utensils
	items = list(/datum/find/variants/utensils/fork, /datum/find/variants/utensils/knife, /datum/find/variants/utensils/spoon)
/datum/find/variants/utensils/fork
	name = "fork"
	item_type = /obj/item/weapon/kitchen/utensil/fork
/datum/find/variants/utensils/knife
	name = "knife"
	item_type = /obj/item/weapon/kitchen/utensil/knife
/datum/find/variants/utensils/spoon
	name = "spoon"
	item_type = /obj/item/weapon/kitchen/utensil/spoon

/datum/find/variants/blade
	items = list(/datum/find/variants/blade/bladed-knife, /datum/find/variants/blade/serrated-blade, /datum/find/variants/blade/sharp-cutting-instrument)

/datum/find/variants/blade/bladed-knife
	name = "bladed knife"

/datum/find/variants/blade/serrated-blade
	name = "serrated blade"

/datum/find/variants/blade/sharp-cutting-instrument
	name = "sharp cutting implement"


/datum/find/type
	var/item_icon = 'icons/obj/xenoarcheology.dmi'
	var/item_icon_state = "unknown[rand(1,4)]"
	var/obj/item/weapon/new_item
	var/apply_image_decorations
	var/additional_desc = ""
	var/source_material = ""
	var/material_descriptor = ""
	var/apply_material_decorations = 1
	var/apply_image_decorations = 0
	var/apply_prefix = 1
	var/talkative = 0

/datum/find/type/proc/AddAdditionalDesc()
	//TODO
/datum/find/type/proc/GenerateFind()
	if(prob(40))
		material_descriptor = pick(material_descriptors)
	decoration_material = pick(source_materials)
	if(prob(5))
		talkative = 1





/datum/find/type/bowl
	name = "bowl"
	new_item = /obj/item/weapon/reagent_containers/glass
	item_icon_state = "bowl"
	apply_image_decorations = 1

/datum/find/type/bowl/New()
	if(prob(20))
		additional_desc = "There appear to be [pick("dark","faintly glowing","pungent","bright")] [pick("red","purple","green","blue")] stains inside."
	..()

/datum/find/type/urn
	name = "urn"
	new_item = /obj/item/weapon/reagent_containers/glass
	item_icon_state = "urn"
	apply_image_decorations = 1

/datum/find/type/urn/New()
	if(prob(20))
		additional_desc = "It [pick("whispers faintly","makes a quiet roaring sound","whistles softly","thrums quietly","throbs")] if you put it to your ear."
	..()

/datum/find/type/utensil
	var/variant

/datum/find/type/utensil/New()
	variant = pick(/datum/find/variants/utensils/items)
	new_item = variant.item_type
	name = variant.name
	..()


/datum/find/type/statuette
	item_icon_state = "statuette"

/datum/find/type/statuette/New()
	additional_desc = "It depicts a [pick("small","ferocious","wild","pleasing","hulking")] \
	[pick("alien figure","rodent-like creature","reptilian alien","primate","unidentifiable object")] \
	[pick("performing unspeakable acts","posing heroically","in a fetal position","cheering","sobbing","making a plaintive gesture","making a rude gesture")]."
	..()

/datum/find/type/instrument
	item_icon_state = "instrument"

/datum/find/type/instrument/New()
	if(prob(30))
		apply_image_decorations = 1
		additional_desc = "[pick("You're not sure how anyone could have played this",\
		"You wonder how many mouths the creator had",\
		"You wonder what it sounds like",\
		"You wonder what kind of music was made with it")]."
	..()
/datum/find/type/blade
	new_item = /obj/item/weapon/kitchen/utensil/knife/large
	
/datum/find/type/blade/New()
	additional_desc = "[pick("It doesn't look safe.",\
	"It looks wickedly jagged",\
	"There appear to be [pick("dark red","dark purple","dark green","dark blue")] stains along the edges")]."

/datum/find/type/coin
	var/coin_types = typesof(/obj/item/weapon/coin)
	var/chance = 10

/datum/find/type/coin/New()
