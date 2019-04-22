#define MAX_AGGRO_RANGE 12

//Originally created by Ter
//monster ai. 
//AI detection happens in /mob/player/Moved() - File: _player.dm

mob/monster
	ai
		var
			aggro_dist = 7
			mob/player/target
			keep_dist = 1
			chase_speed = 1

			turf/aggro_loc
			turf/home_loc

			next_attack = 0

			detectArea/detectArea = New(src)

		
		proc

			foundTarget(mob/p)
				if(!target && !p.combat_dead)
					target = p
					aggro_loc = p.loc
					src.chaseState()

			lostTarget()
				var
					rng = range(aggro_loc, aggro_dist)
					mob/player/trg
					mdist = aggro_dist + 1
					d

				for(var/mob/player/_p in rng)
					d = get_dist(src, _p)
					if(_p < mdist || (d == mdist && rand(1)))
						mdist = d
						trg = _p

				if(trg)
					target = trg

				else
					resetState()

			attack()

		proc
			chaseState()
				set waitfor = 0
				var/d = get_dist(src, target)
				detectArea.loc = locate(0,0,0)
				while(d > keep_dist)
					if(get_dist(aggro_loc, src) > aggro_dist || !target.combat_dead)
						src.lostTarget()
						return
					. = step(src, get_dir(src, target))
					if(!.)
						step_rand(src)
					sleep(chase_speed)
					d = get_dist(src, target)

				attackState()
				return 1
			
			attackState()
				set waitfor = 0
				var/d
				while(stats_get_value(src.target, "health") > 0)
					d = get_dist(src, target)

					if(d > keep_dist)
						chaseState()
						return

					if(d < keep_dist)
						. = step_away(src, target)
						if(!.)
							step_rand(src)
						
					if(world.time >= next_attack)
						attack()
					sleep(chase_speed)
				
				src.lostTarget()
			
			resetState()
				set waitfor = 0
				var
					returnTime = world.time + get_dist(src, home_loc) * (3 + chase_speed)
				while(world.time < returnTime && src.loc != home_loc)
					. = step(src, get_dir(src, home_loc))
					if(!.)
						step_rand(src)

					sleep(chase_speed)

				if(src.loc != home_loc)
					src.loc = home_loc
				src.target = null
				src.aggro_loc = null
				detectArea.loc = locate(src)
		
		Move(turf/newLoc, Dir = 0, step_x = 0, step_y = 0)
			var/d = Dir & Dir-1
			if(d)
				Dir = rand(1) ? d : Dir^d
				newLoc = get_step(src, Dir)
			. = ..(newLoc, Dir, step_x, step_y)
		New()
			. = ..()
			home_loc = src.loc
			if(!detectArea) detectionArea = New(src)
			detectionArea.loc = locate(src)
			//bounds are in pixels, as to which aggro_dist is aggro distance in number of tiles.
			//We do math and convert amounts of tiles into pixels and multiply by 2, since aggro_dist is one direction
			//but we need in both directions each axis.

			/*
			aggro_dist <---------- (mob) ----------> aggro_dist
			*/
			
			detectionArea.SetBounds( (aggro_dist * world.icon_size)*2, (aggro_dist * world.icon_size)*2)