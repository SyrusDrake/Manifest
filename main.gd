extends Node
var ship_scene = load("res://ship.tscn")
var good_scene = load("res://good.tscn")
var ship_list = {}
var goods_list = {}
var cur_selected_ship: String
var cur_selected_good: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_new_ship() -> void:
	var ship_name = $GUI/Input_ship_name.get_text()
	var cargo_holds = $GUI/Spin_cargo_holds.get_value()
	if ship_name.is_empty():
		print('empty string')
	elif ship_name in ship_list:
		print('ship already exists')
	else:
		ship_list[ship_name] = ship_scene.instantiate()
		ship_list[ship_name].setup(ship_name, cargo_holds)
		$GUI/ScrollContainer_ships/VBox_ships.add_child(ship_list[ship_name])
		ship_list[ship_name].sig_ship_selection.connect(_select_ship.bind())
		ship_list[ship_name].sig_delete_ship.connect(_delete_ship.bind())
		$GUI/Input_ship_name.clear()
		$GUI/Spin_cargo_holds.value = 1

func _select_ship(selected_ship, is_selected) -> void:
	if is_selected:
		cur_selected_ship = selected_ship
		for ship in ship_list:
			if ship == cur_selected_ship:
				pass
			else:
				ship_list[ship].get_node("HBoxContainer/CheckBox").button_pressed = false
	elif not is_selected and selected_ship == cur_selected_ship:
		cur_selected_ship = ""

func _delete_ship(ship_to_delete) -> void:
	ship_list.erase(ship_to_delete)
	if ship_to_delete == cur_selected_ship:
		cur_selected_ship = ''
			
func _add_new_good() -> void:
	var good_name = $GUI/Input_good_name.get_text()
	var good_amount = float($GUI/Input_demand.get_text())
	if good_name.is_empty():
		print('empty string')
	elif good_name in goods_list:
		print('good already exists')
	else:
		goods_list[good_name] = good_scene.instantiate()
		goods_list[good_name].setup(good_name, good_amount)
		$GUI/ScrollContainer_goods/VBox_goods.add_child(goods_list[good_name])
		goods_list[good_name].sig_good_selection.connect(_select_good.bind())
		goods_list[good_name].sig_delete_good.connect(_delete_good.bind())
		$GUI/Input_good_name.clear()
		$GUI/Input_demand.clear()

func _select_good(selected_good, is_selected) -> void:
	if is_selected:
		cur_selected_good = selected_good
		for good in goods_list:
			if good == cur_selected_good:
				pass
			else:
				goods_list[good].get_node("HBoxContainer/CheckBox").button_pressed = false
	elif not is_selected and selected_good == cur_selected_good:
		cur_selected_good = ""
		
func _delete_good(good_to_delete) -> void:
	goods_list.erase(good_to_delete)
	if good_to_delete == cur_selected_good:
		cur_selected_good = ''

func _test_function() -> void:
	if cur_selected_good != ""&&cur_selected_ship != "":
		var good_to_load = goods_list[cur_selected_good]
		var target_ship = ship_list[cur_selected_ship]
		var amount_transported = target_ship.load_cargo(good_to_load.good_name, good_to_load.demand_remaining)
		good_to_load.load_on_ship(target_ship.name, amount_transported)
	else:
		print('select good and ship')
