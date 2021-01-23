extends KinematicBody2D


onready var _rayE = get_node("RayE")
onready var _rayD = get_node("RayD")
onready var _sprite = get_node("AnimatedSprite")

var alive = true
var end = false

signal died
signal end

var left
var right
var up

#--------------------------------------------

const WALK_FORCE = 600
const WALK_MAX_SPEED = 300
const STOP_FORCE = 1300
const JUMP_SPEED = 700
const GRAVITY = 1100.0 # Pixels/second

var velocity = Vector2()

#onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	
	var walk_left = Input.is_action_pressed("move_left") or left
	var walk_right = Input.is_action_pressed("move_right") or right or end
	var jump = Input.is_action_pressed("jump") or up
	
	
	# Horizontal movement code. First, get the player's input.
	var walk = WALK_FORCE * (Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	if alive:
		# Slow down the player if they're not trying to move.
		if abs(walk) < WALK_FORCE * 0.2:
			# The velocity, slowed down a bit, and then reassigned.
			velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
		else:
			velocity.x += walk * delta
		# Clamp to the maximum horizontal movement speed.
		velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
	if end:
		velocity.x += WALK_FORCE * 10 * delta
	
	# Vertical movement code. Apply gravity.
	velocity.y += GRAVITY * delta

	# Move based on the velocity and snap to the ground.
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor() and (Input.is_action_just_pressed("jump") or up) and alive:
		jump()
		
	var on_ground = _rayE.is_colliding() or _rayD.is_colliding()
	
	if walk_right and alive:
		_sprite.set_flip_h(false)
	if walk_left and alive:
		_sprite.set_flip_h(true)
		
	if (walk_left or walk_right) and on_ground and alive:
		_sprite.play()
	elif (walk_left or walk_right) and alive:
		_sprite.stop()
		_sprite.set_frame(3)
	else:
		_sprite.stop()
		_sprite.set_frame(1)
	
	if position.y > 1000:
		die()


func _on_Feet_body_entered(body):
	if not alive: return
	jump()
	body.crush()
	
func jump():
	velocity.y = -JUMP_SPEED

func die():
	if not alive: return
	alive = false
	velocity.x = -10
	velocity.y = -500
	get_node("Shape").set_deferred("disabled", true)
	emit_signal("died")


func _on_Body_body_entered(body):
	if not alive: return
	die()


func _on_Head_body_entered(body):
	if not alive: return
	if body.has_method("destroy"):
		body.destroy()


func revive():
	velocity = Vector2(0, 0)
	get_node("Shape").set_deferred("disabled", false)
	get_node("Camera").make_current()
	alive = true
	end = false


func _on_End_body_entered(body):
	end = true
	emit_signal("end")
