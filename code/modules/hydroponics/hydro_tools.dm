//Analyzer, pestkillers, weedkillers, nutrients, hatchets, cutters.

/obj/item/weapon/wirecutters/clippers
	name = "plant clippers"
	desc = "A tool used to take samples from plants."
	inhand_states = list("left_hand" = 'icons/mob/in-hand/left/misc_tools.dmi', "right_hand" = 'icons/mob/in-hand/right/misc_tools.dmi')
	icon_state = "plantclippers"
	item_state = "plantclippers"

/obj/item/weapon/wirecutters/clippers/New()
	..()
	icon_state = "plantclippers"
	item_state = "plantclippers"

/obj/item/device/analyzer/plant_analyzer
	name = "plant analyzer"
	icon = 'icons/obj/device.dmi'
	icon_state = "hydro"
	item_state = "analyzer"
	var/form_title //Descriptive title of the last plant scanned, example: mutant watermelon (#81)
	var/last_data  //Stores the entire last scan, for printing purposes.
	var/tmp/last_print = 0 //When was the last printing, works as a cooldown to prevent paperspam

/obj/item/device/analyzer/plant_analyzer/afterattack(obj/target, mob/user, flag)
	if(!flag) return

	var/datum/seed/grown_seed
	var/datum/reagents/grown_reagents
	if(istype(target,/obj/structure/rack) || istype(target,/obj/structure/table))
		return ..()
	else if(istype(target,/obj/item/weapon/reagent_containers/food/snacks/grown))

		var/obj/item/weapon/reagent_containers/food/snacks/grown/G = target
		grown_seed = plant_controller.seeds[G.plantname]
		grown_reagents = G.reagents

	else if(istype(target,/obj/item/weapon/grown))

		var/obj/item/weapon/grown/G = target
		grown_seed = plant_controller.seeds[G.plantname]
		grown_reagents = G.reagents

	else if(istype(target,/obj/item/seeds))

		var/obj/item/seeds/S = target
		grown_seed = S.seed

	else if(istype(target,/obj/machinery/portable_atmospherics/hydroponics))

		var/obj/machinery/portable_atmospherics/hydroponics/H = target
		grown_seed = H.seed
		grown_reagents = H.reagents

	else if(istype(target,/obj/effect/plantsegment))

		var/obj/effect/plantsegment/K = target
		grown_seed = K.seed

	if(!grown_seed)
		to_chat(user, "<span class='warning'>\icon[src] [src] can tell you nothing about [target].</span>")
		return

	form_title = "[grown_seed.seed_name] (#[grown_seed.uid])"
	user.visible_message("<span class='notice'>[user] runs the scanner over [target].</span>")

	var/dat = list()
	dat += "<h3>Plant data for [form_title]</h3>"

	dat += "<h2>General Data</h2>"

	dat += "<table>"
	dat += "<tr><td><b>Endurance</b></td><td>[grown_seed.endurance]</td></tr>"
	dat += "<tr><td><b>Yield</b></td><td>[grown_seed.yield]</td></tr>"
	dat += "<tr><td><b>Lifespan</b></td><td>[grown_seed.lifespan]</td></tr>"
	dat += "<tr><td><b>Maturation time</b></td><td>[grown_seed.maturation]</td></tr>"
	dat += "<tr><td><b>Production time</b></td><td>[grown_seed.production]</td></tr>"
	dat += "<tr><td><b>Potency</b></td><td>[grown_seed.potency]</td></tr>"
	dat += "</table>"

	if(grown_reagents && grown_reagents.reagent_list && grown_reagents.reagent_list.len)
		dat += "<h2>Reagent Data</h2>"

		dat += "<br>This sample contains: "
		for(var/datum/reagent/R in grown_reagents.reagent_list)
			dat += "<br>- [R.id], [grown_reagents.get_reagent_amount(R.id)] unit(s)"

	dat += "<h2>Other Data</h2>"

	if(grown_seed.harvest_repeat)
		dat += "This plant can be harvested repeatedly.<br>"

	if(grown_seed.immutable == -1)
		dat += "This plant is highly mutable.<br>"
	else if(grown_seed.immutable > 0)
		dat += "This plant does not possess genetics that are alterable.<br>"

	if(grown_seed.mutants && grown_seed.mutants.len)
		dat += "It exhibits a high degree of potential subspecies mutations.<br>"

	if(grown_seed.products && grown_seed.products.len)
		dat += "The mature plant will produce [grown_seed.products.len == 1 ? "fruit" : "[grown_seed.products.len] varieties of fruit"].<br>"

	if(grown_seed.nutrient_consumption == 0)
		dat += "It does not require nutrient fluid to subsist.<br>"
	else if(grown_seed.nutrient_consumption < 0.15)
		dat += "It consumes a small amount of nutrient fluid.<br>"
	else if(grown_seed.nutrient_consumption > 0.25)
		dat += "It requires a heavy supply of nutrient fluid.<br>"
	else
		dat += "It requires a moderate supply of nutrient fluid.<br>"

	if(grown_seed.water_consumption == 0)
		dat += "It does not require water to subsist.<br>"
	else if(grown_seed.water_consumption < 1)
		dat += "It requires very little water.<br>"
	else if(grown_seed.water_consumption > 5)
		dat += "It requires a large amount of water.<br>"
	else
		dat += "It requires a stable supply of water.<br>"

	dat += "It thrives in a temperature of [grown_seed.ideal_heat] Kelvin."

	if(grown_seed.lowkpa_tolerance < 20)
		dat += "<br>It is well adapted to low pressure levels."
	if(grown_seed.highkpa_tolerance > 220)
		dat += "<br>It is well adapted to high pressure levels."

	if(grown_seed.heat_tolerance > 50)
		dat += "<br>It is well adapted to a range of temperatures."
	else if(grown_seed.heat_tolerance < 10)
		dat += "<br>It is very sensitive to temperature shifts."

	dat += "<br>It thrives in a light level of [grown_seed.ideal_light] lumen[grown_seed.ideal_light == 1 ? "" : "s"]."

	if(grown_seed.consume_gasses)
		for(var/gas in grown_seed.consume_gasses)
			dat += "<br>It will consume [gas] from the environment."
	if(grown_seed.exude_gasses)
		for(var/gas in grown_seed.exude_gasses)
			dat += "<br>It will exude [gas] into the environment."

	if(grown_seed.light_tolerance > 7)
		dat += "<br>It is well adapted to a range of light levels."
	else if(grown_seed.light_tolerance < 3)
		dat += "<br>It is very sensitive to light level shifts."

	if(grown_seed.toxins_tolerance < 3)
		dat += "<br>It is highly sensitive to toxins."
	else if(grown_seed.toxins_tolerance > 7)
		dat += "<br>It is remarkably resistant to toxins."

	if(grown_seed.pest_tolerance < 3)
		dat += "<br>It is highly sensitive to pests."
	else if(grown_seed.pest_tolerance > 7)
		dat += "<br>It is remarkably resistant to pests."

	if(grown_seed.weed_tolerance < 3)
		dat += "<br>It is highly sensitive to weeds."
	else if(grown_seed.weed_tolerance > 7)
		dat += "<br>It is remarkably resistant to weeds."

	switch(grown_seed.spread)
		if(1)
			dat += "<br>It is capable of growing beyond the confines of a tray."
		if(2)
			dat += "<br>It is a robust and vigorous vine that will spread rapidly."

	if(grown_seed.hematophage)
		dat += "<br>It is a highly specialized hematophage that will only draw nutrients from blood."

	switch(grown_seed.carnivorous)
		if(1)
			dat += "<br>It is carnivorous and will eat tray pests for sustenance."
		if(2)
			dat	+= "<br>It is carnivorous and poses a significant threat to living things around it."

	if(grown_seed.parasite)
		dat += "<br>It is capable of parisitizing and gaining sustenance from tray weeds."

	if(grown_seed.alter_temp)
		dat += "<br>It will gradually alter the local room temperature to match it's ideal habitat."

	if(grown_seed.ligneous)
		dat += "<br>It is a ligneous plant with strong and robust stems."

	if(grown_seed.thorny)
		dat += "<br>It posesses a cover of sharp thorns."

	if(grown_seed.stinging)
		dat += "<br>It posesses a cover of fine stingers capable of releasing chemicals on touch."

	if(grown_seed.teleporting)
		dat += "<br>It posesses a high degree of temporal/spatial instability and may cause spontaneous bluespace disruptions."

	switch(grown_seed.juicy)
		if(1)
			dat += "<br>It's fruit is soft-skinned and abudantly juicy."
		if(2)
			dat	+= "<br>It's fruit is excesively soft and juicy."

	if(grown_seed.biolum)
		dat += "<br>It is [grown_seed.biolum_colour ? "<font color='[grown_seed.biolum_colour]'>bio-luminescent</font>" : "bio-luminescent"]."

	if(dat)
		dat = list2text(dat)
		last_data = dat
		dat += "<br><br>\[<a href='?src=\ref[src];print=1'>print report</a>\] \[<a href='?src=\ref[src];clear=1'>clear</a>\]"
		user << browse(dat,"window=plant_analyzer_\ref[src];size=400x500")
	return

/obj/item/device/analyzer/plant_analyzer/attack_self(mob/user as mob)
	if(last_data)
		user << browse(last_data,"window=plant_analyzer_\ref[src];size=400x500")
	else
		to_chat(user, "<span class='notice'>\icon[src] No plant scan data in memory.</span>")
	return 0

/obj/item/device/analyzer/plant_analyzer/proc/print_report_verb()
	set name = "Print Plant Report"
	set category = "Object"
	set src in usr

	if (!usr || usr.isUnconscious() || usr.restrained() || !Adjacent(usr)) return
	print_report(usr)

/obj/item/device/analyzer/plant_analyzer/Topic(href, href_list)
	if(..())
		return
	if(href_list["print"])
		print_report(usr)
	if(href_list["clear"])
		last_data = ""
		usr << browse(null, "window=plant_analyzer")


/obj/item/device/analyzer/plant_analyzer/proc/print_report(var/mob/living/user) //full credits to Zuhayr
	if(!last_data)
		to_chat(user, "<span class='warning'>\icon[src] There is no plant scan data to print.</span>")
		return
	if (world.time < last_print + 4 SECONDS)
		to_chat(user, "<span class='warning'>\icon[src] \The [src] is not yet ready to print again.</span>")
		return
	last_print = world.time
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(get_turf(src))
	P.name = "paper - [form_title]"
	P.info = "[last_data]"
	if(istype(user,/mob/living/carbon/human))
		user.put_in_hands(P)
	user.visible_message("<span class='notice'>\The [src] spits out a piece of paper.</span>")
	return

// *************************************
// Hydroponics Tools
// *************************************

/obj/item/weapon/plantspray
	icon = 'icons/obj/hydroponics.dmi'
	item_state = "spray"
	flags = FPRINT | NOBLUDGEON
	slot_flags = SLOT_BELT
	throwforce = 4
	w_class = 2.0
	throw_speed = 2
	throw_range = 10
	var/toxicity = 4
	var/pest_kill_str = 0
	var/weed_kill_str = 0

/obj/item/weapon/plantspray/weeds // -- Skie

	name = "weed-spray"
	desc = "It's a toxic mixture, in spray form, to kill small weeds."
	icon_state = "weedspray"
	weed_kill_str = 6

/obj/item/weapon/plantspray/pests
	name = "pest-spray"
	desc = "It's some pest eliminator spray! <I>Do not inhale!</I>"
	icon_state = "pestspray"
	pest_kill_str = 6

/obj/item/weapon/plantspray/pests/old
	name = "bottle of pestkiller"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"

/obj/item/weapon/plantspray/pests/old/carbaryl
	name = "bottle of carbaryl"
	icon_state = "bottle16"
	toxicity = 4
	pest_kill_str = 2

/obj/item/weapon/plantspray/pests/old/lindane
	name = "bottle of lindane"
	icon_state = "bottle18"
	toxicity = 6
	pest_kill_str = 4

/obj/item/weapon/plantspray/pests/old/phosmet
	name = "bottle of phosmet"
	icon_state = "bottle15"
	toxicity = 8
	pest_kill_str = 7

/obj/item/weapon/minihoe // -- Numbers
	name = "mini hoe"
	desc = "It's used for removing weeds or scratching your back."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hoe"
	item_state = "hoe"
	flags = FPRINT  | NOBLUDGEON
	siemens_coefficient = 1
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	attack_verb = list("slashed", "sliced", "cut", "clawed")


// *************************************
// Weedkiller defines for hydroponics
// *************************************

/obj/item/weedkiller
	name = "bottle of weedkiller"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT
	var/toxicity = 0
	var/weed_kill_str = 0

/obj/item/weedkiller/triclopyr
	name = "bottle of glyphosate"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT
	toxicity = 4
	weed_kill_str = 2

/obj/item/weedkiller/lindane
	name = "bottle of triclopyr"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle18"
	flags = FPRINT
	toxicity = 6
	weed_kill_str = 4

/obj/item/weedkiller/D24
	name = "bottle of 2,4-D"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle15"
	flags = FPRINT
	toxicity = 8
	weed_kill_str = 7


// *************************************
// Nutrient defines for hydroponics
// *************************************

/obj/item/weapon/reagent_containers/glass/fertilizer
	name = "fertilizer bottle"
	desc = "A small glass bottle. Can hold up to 10 units."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle16"
	flags = FPRINT | OPENCONTAINER
	possible_transfer_amounts = null
	w_class = 2.0

	var/fertilizer //Reagent contained, if any.

	//Like a shot glass!
	amount_per_transfer_from_this = 10
	volume = 10

/obj/item/weapon/reagent_containers/glass/fertilizer/New()
	..()

	src.pixel_x = rand(-5.0, 5)
	src.pixel_y = rand(-5.0, 5)

	if(fertilizer)
		reagents.add_reagent(fertilizer,10)

/obj/item/weapon/reagent_containers/glass/fertilizer/ez
	name = "bottle of E-Z-Nutrient"
	icon_state = "bottle16"
	fertilizer = "eznutrient"

/obj/item/weapon/reagent_containers/glass/fertilizer/l4z
	name = "bottle of Left 4 Zed"
	icon_state = "bottle18"
	fertilizer = "left4zed"

/obj/item/weapon/reagent_containers/glass/fertilizer/rh
	name = "bottle of Robust Harvest"
	icon_state = "bottle15"
	fertilizer = "robustharvest"

//Hatchets and things to kill kudzu
/obj/item/weapon/hatchet
	name = "hatchet"
	desc = "A very sharp axe blade upon a short fibremetal handle. It has a long history of chopping things, but now it is used for chopping wood."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "hatchet"
	flags = FPRINT
	siemens_coefficient = 1
	force = 12.0
	w_class = 2.0
	throwforce = 15.0
	throw_speed = 4
	throw_range = 4
	sharpness = 1.2
	origin_tech = "materials=2;combat=1"
	attack_verb = list("chopped", "torn", "cut")

/obj/item/weapon/hatchet/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

//If it's a hatchet it goes here. I guess
/obj/item/weapon/hatchet/unathiknife
	name = "dueling knife"
	desc = "A length of leather-bound wood studded with razor-sharp teeth. How crude."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "unathiknife"
	attack_verb = list("ripped", "torn", "cut")

/obj/item/weapon/scythe
	icon_state = "scythe0"
	name = "scythe"
	desc = "A sharp and curved blade on a long fibremetal handle, this tool makes it easy to reap what you sow."
	force = 13.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 3
	sharpness = 1.0
	w_class = 4.0
	flags = FPRINT
	slot_flags = SLOT_BACK
	origin_tech = "materials=2;combat=2"
	attack_verb = list("chopped", "sliced", "cut", "reaped")

/obj/item/weapon/scythe/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(A, /obj/effect/plantsegment) || istype(A, /turf/simulated/floor))
		for(var/obj/effect/plantsegment/B in range(user,1))
			B.take_damage(src)
		user.delayNextAttack(10)
		/*var/olddir = user.dir
		spawn for(var/i=-2, i<=2, i++) //hheeeehehe i'm so dumb
			user.dir = turn(olddir, 45*i)
			sleep(2)*/
	/*if(istype(A, /obj/effect/plantsegment))
		for(var/obj/effect/plantsegment/B in orange(A,1))
			if(prob(B.seed.ligneous ? 10 : 80))
				B.die_off()
		var/obj/effect/plantsegment/K = A
		K.die_off()
	if(istype(A, /turf/simulated/floor))
		for(var/obj/effect/plantsegment/B in orange(A,1))
			if(prob(B.seed.ligneous ? 10 : 80))
				B.die_off()*/

/obj/item/claypot
	name = "clay pot"
	desc = "Plants placed in those stop aging, but cannot be retrieved either."
	icon = 'icons/obj/hydroponics2.dmi'
	icon_state = "claypot-item"
	item_state = "claypot"
	inhand_states = list("left_hand" = 'icons/mob/in-hand/left/misc_tools.dmi', "right_hand" = 'icons/mob/in-hand/right/misc_tools.dmi')
	w_class = 3.0
	force = 5.0
	throwforce = 20.0
	throw_speed = 1
	throw_range = 3
	flags = FPRINT

/obj/item/claypot/attackby(var/obj/item/O,var/mob/user)
	if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/grown) || istype(O,/obj/item/weapon/grown))
		to_chat(user, "<span class='warning'>You have to transplant the plant into the pot directly from the hydroponic tray, using a spade.</span>")
	else if(istype(O,/obj/item/weapon/pickaxe/shovel))
		to_chat(user, "<span class='warning'>There is no plant to remove in \the [src].</span>")
	else
		to_chat(user, "<span class='warning'>You cannot plant \the [O] in \the [src].</span>")


/obj/item/claypot/throw_impact(atom/hit_atom)
	..()
	if(prob(40))
		playsound(loc, 'sound/effects/hit_on_shattered_glass.ogg', 75, 1)
		new/obj/effect/decal/cleanable/clay_fragments(src.loc)
		src.visible_message("<span class='warning'>\The [src.name] has been smashed.</span>","<span class='warning'>You hear a crashing sound.</span>")
		qdel(src)

/obj/structure/claypot
	name = "clay pot"
	desc = "Plants placed in those stop aging, but cannot be retrieved either."
	icon = 'icons/obj/hydroponics2.dmi'
	icon_state = "claypot"
	anchored = 0
	density = 0
	var/plant_name = ""

/obj/structure/claypot/examine(mob/user)
	..()
	if(plant_name)
		to_chat(user, "<span class='info'>You can see [plant_name] planted in it.</span>")

/obj/structure/claypot/attack_hand(mob/user as mob)
	to_chat(user, "It's too heavy to pick up while it has a plant in it.")

/obj/structure/claypot/attackby(var/obj/item/O,var/mob/user)
	if(istype(O,/obj/item/weapon/wrench))
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, src, 30))
			anchored = !anchored
			user.visible_message(	"<span class='notice'>[user] [anchored ? "wrench" : "unwrench"]es \the [src] [anchored ? "in place" : "from its fixture"].</span>",
									"<span class='notice'>\icon[src] You [anchored ? "wrench" : "unwrench"] \the [src] [anchored ? "in place" : "from its fixture"].</span>",
									"<span class='notice'>You hear a ratchet.</span>")
	else if(plant_name && istype(O,/obj/item/weapon/pickaxe/shovel))
		to_chat(user, "<span class='notice'>\icon[src] You start removing the [plant_name] from \the [src].</span>")
		if(do_after(user, src, 30))
			playsound(loc, 'sound/items/shovel.ogg', 50, 1)
			user.visible_message(	"<span class='notice'>[user] removes the [plant_name] from \the [src].</span>",
									"<span class='notice'>\icon[src] You remove the [plant_name] from \the [src].</span>",
									"<span class='notice'>You hear some digging.</span>")
			var/obj/item/claypot/C = new(loc)
			transfer_fingerprints(src, C)
			qdel(src)

	else if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/grown) || istype(O,/obj/item/weapon/grown))
		to_chat(user, "<span class='warning'>There is already a plant in \the [src]</span>")

	else
		..()
