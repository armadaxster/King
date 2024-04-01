extends Node2D

# Card Scene Preloading
const card = preload("res://card.tscn")


# Selects and returns(also removes) a random card from the deck.
func pick_a_card():
	
	var random_card = card.instantiate()
	var random_card_id = GameMode.playdeck.pick_random()
	var random_card_key = str("c", random_card_id)
	
	GameMode.playdeck.erase(random_card_id)
	
	random_card.card_id = GameMode.deck[random_card_key].id
	random_card.card_name = GameMode.deck[random_card_key].name
	random_card.card_suit = GameMode.deck[random_card_key].suit
	random_card.card_value = GameMode.deck[random_card_key].value
	random_card.card_sprite = GameMode.deck[random_card_key].sprite
	
	print(random_card.card_name)
	print(GameMode.playdeck)
	return random_card

# Called when the node enters the scene tree for the first time.
func _ready():
	$P0.add_child(pick_a_card())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
