@tool
extends Area2D
class_name Card
## Base node for a card game

## Name of the Card
@export var title: String = ""
## Type of the card
@export_enum("Corrupter", "Rune", "Darkside", "Distrupt", "Equip", "Group", "Sabotage", "Token") var type: String = "Corrupter"
## Description of the card
@export_multiline var description: String = ""
## Attack point of the card
@export var attack: int = 1000
## Defense point of the card
@export var defense: int = 1000
## Group that this card is belongs to, only if the card is a corrupter
@export_enum("None", "TJC", "FC", "CC", "KC", "NC") var groupA: String = "None"
## Group that this card is belongs to, only if the card is a corrupter
@export_enum("None", "TJC", "FC", "CC", "KC", "NC") var groupB: String = "None"
## Determine if the card is facing down or not
@export var flipped: bool = false :
	set (value):
		flipped = value
		$back.visible = value
		$front.visible = !value
		bop()
	get:	
		return flipped
@export var front: Texture2D :
	set (value):
		front = value
		if value == null:
			$front.texture = value
	get:
		return front
@export var pos: Vector2
@export_range(-360, 360) var ang: float
@export_enum("Player", "Opponent") var ownedBy: String = "Player"

var offset: Vector2
var sine: float
var randval: float
var drag: bool
var onmouse: bool
var stillInHand: bool
var floatMultiply: float = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sine = randf_range(0, 15)
	randval = randf_range(1, 3)
	if !Engine.is_editor_hint():
		pos = position
		ang = rotation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sine += 0.01
	$front.scale = lerp($front.scale, Vector2(1, 1), 0.2)
	$back.scale = lerp($back.scale, Vector2(1, 1), 0.2)
	if !Engine.is_editor_hint():
		floatMultiply = lerp(floatMultiply, float(stillInHand), 0.1)
		$front.texture = front
		position = lerp(position, pos + (Vector2(sin(sine * randval), cos(sine * -randval)) * floatMultiply), 0.4) 
		rotation = lerp(rotation, ang + ((sin(sine * randval) * 0.01) * floatMultiply), 0.3)
		if drag:
			pos = get_global_mouse_position() + offset
			ang = position.angle_to(pos)
			Global.currentCard = title
		else:
			ang = 0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and ownedBy == "Player":
		if onmouse:
			drag = event.pressed
			offset = position - get_global_mouse_position()
			if event.pressed:
				$front.scale = Vector2(1.2, 1.2)
				$back.scale = Vector2(1.2, 1.2)
				rotation = deg_to_rad(randf_range(-30, 30))
				if event.button_index == 2:
					flipped = !flipped
					Global.cardFlip.play()
				else:
					Global.cardMove.play()
		else:
			drag = false

func bop() -> void:
	$front.scale = Vector2(0, 1.2)
	$back.scale = Vector2(0, 1.2)

func _on_mouse_entered() -> void:
	onmouse = true
	if type == "Distrupt" and !stillInHand:
		flipped = false

func _on_mouse_exited() -> void:
	onmouse = false
	if type == "Distrupt" and !stillInHand:
		flipped = true
