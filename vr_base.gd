extends XROrigin3D

@onready
var left_hand = $XRControllerLeft

@onready
var right_hand = $XRControllerRight

@onready 
var camera = $Camera

func right_hand_vector() -> Vector2: 
	return right_hand.get_vector2("primary")

func left_hand_vector() -> Vector2:
	return left_hand.get_vector2("primary")
