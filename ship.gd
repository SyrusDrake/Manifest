extends Node

var ship_name: String
var number_holds: int = 0
var roundtrip_time: int = 0
var is_selected: bool = false
var loaded_cargo = {}

signal sig_ship_selection()
signal sig_delete_ship()
signal sig_rename_ship()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Label_name.text = ship_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func setup(new_name: String, new_holds: int) -> void:
	ship_name = new_name
	number_holds = new_holds
	for hold in range(1,number_holds+1):
		loaded_cargo[hold] = {}
	_refresh_holds()

func _on_selection_toggled(toggled_on: bool) -> void:
	is_selected = toggled_on
	emit_signal("sig_ship_selection", ship_name, is_selected)
	
func _on_roundtrip_changed(value: float) -> void:
	roundtrip_time = int(value)
	
func _refresh_holds() -> void:
	$HBoxContainer/OptionButton.clear()
	for hold in loaded_cargo:
		if loaded_cargo[hold] == {}:
			$HBoxContainer/OptionButton.add_item("<empty>")
		else:
			$HBoxContainer/OptionButton.add_item("%s: %d" % [loaded_cargo[hold].keys()[0], loaded_cargo[hold].values()[0]])
	

func load_cargo(cargo_name: String, demand_per_min: float) -> void:
	var amount_to_load = ceil(demand_per_min * roundtrip_time)
	# TODO: loaded_cargo is always equal to number of holds because it is initiated with empty dicts
	var free_holds = number_holds - len(loaded_cargo)
	if free_holds == 0:
		print('ship full')
		return
	elif free_holds * 50 < amount_to_load:
		print("can't load everything")
	loaded_cargo[2] = {cargo_name: amount_to_load}
	_refresh_holds()
	

func _delete() -> void:
	emit_signal('sig_delete_ship', ship_name)
	queue_free()





