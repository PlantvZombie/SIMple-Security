extends Node2D

@export_category("Enemy Scenes")
@export var PlayerPath = preload("res://player.tscn")
@export var CitizenPath = preload("res://citizen.tscn")
@export var SoldierMeleePath = preload("res://soldier.tscn")
@export var SoldierRangedPath = preload("res://soldier_range.tscn")
@onready var Player:Node2D = $Player
@onready var Citizen:Node2D = $Citizen
@onready var SoldierMelee:Node2D = $SoldierMelee
@onready var SoldierRanged:Node2D = $SoldierRange2
@onready var marker:Node2D = get_node("Player/SpawnPoint")
@export_category("Wave Properties")
@export var waveOneCount = 10
@export var perSecond = 1.0
@export var amount = 1
@export_subgroup("Extra Properties")
@export var spawnTimer:Timer
var rng = RandomNumberGenerator.new()


var spawnEnemies = true
var spawnLocation
var enemyPerWave

func _ready() -> void:
	get_node("Inventory2").set_visible(false)
	Firewall()

func _process(_delta: float) -> void:
	################################################################################################
	#                                      Spawner                                                 #
	################################################################################################
	
	var side = randi_range(1, 4)
	var view = get_viewport().size
	var spawnX
	var spawnY
	var offset = Vector2(0,0)
	var offsetMulti = 0.05
	randomize()
	if side == 1:
		#TopSide
		Vector2(-100,0)
		spawnX = randi_range(0, view.x) 
		spawnY = 0
	elif side == 2:
		#RightSide
		offset = Vector2(0,100)
		spawnX = view.x
		spawnY = randi_range(0, view.y)
	elif side == 3:
		#BottomSide
		offset = Vector2(100,0)
		spawnX = randi_range(0, view.x)
		spawnY = view.y
	elif side == 4:
		#LeftSide
		offset = Vector2(0,-100)
		spawnX = 0
		spawnY = randi_range(0, view.y)
	marker.position = view + Vector2i(spawnX,spawnY)
	var timer = Timer.new()
	timer.start(1)
	if timer.is_stopped() == false:
		var instance = CitizenPath.instantiate()
		instance.position = Player.position
		add_child(instance)
	
	if timer.wait_time <= 0:
		timer.stop()
	
	################################################################################################
	#                                      Input                                                   #
	################################################################################################
	
	if Input.is_action_just_pressed("esc") and get_node("Inventory2").is_visible() == false:
		get_node("Inventory2").set_visible(true)
	elif Input.is_action_just_pressed("esc"):
		get_node("Inventory2").set_visible(false)
	get_node("Inventory2").position = get_node("Player").position


func Firewall():
	while Global.Attacks > 0:
		await get_tree().create_timer(600*pow(0.33, 1.16454726043*Global.itemlevel[4])).timeout
		rng.randomize()
		var enemies = get_tree().get_nodes_in_group("Enemies")
		var person = rng.randi_range(0, enemies.size()-1)
		enemies[person].Hp = 0
