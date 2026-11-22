extends Node

enum{
	DIALOGUE, DIALOGUE_SPEED, SPECIAL_EFFECT, IS_OPTION, OPTIONS, OPTIONS_NEXT_DIALOGUE_INDEX
}

## Node3D corresponding to the current active dialogue - only one should be active at a time
var current_dialogue: Node3D
