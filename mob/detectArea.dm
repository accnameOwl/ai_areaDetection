detectArea 
	parent_type = /obj

	var/mob/source

	New(mob/_source)
		source=_source

	Entered(mob/player/a)
		//proc monster's AI, by calling foundTarget()
		source.foundTarget(a)

	proc/SetBounds(bound_width, bound_height)
		//set boundings.
		src.bound_width = bound_width
		src.bound_height = bound_height