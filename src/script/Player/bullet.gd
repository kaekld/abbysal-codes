extends Node3D

const SPEED = 300

@onready var mesh = $MeshInstance3D
@onready var raycast = $RayCast3D
@onready var partitles: GPUParticles3D = $GPUParticles3D

@onready var bullet_sound: AudioStreamPlayer3D = $BulletSound
@onready var bullet_impact_sound: AudioStreamPlayer3D = $BulletImpactSound

var damage := 10

func _ready():
	bullet_sound.play()
	
func _process(delta: float) -> void:
	position += transform.basis	* Vector3 (0,0,SPEED) * delta
	if raycast.is_colliding():
		var collider = raycast.get_collider()

		if collider.is_in_group("enemy"):
			collider.receive_damage(damage)
			
		bullet_impact_sound.play()
		mesh.visible = false
		partitles.global_position = global_position + -transform.basis.z * 40
		partitles.emitting = true
		
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_timer_timeout() -> void:
	partitles.emitting = true
	await get_tree().create_timer(3.0).timeout
	queue_free()
