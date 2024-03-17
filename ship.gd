extends Node

var ship_name: String
var number_holds: int = 0
var filled_holds: int = 0
var roundtrip_time: int = 1
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
	for hold in range(1, number_holds + 1):
		loaded_cargo[hold] = {"<empty>": 0}
	_refresh_holds()

func _on_selection_toggled(toggled_on: bool) -> void:
	is_selected = toggled_on
	emit_signal("sig_ship_selection", ship_name, is_selected)
	
func _on_roundtrip_changed(value: float) -> void:
	roundtrip_time = int(value)
	
func _refresh_holds() -> void:
	print(loaded_cargo)
	$HBoxContainer/OptionButton.clear()
	for hold in loaded_cargo:
		$HBoxContainer/OptionButton.add_item("%s: %d" % [loaded_cargo[hold].keys()[0], loaded_cargo[hold].values()[0]])

func load_cargo(cargo_name: String, demand_per_min: float) -> float:
	var amount_to_load = ceil(demand_per_min * roundtrip_time)
	var free_holds = number_holds - filled_holds

	if free_holds == 0&&cargo_name not in loaded_cargo:
		print('ship full')
		return 0
	for goods in loaded_cargo:
		if cargo_name in loaded_cargo[goods]:
			print('good found')
			filled_holds -= 1
			print(loaded_cargo[goods][cargo_name])
			amount_to_load += loaded_cargo[goods][cargo_name]

	if free_holds * 50 < amount_to_load:
		print("can't load everything")
		amount_to_load = free_holds * 50

	var goods_transported = amount_to_load / roundtrip_time
	while amount_to_load > 0:
		if amount_to_load >= 50:
			loaded_cargo[filled_holds + 1] = {cargo_name: 50}
			amount_to_load -= 50
			filled_holds += 1
		else:
			loaded_cargo[filled_holds + 1] = {cargo_name: amount_to_load}
			amount_to_load = 0
			filled_holds += 1

	print(goods_transported)
	_refresh_holds()
	return goods_transported

func _delete() -> void:
	emit_signal('sig_delete_ship', ship_name)
	queue_free()
