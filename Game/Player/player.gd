extends CharacterBody2D
class_name Player

@export_category("Movimentação")
@export var max_speed: int = 130

@export var jump_force: int = 300
@export var accelerarion: int = 50
@export var jump_buffer_time: int = 15
@export var crouch_speed: float = 0.5
@export var crouch_jump: float = 0.8
@export var cayote_time: int = 15


var jump_buffer_counter: int = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var cayote_counter: int = 0
var direction
var charge:int = clamp(0,0,100)
var dashposition
var charged: bool = false
var have_doublejump: bool = true
var used_doublejump: bool = false

@onready var charge_label: Label = $ChargeLabel
@onready var charged_timer: Timer = $ChargedTimer
@onready var player_sprite: Sprite2D = $PlayerSprite


func _ready() -> void:
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	charge_label.text = str(charge)
	dashposition = position.x + 500
	
func _physics_process(delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right")
	
	if is_on_floor():
		cayote_counter = cayote_time #enquanto ta no chao carrega o contador
	if not is_on_floor(): #Quando nao está no chao, aplica a gravidade
		if cayote_counter > 0:
			cayote_counter -= 1 #saiu do chao o contador de tempo pra pular inicia
		velocity.y += (gravity-200) * delta 
		if velocity.y > 1500: #evitar que ele ganhe velocidade caindo infinitamente
			velocity.y = 1500
			
	if Input.is_action_just_pressed("click"):
		boost()
	if Input.is_action_just_pressed("charge"):
		recharge()
		
	if direction: #se tiever um input
		if charged:
			velocity.x = (direction * max_speed) * 2
		else:
			velocity.x = direction * max_speed
	
	#flip
	if direction > 0:
		player_sprite.flip_h = false
	elif direction < 0:
		player_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, accelerarion)

	
	jump()
	move_and_slide()
	#update_animations(direction)

func jump():
	if is_on_floor():
		have_doublejump = true
		#used_doublejump = false
		
	if Input.is_action_just_pressed("jump"): 
		jump_buffer_counter = jump_buffer_time
		
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and cayote_counter > 0: #se puder, pula
		jump_vector()
		
	elif Input.is_action_just_pressed("jump") and have_doublejump == true:
		have_doublejump = false
		jump_vector()
		
	if Input.is_action_just_released("jump"): #se o mano soltar o espaço no meio do pulo aumenta a gravidade pro pulo ser menor
		if velocity.y < 0:
			velocity.y += 100

func recharge() -> void:
	charge += 20

func boost() -> void:
	#
	if charged or charge <= 0:
		return
	charge -= 20
	position.x = lerp(position.x,dashposition,0.5)
	charged_timer.start()
	charged = true

func _on_charged_timer_timeout() -> void:
	charged = false

func jump_vector() -> void:
	velocity.y = -jump_force
	jump_buffer_counter = 0
	cayote_counter = 0
