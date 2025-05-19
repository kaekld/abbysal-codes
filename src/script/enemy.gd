extends CharacterBody3D

var vel := 2.0
var hp := 50

var player: Node3D = null
var attackRange = false
var is_dead = false

@onready var enemy_texture: Node3D = $EnemyTexture
@onready var animation_player: AnimationPlayer = $EnemyTexture/AnimationPlayer
@onready var timer: Timer = $Timer
@onready var particles: GPUParticles3D = $GPUParticles3D

@onready var walk: AudioStreamPlayer3D = $Sounds/Walk
@onready var attack: AudioStreamPlayer3D = $Sounds/Attack

func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	if player and player.is_inside_tree():
		movement(delta)
	else:
		velocity = Vector3.ZERO  
	move_and_slide()
func _process(delta: float) -> void:
	if is_dead:
		return
	if player and player.is_inside_tree():
		rotate_towards_player(delta)

func rotate_towards_player(delta: float) -> void:
	var my_pos = global_position
	var player_pos = player.global_position
	player_pos.y = my_pos.y
	var direction = (player_pos - my_pos).normalized()
	var target_angle = atan2(direction.x, direction.z)
	var current_angle = rotation.y
	rotation.y = lerp_angle(current_angle, target_angle, delta * 5.0)

func movement(delta: float) -> void:
	var direction = (player.global_position - global_position).normalized()
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

	velocity.x = direction.x * vel
	velocity.z = direction.z * vel

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0

func _on_enemy_detection_body_entered(body: Node3D) -> void:
	if "Player" in body.name:
		animation_player.speed_scale = 1.0
		animation_player.play("Walk")
		player = body
		
func _on_enemy_detection_body_exited(body: Node3D) -> void:
	if "Player" in body.name:
		animation_player.speed_scale = 1.0
		animation_player.play("Idle")
		if body == player:
			player = null

func _on_attack_area_body_entered(body: Node3D) -> void:
	if "Player" in body.name:
		attackRange = true
		animation_player.speed_scale = 3.0
		animation_player.play("Eat")
		if timer.is_stopped():
			timer.start()

func _on_attack_area_body_exited(body: Node3D) -> void:
	if "Player" in body.name:
		attackRange = false
		animation_player.speed_scale = 1.0
		animation_player.play("Walk")
		if not timer.is_stopped():
			timer.stop()

func _on_timer_timeout() -> void:
	if attackRange and !is_dead:
		attack.play()
		PLAYERSTATS.hp -= 10
		
func receive_damage(amount: int) -> void:
	if is_dead:
		return 
	
	hp -= amount
	if hp <= 0:
		is_dead = true
		velocity = Vector3.ZERO 
		animation_player.speed_scale = 1.0
		animation_player.play("Die")
		await animation_player.animation_finished
		enemy_texture.visible = false
		particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		
		queue_free()
		
func walk_sound():
	walk.play()
