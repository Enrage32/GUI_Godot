# Instructions (English Version)

## Starting

Create project -> Enter Project Name -> "Create Folder" is On -> Open Project

For organizing files create folders Assets, Scenes, Scripts. In Assets create another folder called Sprites.
FileSystem (in the left bottom corner) -> Right click on res:// -> Create Folder

Download Assests from Github repository and now drag downloaded folders right into Project's Assets in Godot.

Now we are ready to create our first scene.

## Creating Player

Let's start with creating a Player.


### How to create a scene
When you just started a new Project, you should be already in a new Scene. Later to Add a New Scene you need to Press a Plus Button next to your already created Scene in the top panel. It looks like just opening a new tab in the browser. Always Save Scene with Ctrl + S after creating it.

### How to create a node
In the left tab called Scene you will find a Plus Button.
Now you need to press a Plus in the left tab called Scene OR press Ctrl + A to Add a Node. If this is our first Node in the Scene then it is a Root Node. A Scene can have only one Root Node. To Add Children Nodes first you need to choose in the left tab a Parent Node and then press Plus or Ctrl + A to Add a Node.

Create CharacterBody2D as a Root Node -> Create AnimatedSprite2D and CollisionShape2D as Children Nodes of CharacterBody2D

Now we will modify our created Nodes:

AnimatedSprite2D

### How to create animations
Choose AnimatedSprite2D in the left tab (Scene). In the right tab (Inspector) you should see "Sprite Frames - empty". Click on "empty" and choose
SpriteFrames. Now press SpriteFrames, and you will see Animations Panel in the bottom tab. If you're creating a first animation for this player you will see "default" animation, with which you can work already. If you need to Add a New Animation, press "Paper with a Plus" Button. Rename Animations by double-clicking them. Next step is Adding Frames. Choose Animation and Press a Grid Button (Add Frames from Sprite Sheet). Go to Assets/Sprites and choose Sprite Sheet for your Node. Before choosing Frames, we need to set Sprite Sheet correctly. Define how many horizontal and vertical lines are there. Choose the Frames that will be in your Animation, be aware to choose them in the right order. Change Animation Speed by entering another amount of FPS. Looping is enabled by default, you can disable it by Pressing a Loop Button. You can tell an Animation to Play on Load by Pressing "A>" Button. In Animation Frames you can press Play to Check the Animation.

Create "idle" Animation. Change Animation Speed to 10 FPS. Enable Play on Load. For now our AnimatedSprite is blurry, so let's fix it. In the top panel go to Project -> Project Settings -> Go to Rendering in the left navigation menu -> Textures -> Default Texture Filter -> Change to Nearest

CollisionShape2D

### How to add collision
Choose CollisionShape2D in the left tab (Scene). In the right tab (Inspector) you should see "Shape - empty". Click on "empty" and choose Shape that fits the most for your Node. After this it will appear on your screen and you can resize and reposition it. Choose easy shapes and don't try too hard, it's okay if AnimatedSprite will have bigger boundaries than the CollisionShape.

Choose a CapsuleShape as a CollisionShape and resize it for Character.

Before going further let's save our Character as a Scene. Rename it in the Scene tab and press Ctrl + S.

### How to add a Script
Choose Node in the left tab (Scene) and Press "Script with Plus" Button to Attach a New or Existing Script to the Selected Node. You can enable Templates to use Template or disable and write Script from scratch.

Add a New Script for CharacterBody2D and disable Template to learn how to write Scripts by yourself.

### How to connect a button with an Action?
In the top panel press Project -> Project Settings -> Input Map. In the field "Add New Action" type in the name of your Action and press Add. Now press Plus Button which is right to Action to Add Event. Now you can simply Press a desired Button because the appeared window is Listening for Input and then press Continue. You can choose several Keys for one Action. Later in the Script you can check if the Action was pressed by typing in "Input.is_action_just_pressed(NAME OF ACTION)" in the function "_process(delta)" or "_physics_process(delta)", so Script would test it every frame.

Add "move_left", "move_right", "jump" Actions.

Now let's go to Player's Script and write logic.


```
extends CharacterBody2D

const SPEED = 200
const JUMP_VELOCITY = -350

func _physics_process(delta: float) -> void:

  if not is_on_floor():
    velocity += get_gravity() * delta

  if Input.is_action_just_pressed("jump") and is_on_floor():
    velocity.y = JUMP_VELOCITY

  var direction := Input.get_axis("move_left", "move_right")

  if direction:
    velocity.x = SPEED * direction
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)

  move_and_slide()

```


## Creating World

A little warning beforehand. We will need to create a world within a bottom right quarter of game, so later we could properly connect our background to the world.

Add a New Scene - Choose 2D Scene - Add TileMapLayer as a Child Node. Save the Scene with Ctrl + S

TileMapLayer:
In the Inspector tab you will see "Tile Set - empty". Click on "empty" and Choose TileSet. Click on it and below Change Tile Size to 24 px. This is the size of the tiles in our TileMap.
In the bottom panel you will see TileSet and TileMap. Tile Set is for configuration, Tile Map is for painting. Now we need Tile Set. Drag an Image with TileSet from folder Assets (in File Manager) to Tile Sources. Click yes, so it will automatically detect Tiles. Let's check if it did the good job. If we need to erase some tiles, choose Eraser Tool or press E, and Click on those Tiles. Otherwise you will need Setup Tool to Add new Tiles. If you want to create Big Tiles, Hold Shift. Be aware that for Big Tiles you need to check the pivot of the Tile (orange borders). Go to Select -> Choose a problematic Tile -> Rendering -> Change Texture Origin.

After we chose our tiles from Tile Set Sheet, we need to give them collision and physics. Go to Inspector -> Click on TileSet -> Physics Layers -> Add Element. Now go to TileSet in the bottom panel -> Select -> Physics -> Physics Layer 0.
There we define the Collision Shape of Tiles. Select an entire Map of Tiles and Press F to give them default Tile Shape. Now we want to change Tile Shape for Big Tiles. We will do this manually by adding/moving/deleting points.

Now we start painting the level. Press TileMap and select Tiles and place them. You can choose a Rectangle Tool to paint a big area of Tiles.

## Dragging Player to the World

Now find "player.tscn" in File Manager, drag him to the World Scene and place him on some platfrom you created before. Add Camera2D as a Child Node of Player. Place Camera higher than the player. In Inspector Tab you will need to change this: "Zoom" 2.5x, "Position Smoothing" On, in Limit "Smoothed" needs to also be On, "Process Callback" Physics. We need the last change so the World will not seem blurry later.

Add Player an Animation for Running. (Player Scene - AnimatedSprite2D - New Animation - Grid - Select Frames - Rename - Set Frame Speed - Go to Script)

Now in the Script we will write when which Animation will be playing. First of all, drag AnimatedSprite into the Script holding Ctrl. This will create a variable referencing to AnimatedSprite. @onready is needed so the script would reference this variable only if it exists already.

```
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
```

Now in _physics_process(delta) we write a condition for playing animation.

```
if direction:
    animated_sprite.play("run")
else:
    animated_sprite.play("idle")
```
Also we want to change our direction we are looking in animation. Also in _physics_process(delta) we write:

```
if direction > 0:
    animated_sprite.flip_h = false
elif direction < 0:
    animated_sprite.flip_h = true
```
## Creating a Background

In this project the Background consists of several images. We want them to be layered for a beautiful animation of transition and we want the Background to repeat itself infinitely. This is why we need Parallax.

Add a New Scene -> Choose 2D Scene -> Add Parallax2D as Child Nodes -> Add Sprite2D for Parallax2D as it's Child Node

We will configure our Sprite2D and Parallax2D and after we are ready we will duplicate Parallax2D two times, so there would be three Parallax2D.

Sprite2D:

In the Inspector tab you will see "Texture - empty". Drag there the corresponding Image from File Manager. Offset -> Centered should be disabled. Rescale the size of Sprite2D so it would be like the area of Parallax2D (the blue rectangle).


Parallax2D:
Now we want to create a feeling like the Background has depth in it. For this go to the Inspector tab for Parallax2D and change Scroll Scale (both x and y). Let the Back Parallax2D have 0.2 Scroll Scale, Mid will have 0.5 and Front 1.0. The furthest layer will have the lowest value. For our Background to repeat itself, go to Repeat -> RepeatSize -> Set the Value of the Screen Width (1152.0 by default).

Duplicate Parallax2D, for each layer rename them to (Back, Mid, Front), drag corresponding images to Sprite2D and change Scroll Scale to (0.3, 0.5, 1.0).

Don't forget to save our Background as a Scene and drag it to the World. The Background should be in the lowest right quarter with it's top left corner being in (0,0) coordinates. So this is why we were creating our World and placing Player in the bottom right quarter.


Let's also limit our Camera view, so it won't see how background ends. Click on Camera in Scene and in the Inspector tab -> Limit -> set Bottom to 650 px.

## Killzone

Why do we need killzone? Falling from map, spikes, lava would have the same killzone, because they are killing player and they can share this killzone.
Create a new Scene -> Add a Node Area 2D -> Rename to Killzone


Next step is Signal.

### How to connect a Signal?

In the right tab choose Signals tab (near Inspector tab) -> Click on a Signal that you need -> Choose the Node that needs to react after receiving this Signal (Node needs to have already created Script for this) -> Connect.

Connect body_entered Signal to the Killzone Script. Body that will enter our killzone will be our player, to detect only player we need to change layers of collision. Killzone must have Mask = 2. Mask is located in Inspector -> Collision. For now we will write body.get_hit(), then go to Player and add get_hit() function.

Killzone's Script will look like this:

```
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("get_hit"):
		body.get_hit()

```

Go to Player's Scene. In the Inspector tab change Layer of Collision -> Collision (under CollisionObject2D) -> Layer = 2.
Go to Player's Script. Create variable health and function get_hit. For now just write down health -= 1, and check with print that it works.

```
var health = 3

  func get_hit():
    health -= 1
	  print(health)

```

Let's add killzone to our game and check if it works. Drag Killzone to our Scene. Add to Killzone CollisionShape2D as a Child Node and choose as a Shape WorldBoundary.
Arrow of WorldBoundary needs to look up. And we will put Killzone on the line where Background ends.

## Respawn

For now let's create a method for respawning.

Our Player will have three lives. If he loses a life, he will be just respawned in the beginning of the level. If he loses all three lifes, the whole level will be reloaded with this function:

```
get_tree().reload_current_scene()

```

For a normal respawning we need to save our default spawn position. In func _ready() we say that spawn_position is our current position. Function _ready() is being called once in the beginning when both the node and its children have entered the scene tree. This is why spawn_position saves the start position of the Character.

New functions:
```
func _ready() -> void:
	spawn_position = position


func respawn():
	if health > 0:
		position = spawn_position
	else:
		get_tree().reload_current_scene()
```
Edit functions:
```
  func get_hit():
    health -= 1
	  respawn()
```

Now we respawn too quickly and without animation (I know that we won't see the animation if we're falling off map, but we will need this for interaction with Mob later). Let's add animation for getting hit and after finishing playing the animation Character will respawn.

Go to Player Scene and create a new animation for Dying, for this animation disable looping. Now go to Player's Script and create variable getting_hit. This variable will represent if a Character just took damage. This will help us to play Animation correctly. Without this variable if we just played Animation in our get_hit() function, it would only play one frame of Animation. Also we will need to edit some functions, for example, _physics_process, so it would play the Animation. When the Animation finishes playing, Player will respawn. In addition to this we will stop player from moving around when he takes damage, but still let him fall down with move_and_slide().

New:
```
var getting_hit = false

func _on_animated_sprite_2d_animation_finished() -> void:
	var finished_animation = animated_sprite.animation
	if finished_animation == "get_hit":
		respawn()
```

Edit:
```

func get_hit():
	getting_hit = true
	health -= 1

func respawn():
    if health > 0:
      position = spawn_position
      getting_hit = false
    else:
      get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
  if not is_on_floor():
    velocity += get_gravity() * delta

  if getting_hit:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    animated_sprite.play("get_hit")
    move_and_slide()
    return


  if Input.is_action_just_pressed("jump") and is_on_floor():
    velocity.y = JUMP_VELOCITY

  var direction := Input.get_axis("move_left", "move_right")

  if direction > 0:
    animated_sprite.flip_h = false
  elif direction < 0:
    animated_sprite.flip_h = true

  if direction != 0:
    animated_sprite.play("run")
  else:
    animated_sprite.play("idle")


  if direction:
    velocity.x = SPEED * direction
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)

  move_and_slide()

```

For _on_animated_sprite_2d_animation_finished() to work, we need to connect a Signal. Go to the Player Scene -> in the right tab go to Signals (next to the Inspector) -> Connect animation_finished to the Player.

## Jumping

Add Animation for jumping. (Player Scene -> AnimatedSprite -> Add Animation -> Jump -> Choose frames -> Disable loop)
Go to Player's Script. If Player not is_on_floor() then play Animation jump. We can write it above idle and running Animations.

Edit in _physics_process(delta)
```
if not is_on_floor():
    animated_sprite.play("jump")
elif direction:
  ...
```

Now we can see that our player could fall off the edge of the platform. To solve this we will add Coyote time.

For a Coyote time we need to create a Timer for our player. So in Player Scene, player + ctrl_a + Timer, to create a Timer as a Child Node of PLayer.
Let's rename it to CoyoteJump.
Now in the Inspector tab let's make it Wait Time for a 0.12 second and enable one_shot, so it will processed once. After that we will move to a Player's Script, where we should define our Timer by dragging it in our code with pressed Ctrl. In our _physics_process we will create a new variable on_floor that should be before move_and_slide function. And after move_and_slide we will add a new if statement (if on_floor and !is_on_floor(): -> coyote_jump.start()). It will look like this:

Edit in _physics_process(delta)
```

	var on_floor = is_on_floor()

	move_and_slide()

	if on_floor and !is_on_floor():
		coyote_jump.start()

```

The reason why we did this is that is_on_floor() function updates after move_and_slide, so we are comparing two close states that go one after another of our Player and turn on the Timer.
After that we should change a little our jumping logic. We will check not only is_on_floor(), but also if the timer of Coyote time has not ended yet. ((is_on_floor() or !coyote_jump.is_stopped()))

Edit in _physics_process(delta)
```

	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_jump.is_stopped()):
		velocity.y = JUMP_VELOCITY

```


## Mob

Now let's create a mob.
Create a New Scene -> CharacterBody2D -> Add Nodes AnimatedSprite2D, CollisionShape2D, two RayCast2D, Killzone (the one we have created earlier) as Children of CharactedBody2D. We will need RayCast so Mob could move around and bounce off the barriers. For this specific reason we will add to the Game Scene invisible blocks which will have Collision Layer = 3. Then RayCast will have Collision Mask Layer also 3. Invisible block will be a StaticBody with CollisionShape. RayCast's arrows will look right and left and need to be short, the exact time when the point of the arrow will be colliding, our Mob will change it's direction. Now create a Script for mob. As already was said, when RayCast is colliding mob will change direction of it's movement. Also in AnimatedSprite create Animation for running and enable AutoPlay for it because our Mob will always be moving from the start.

```

const SPEED = 50
class_name Slime            #we need this so a player could identify mob later for attacks

@onready var left_cast: RayCast2D = $Left_cast
@onready var right_cast: RayCast2D = $Right_cast
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction = 1

func _physics_process(delta: float) -> void:

	if right_cast.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	elif left_cast.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

	position.x += direction * SPEED * delta

```
## Attack

First of all, let's create an Animation for Player's Attacking. Secondly, we need to Add a New Action in Input Map, so create "attack" and bind it on Left Mouse Button. Now in Player's Script create variable `attacking` to check if a button was pressed. We will check it in _physics_process(delta) if the Action was Pressed. Also we are going to stop Character's movement if he is Attacking (we won't change the Player's current velocity before Attack if he's already mid-air so he won't fell off while jumping). And we can Add a CoolDown on Player's Attack by Adding a Timer - Add a Timer as a Child Node of Player and rename it to AttackTimer. Change Wait Time to 0.3s and make it One Shot.

New:
```
var attacking = false
@onready var attack_timer: Timer = $AttackTimer
```

Edit:
```

func _on_animated_sprite_2d_animation_finished() -> void:
  var finished_animation = animated_sprite.animation
  if finished_animation == "get_hit":
    respawn()
  elif finished_animation == "attack":
    attacking = false
    attack_timer.start()
```

Edit in _physics_process(delta):

```
if getting_hit:
  ...

if Input.is_action_just_pressed("attack") and attack_timer.is_stopped():
    attacking = true

if attacking:
    if is_on_floor():
      velocity.x = move_toward(velocity.x, 0, SPEED)
    animated_sprite.play("attack")
    move_and_slide()
    return
```

Now we need to add Hitbox and Hurtbox. We're going to add Hitbox to the Player and Hurtbox to the Mob.

### Hitbox for Player
Go to Player's Scene -> Add Area2D as a Child Node of Player -> Add CollisionShape2D as a Child Node of Area2D. This Area2D will be our HitBox, rename it. Choose RectangleShape for HitBox. To place it correctly start playing the Animation of Attacking. This will help you to reposition. But now there is a problem that our Hitbox is always facing right, we need to flip it as we do with AnimationSprite. Let's create for this purposes a Pivot for flipping AnimatedSprite and Hitbox. Add a Node2D as a Child Node of Player -> Rename to Pivot -> Reposition AnimatedSprite and Hibox so they would be Children Nodes of Pivot. Now we need to flip only Pivot and AnimatedSprite and Hitbox will flip automatically with it.

New:
```
@onready var pivot: Node2D = $Pivot
```

Edit (animated_sprite has changed it's path):
```
@onready var animated_sprite: AnimatedSprite2D = $Pivot/AnimatedSprite2D
```

Edit in _physics_process(delta):

```
(Instead of
  if direction > 0:
    animated_sprite.flip_h = false
  elif direction < 0:
    animated_sprite.flip_h = true)

if direction != 0:
    pivot.scale.x = direction
```

Also important thing! The Player's Hitbox won't be enabled always, we will enable CollisionShape of Hitbox only if Player is currently attacking. When we enable Hitbox and something appears to be in our Hitbox, it counts like it has entered the area of Hitbox. So by default it will be turned off. To do this, we can go to the Inspector tab of the CollisionShape inside HitBox and Press Disabled - On.
In the Script later we will define when we will enable/disable the CollisionShape. Now let's go to the Signals of Hitbox in the right tab, Click on the Signal _area_entered(area) and Connect it to the Player's Script. Now in the Script we write this:

New:
```
@onready var collision_hitbox: CollisionShape2D = $Pivot/Hitbox/CollisionShape2D

func _on_hitbox_area_entered(area: Area2D) -> void:
  var body = area.get_parent()
  if body is Slime:             #because Mob has a class_name Slime
    body.take_damage()
```

Edit:
```
func _on_animated_sprite_2d_animation_finished() -> void:
  var finished_animation = animated_sprite.animation
  if finished_animation == "get_hit":
    respawn()
  elif finished_animation == "attack":
    attacking = false
    attack_timer.start()
    collision_hitbox.disabled = true
```


Edit in _physics_process(delta):
```
if attacking:
    if is_on_floor():
      velocity.x = move_toward(velocity.x, 0, SPEED)
    animated_sprite.play("attack")
    collision_hitbox.disabled = false
    move_and_slide()
    return
```

### Hurtbox for Mob
Go to Mob's Scene and create Animation for Mob's death. After the Animation finished playing we will erase Mob from the Scene with queue_free(). Let's add a Mob HurtBox so it would be easier for Player to kill it. Same way: Area2D with a CollisionShape inside. Now in Mob's Script we need to write function take_damage() and also a variable died. We need this variable, so a Mob can't kill us while it's running the Animation of Dying. For _on_animated_sprite_2d_animation_finished() to work, we need to Connect a Signal to this Script.

```
extends CharacterBody2D

class_name Slime

const SPEED = 50

@onready var left_cast: RayCast2D = $Left_cast
@onready var right_cast: RayCast2D = $Right_cast
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone_collision: CollisionShape2D = $Killzone/CollisionShape2D

var direction = 1
var died = false

func _physics_process(delta: float) -> void:

  if died:
    animated_sprite.play("die")
    killzone_collision.disabled = true
    return


  if right_cast.is_colliding():
    direction = -1
    animated_sprite.flip_h = true
  elif left_cast.is_colliding():
    direction = 1
    animated_sprite.flip_h = false

  position.x += direction * SPEED * delta

func take_damage():
  died = true

func _on_animated_sprite_2d_animation_finished() -> void:
  var finished_animation = animated_sprite.animation
  if finished_animation == "die":
    queue_free()

```



## Collectibles

Now let's add collectibles. We will collect emeralds. New Scene - Area2D, rename to Emerald - Add Animated Sprite, CollisionShape as Children Nodes of Emerald. Create an Animation of Spinning, Autoplay is on. Now create a Script of Emerald. Go to Signals -> _body_entered -> Connect to Emerald's Script. Also in the Inspector put a Collision Mask Layer = 2, so it would detect only Player.

New:
```

func _on_body_entered(body: Node2D) -> void:
	body.pick_emerald()
	queue_free()

```

Now in Player's Script we need to save the Emerald. For this write:

New:
```
var emeralds = 0

func pick_emerald():
  emeralds += 1
```

## UI

Now let's add UI for showing the amount of Lives and Emeralds. New scene -> CanvasLayer -> Two Labels as Children Nodes of CanvasLayer. Put them in the corners and type in the Text Field: Lives: X, Emeralds: X correspondingly. To change Font: Label - Inspector Tab - Theme Overrides - Font - Drag there Font from the File Manager. In Theme Overrides you can play with fonts, outliners, colors etc. Now let's create script for UI. Also we will need to create two custom Signals in Player's Script, that will ask UI to update it's labels. Signal update_emeralds(emeralds), signal update_health(health). To call them we will write update_health.emit(health). In the right tab Signals of the Player connect these Signals to UI. You need to add UI to the Game Scene already and choose Player in Game scene to connect a Signal to UI. In the UI's Script drag Labels with a pressed Ctrl for creating variables. With these Custom Signals we can pass variables. Also we will emit the signal inside our _ready function, so we will pass UI our starting variables. But for this to work UI needs to be higher in the Scene tree than the player, it's because of how _ready() function works.

Inside Player's Script:

New:
```
  signal update_health(health)
  signal update_emeralds(emeralds)
```

Edit:

```
  func pick_emerald():
    emeralds += 1
    update_emeralds.emit(emeralds)

  func respawn():
    if health > 0:
      position = spawn_position
      getting_hit = false
      update_health.emit(health)
    else:
      get_tree().reload_current_scene()

  func _ready():
    update_health.emit(health)
    update_emeralds.emit(emeralds)
```


Inside UI's Script:
```

  @onready var health_label: Label = $Health
  @onready var emeralds_label: Label = $Emeralds

  func _on_player_update_emeralds(emeralds: Variant) -> void:
    emeralds_label.text = "Emeralds: " + str(emeralds)


  func _on_player_update_health(health: Variant) -> void:
    health_label.text = "Lives: " + str(health)
```


## Menu

Now let's add a Menu.
New scene - Node2D - Inside Node2D: ColorRect, VBoxContainer - Inside Contatiner: Two Buttons. To Buttons you can add font and sizing. To allign them well do this:
VBox - Layout - Container Sizing and Position. VBox - Theme Overrides - Constands - Separation 40.
Button - Layout - Container Sizing - Expand
Also we would manipulate a little with colorRect for an easier centralizing Lables etc.


Now script in Menu with Connected Signals. On button_down for every button you have. For play button we change tree: get_tree().chage_scene_to_file("path to scene of level_1").
For quit we type in: get_tree().quit(). Now we want to change the default main scene that will pop up. Project - Project Settings - General - Run - Choose menu scene.

```

func _on_quit_button_down() -> void:
	get_tree().quit()


func _on_start_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")


```

## Pause
Now pause! We will create a new scene and then make it part of UI.
For now it's the same. New scene - Node2D - ColorRect, VBoxContainer - Three Buttons. We can also add Label, to tell that the game is paused.
Now Script for Pause. Create an Action for Pausing. Connect Signals for Buttons to the Script.
Project - Project Settings - Input Map - New Action - Pause on Escape. Now we need _process function in Pause's Script that will check if Input.is_action_just_pressed("pause")


Pause's Script:

New:
```

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()
	elif Input.is_action_just_pressed("pause") and not get_tree().paused:
		pause()

```

But for it to work we also need to tell Pause to process Script always. Pause - Inspector tab - Process - Mode - Always. Let's create pause() and resume() functions. To pause/unpause game we need get_tree().paused. Also it will be in our UI node so we need variable visible to appear it on the Screen if needed. Logic of buttons: reload_current_scene if reload. change_scene if main menu.


Pause's Script:

New:
```

func pause():
	visible = true
	get_tree().paused = true

func resume():
	visible = false
	get_tree().paused = false

func _on_continue_button_down() -> void:
	resume()


func _on_reload_button_down() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_main_menu_button_down() -> void:
	resume()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

```

* All the manual was created w/o AI