# ai_areaDetection
trigger AI using a detection object around mob/monsters with AI


### AI

AI is under type */mob/monster/ai*
related to monster, is a variable called detectArea/detectArea

it is located on monster in monster.New() and resetState(), and removed of the map to stop triggering foundTarget().
Under foundTarget(), detectArea is then located to locate(0,0,0)