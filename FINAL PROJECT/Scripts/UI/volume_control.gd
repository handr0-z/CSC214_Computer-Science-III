extends HSlider

# Node Properties
@export var audio_bus_name: String
var audio_bus_id

# Function called when the slider enters the scene and initializes its audio bus
func _ready() -> void:
	if name == "VolumeControl":
		audio_bus_name = "Music"
	if name == "SFXControl":
		audio_bus_name = "Sound Effects"

	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
	value = AudioServer.get_bus_volume_linear(audio_bus_id)

# Function used to update audio volume and play feedback sound
func _on_value_changed(value: float) -> void:
	$"../AudioStreamPlayer".play()
	AudioServer.set_bus_volume_linear(audio_bus_id, value)
