extends Node

var client_info = {
	"name": "Kimolaki?",
	"is_player": false
}

var clients : Dictionary  = {}

var players : Dictionary  = {}

var player_list : Array

var non_players : Dictionary  = {}

var playdeck : Array 

var player_hands : Dictionary 

var my_hand : Array

var card_held = false

var cards_hovering : Array

const deck = {
	c13 = {
		id = 13,
		name = "ace_of_clubs",
		suit = "suit_clubs",
		value = 15,
		sprite = "res://sprites/deck/C1.png"
	},
	c1 = {
		id = 1,
		name = "2_of_clubs",
		suit = "suit_clubs",
		value = 2,
		sprite = "res://sprites/deck/C2.png"
	},
	c2 = {
		id = 2,
		name = "3_of_clubs",
		suit = "suit_clubs",
		value = 3,
		sprite = "res://sprites/deck/C3.png"
	},
	c3 = {
		id = 3,
		name = "4_of_clubs",
		suit = "suit_clubs",
		value = 4,
		sprite = "res://sprites/deck/C4.png"
	},
	c4 = {
		id = 4,
		name = "5_of_clubs",
		suit = "suit_clubs",
		value = 5,
		sprite = "res://sprites/deck/C5.png"
	},
	c5 = {
		id = 5,
		name = "6_of_clubs",
		suit = "suit_clubs",
		value = 6,
		sprite = "res://sprites/deck/C6.png"
	},
	c6 = {
		id = 6,
		name = "7_of_clubs",
		suit = "suit_clubs",
		value = 7,
		sprite = "res://sprites/deck/C7.png"
	},
	c7 = {
		id = 7,
		name = "8_of_clubs",
		suit = "suit_clubs",
		value = 8,
		sprite = "res://sprites/deck/C8.png"
	},
	c8 = {
		id = 8,
		name = "9_of_clubs",
		suit = "suit_clubs",
		value = 9,
		sprite = "res://sprites/deck/C9.png"
	},
	c9 = {
		id = 9,
		name = "10_of_clubs",
		suit = "suit_clubs",
		value = 10,
		sprite = "res://sprites/deck/C10.png"
	},
	c10 = {
		id = 10,
		name = "jack_of_clubs",
		suit = "suit_clubs",
		value = 11,
		sprite = "res://sprites/deck/C11.png"
	},
	c11 = {
		id = 11,
		name = "queen_of_clubs",
		suit = "suit_clubs",
		value = 12,
		sprite = "res://sprites/deck/C12.png"
	},
	c12 = {
		id = 12,
		name = "king_of_clubs",
		suit = "suit_clubs",
		value = 13,
		sprite = "res://sprites/deck/C13.png"
	},
	c26 = {
		id = 26,
		name = "ace_of_diamonds",
		suit = "suit_diamonds",
		value = 15,
		sprite = "res://sprites/deck/D1.png"
	},
	c14 = {
		id = 14,
		name = "2_of_diamonds",
		suit = "suit_diamonds",
		value = 2,
		sprite = "res://sprites/deck/D2.png"
	},
	c15 = {
		id = 15,
		name = "3_of_diamonds",
		suit = "suit_diamonds",
		value = 3,
		sprite = "res://sprites/deck/D3.png"
	},
	c16 = {
		id = 16,
		name = "4_of_diamonds",
		suit = "suit_diamonds",
		value = 4,
		sprite = "res://sprites/deck/D4.png"
	},
	c17 = {
		id = 17,
		name = "5_of_diamonds",
		suit = "suit_diamonds",
		value = 5,
		sprite = "res://sprites/deck/D5.png"
	},
	c18 = {
		id = 18,
		name = "6_of_diamonds",
		suit = "suit_diamonds",
		value = 6,
		sprite = "res://sprites/deck/D6.png"
	},
	c19 = {
		id = 19,
		name = "7_of_diamonds",
		suit = "suit_diamonds",
		value = 7,
		sprite = "res://sprites/deck/D7.png"
	},
	c20 = {
		id = 20,
		name = "8_of_diamonds",
		suit = "suit_diamonds",
		value = 8,
		sprite = "res://sprites/deck/D8.png"
	},
	c21 = {
		id = 21,
		name = "9_of_diamonds",
		suit = "suit_diamonds",
		value = 9,
		sprite = "res://sprites/deck/D9.png"
	},
	c22 = {
		id = 22,
		name = "10_of_diamonds",
		suit = "suit_diamonds",
		value = 10,
		sprite = "res://sprites/deck/D10.png"
	},
	c23 = {
		id = 23,
		name = "jack_of_diamonds",
		suit = "suit_diamonds",
		value = 11,
		sprite = "res://sprites/deck/D11.png"
	},
	c24 = {
		id = 24,
		name = "queen_of_diamonds",
		suit = "suit_diamonds",
		value = 12,
		sprite = "res://sprites/deck/D12.png"
	},
	c25 = {
		id = 25,
		name = "king_of_diamonds",
		suit = "suit_diamonds",
		value = 13,
		sprite = "res://sprites/deck/D13.png"
	},
	c52 = {
		id = 52,
		name = "ace_of_hearts",
		suit = "suit_hearts",
		value = 15,
		sprite = "res://sprites/deck/H1.png"
	},
	c40 = {
		id = 40,
		name = "2_of_hearts",
		suit = "suit_hearts",
		value = 2,
		sprite = "res://sprites/deck/H2.png"
	},
	c41 = {
		id = 41,
		name = "3_of_hearts",
		suit = "suit_hearts",
		value = 3,
		sprite = "res://sprites/deck/H3.png"
	},
	c42 = {
		id = 42,
		name = "4_of_hearts",
		suit = "suit_hearts",
		value = 4,
		sprite = "res://sprites/deck/H4.png"
	},
	c43 = {
		id = 43,
		name = "5_of_hearts",
		suit = "suit_hearts",
		value = 5,
		sprite = "res://sprites/deck/H5.png"
	},
	c44 = {
		id = 44,
		name = "6_of_hearts",
		suit = "suit_hearts",
		value = 6,
		sprite = "res://sprites/deck/H6.png"
	},
	c45 = {
		id = 45,
		name = "7_of_hearts",
		suit = "suit_hearts",
		value = 7,
		sprite = "res://sprites/deck/H7.png"
	},
	c46 = {
		id = 46,
		name = "8_of_hearts",
		suit = "suit_hearts",
		value = 8,
		sprite = "res://sprites/deck/H8.png"
	},
	c47 = {
		id = 47,
		name = "9_of_hearts",
		suit = "suit_hearts",
		value = 9,
		sprite = "res://sprites/deck/H9.png"
	},
	c48 = {
		id = 48,
		name = "10_of_hearts",
		suit = "suit_hearts",
		value = 10,
		sprite = "res://sprites/deck/H10.png"
	},
	c49 = {
		id = 49,
		name = "jack_of_hearts",
		suit = "suit_hearts",
		value = 11,
		sprite = "res://sprites/deck/H11.png"
	},
	c50 = {
		id = 50,
		name = "queen_of_hearts",
		suit = "suit_hearts",
		value = 12,
		sprite = "res://sprites/deck/H12.png"
	},
	c51 = {
		id = 51,
		name = "king_of_hearts",
		suit = "suit_hearts",
		value = 13,
		sprite = "res://sprites/deck/H13.png"
	},
	c39 = {
		id = 39,
		name = "ace_of_spades",
		suit = "suit_spades",
		value = 15,
		sprite = "res://sprites/deck/S1.png"
	},
	c27 = {
		id = 27,
		name = "2_of_spades",
		suit = "suit_spades",
		value = 2,
		sprite = "res://sprites/deck/S2.png"
	},
	c28 = {
		id = 28,
		name = "3_of_spades",
		suit = "suit_spades",
		value = 3,
		sprite = "res://sprites/deck/S3.png"
	},
	c29 = {
		id = 29,
		name = "4_of_spades",
		suit = "suit_spades",
		value = 4,
		sprite = "res://sprites/deck/S4.png"
	},
	c30 = {
		id = 30,
		name = "5_of_spades",
		suit = "suit_spades",
		value = 5,
		sprite = "res://sprites/deck/S5.png"
	},
	c31 = {
		id = 31,
		name = "6_of_spades",
		suit = "suit_spades",
		value = 6,
		sprite = "res://sprites/deck/S6.png"
	},
	c32 = {
		id = 32,
		name = "7_of_spades",
		suit = "suit_spades",
		value = 7,
		sprite = "res://sprites/deck/S7.png"
	},
	c33 = {
		id = 33,
		name = "8_of_spades",
		suit = "suit_spades",
		value = 8,
		sprite = "res://sprites/deck/S8.png"
	},
	c34 = {
		id = 34,
		name = "9_of_spades",
		suit = "suit_spades",
		value = 9,
		sprite = "res://sprites/deck/S9.png"
	},
	c35 = {
		id = 35,
		name = "10_of_spades",
		suit = "suit_spades",
		value = 10,
		sprite = "res://sprites/deck/S10.png"
	},
	c36 = {
		id = 36,
		name = "jack_of_spades",
		suit = "suit_spades",
		value = 11,
		sprite = "res://sprites/deck/S11.png"
	},
	c37 = {
		id = 37,
		name = "queen_of_spades",
		suit = "suit_spades",
		value = 12,
		sprite = "res://sprites/deck/S12.png"
	},
	c38 = {
		id = 38,
		name = "king_of_spades",
		suit = "suit_spades",
		value = 13,
		sprite = "res://sprites/deck/S13.png"
	}
}
