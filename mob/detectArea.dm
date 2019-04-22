detectArea 
	parent_type = /area

	var/mob/source

	New(mob/_source)
		source=_source

	Entered(mob/a)
		if(a.isPlayer())
			source.foundTarget(a)

	proc/SetLocation(location)
		src.loc = locate(location)