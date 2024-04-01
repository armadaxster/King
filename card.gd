extends Node2D

var card_id = 0
var card_name = ""
var card_suit = ""
var card_value = 0
var card_sprite = "res://sprites/deck/S1.png"
var card_position = Vector2(PI,PI)

# Called when the node enters the scene tree for the first time.
func _ready():
	$CardSprite.texture = load(card_sprite)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
