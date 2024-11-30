extends CanvasLayer

var stopwatch: Stopwatch
@onready var timer_label: Label = $TimerLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stopwatch = get_tree().get_first_node_in_group("stopwatch")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer_label.text = stopwatch.time_to_string()
