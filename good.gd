extends Control

var good_name: String
var demand_total: float
var is_selected: bool

signal sig_good_selection()
signal sig_delete_good()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/Label_name.text = good_name
	$HBoxContainer/Input_demand.text = str(demand_total).pad_decimals(2)
	$HBoxContainer/Label_unmet.text = str(demand_total).pad_decimals(2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setup(new_name: String, new_demand: float) -> void:
	good_name = new_name
	demand_total = new_demand


func _on_selection_toggled(toggled_on: bool) -> void:
	is_selected = toggled_on
	emit_signal("sig_good_selection", good_name, is_selected)


func _delete() -> void:
	emit_signal('sig_delete_good', good_name)
	queue_free()
