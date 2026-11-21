extends Node

enum{
	DIALOGUE, DIALOGUE_SPEED, SPECIAL_EFFECT, IS_OPTION, OPTIONS, OPTIONS_NEXT_DIALOGUE_INDEX
}

## This corresponds to the index in all_dialogue
var current_conversation: int = -1

var all_dialogue: Array = [
	example_dialogue,
]

var example_dialogue: Array = [
	#["Message", "speed", "special effect", is_option, ["option1", "option2"], [next_dialogue_index1, next_dialogue_index2],
	["Hey! You there!", "normal", "", false],
	["Can you help me with something real quick?", "normal", "", true, ["Sure!"], [-1]],
	["Great! Could you get me an apple? There's some behind you!", "normal", "", false]
]

var npc_cancel_message := ""
