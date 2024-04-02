extends Node2D

var held = false
var hovering = false
var followspeed = 16
var t_up = 0
var t_dn = 0

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
	if held:
		global_position = lerp(global_position, get_global_mouse_position(), delta*followspeed)
	elif not GameMode.card_held:
		if GameMode.cards_hovering.has(card_id):
			if GameMode.cards_hovering.max() == card_id:
				hovering = true
				t_dn = 0
			else:
				hovering = false
				t_up = 0
	if not held:
		if hovering:
			t_up += delta*2
			position = position.lerp(card_position + Vector2(0,-50), t_up)
			
		elif card_position != Vector2(PI, PI):
			t_dn += delta*2
			position = position.lerp(card_position, t_dn)



func _on_area_2d_input_event(viewport:Node, event:InputEvent, shape_idx:int):
	if Input.is_action_just_pressed("left_click") and hovering:
		held = true
		GameMode.card_held = true
		z_index = 999

func _on_area_2d_mouse_entered():
	t_dn = 0
	if card_position == Vector2(PI, PI):
		card_position = position
	
	if not GameMode.cards_hovering.has(card_id):
		GameMode.cards_hovering.append(card_id)

func _on_area_2d_mouse_exited():
	t_up = 0
	hovering = false
	
	if GameMode.cards_hovering.has(card_id):
		GameMode.cards_hovering.erase(card_id)


