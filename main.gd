extends Node2D

@onready var cam: Camera2D = $camera
@onready var playerHand: Node2D = $playerHand
@onready var playerCards: Array[Node2D] = [
	$card, $card2, $card3
]
@onready var fieldPlayer: Array[Node2D] = []
@onready var moveQueue: Array[Node2D] = []
@onready var moveID: Array[int] = []
@onready var moveTo: Array[String] = []
@onready var returnHand: Marker2D = $playerHand/return

var sine: float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sine += 0.1
	cam.position.y = lerp(cam.position.y, 208.0 if !$playerHand/Show.button_pressed else 0.0, 0.3)
	$Bg.position = Vector2(1024 + (sin(sine * 0.2) * 5), 576 + (sin(sine * 0.3) * 5)) + (cam.position * 0.75)
	$Bg.rotation = sin(sine * 0.1) * 0.01
	if !Global.currentCard:
		for i in playerCards.size():
			if playerCards[i].pos.y > returnHand.global_position.y:
				playerCards[i].pos = Vector2((i * 128) - ((playerCards.size() - 1) * 64), 0) + playerHand.position
				playerCards[i].stillInHand = true
			else:
				playerCards[i].stillInHand = false
				moveQueue.push_front(playerCards[i])
				moveID.push_front(i)
				moveTo.push_front("field")
		for i in fieldPlayer.size():
			if fieldPlayer[i].pos.y > returnHand.global_position.y:
				moveQueue.push_front(fieldPlayer[i])
				moveID.push_front(i)
				moveTo.push_front("hand")
	for j in moveQueue.size():
		if moveTo[j] == "field":
			fieldPlayer.push_front(moveQueue[j])
			playerCards.remove_at(moveID[j])
		elif moveTo[j] == "hand":
			playerCards.push_front(moveQueue[j])
			fieldPlayer.remove_at(moveID[j])
	moveTo.clear()
	moveID.clear()
	moveQueue.clear()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug1"):
		$card.duplicate(8)
