extends CharacterBody2D
class_name Player

@export_category("Movimentação")
@export var speed: int = 50
@export var jump_force: int = 300
@export var accelerarion: int = 50
@export var jump_buffer_time: int = 15
@export var crouch_speed: float = 0.5
@export var crouch_jump: float = 0.8
@export var cayote_time: int = 15

var dash_acc = 2
var dash_limit = 1500
var dash_decay = 20
var speed_limit = 800
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
	print(velocity)
	if is_on_floor():
		cayote_counter = cayote_time #enquanto ta no chao carrega o contador
	if not is_on_floor(): #Quando nao está no chao, aplica a gravidade
		if cayote_counter > 0:
			cayote_counter -= 1 #saiu do chao o contador de tempo pra pular inicia
		velocity.y += (gravity-200) * delta 
		if velocity.y > 1500: #evitar que ele ganhe velocidade caindo infinitamente
			velocity.y = 1500
			
	if Input.is_action_pressed("click") and charge > 0:
		boost()
	else:
		charged = false
	if Input.is_action_just_pressed("charge"):
		recharge()
		
	if direction and charged == true:
		charge -= 2
		velocity.x = velocity.x + speed * dash_acc * direction
		velocity.x = clamp(velocity.x + direction * speed,-dash_limit ,dash_limit)
	elif direction and charged == false: 
		if velocity.x > dash_limit:
			velocity.x = velocity.x - dash_decay
		elif velocity.x < -dash_limit:
			velocity.x = velocity.x + dash_decay
		else:
			velocity.x = clamp(velocity.x + direction * speed,-speed_limit ,speed_limit)
	else:
		velocity.x = move_toward(velocity.x, 0, accelerarion)
	
	#flip
	if direction > 0:
		player_sprite.flip_h = false
	elif direction < 0:
		player_sprite.flip_h = true

	
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
	charged = true





func jump_vector() -> void:
	velocity.y = -jump_force
	jump_buffer_counter = 0
	cayote_counter = 0


func _on_water_collision_area_entered(area: Area2D) -> void:
	recharge()
