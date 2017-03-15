package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.ui.Keyboard;
	import ws.tink.display.HitTest;
	
	/**
	 * ...
	 * @author Ryan
	 */
	public class Main extends MovieClip 
	{
		//player varibles
		var player:MovieClip;
		var playerLoc1:Array = [20, 1];
		var playerLoc2:Array = [2, 1];
		
		//stars varibles
		var star:MovieClip;
		var star2:MovieClip;
		var star3:MovieClip;
		var star1Loc1:Array = [1, 23];
		var star2Loc1:Array = [10, 1];
		var star3Loc1:Array = [18, 23];
		var star1Loc2:Array = [19, 2]; 
		var star2Loc2:Array = [2, 21]; 
		var star3Loc2:Array = [16, 10]; 
		
		//menus
		var menu:MovieClip;
		var endScreen:MovieClip;
		
		//door varibles
		var door:MovieClip;
		var doorLoc1:Array = [2, 1];
		var doorLoc2:Array = [21, 23];
		
		//map varibles
		var map:Array;
		var tileArray:Array;
		var map1:Array;
		var map2:Array;
		var tileMap:Array;
		
		//const
		const TILE_SIZE:int = 20;
		
		//movement
		var speed:Number = 5;
		var ySpeed:Number = Infinity;
		var gravity:int = 1;
		var jumpStart:Number = -10;
		
		//booleans
		var shouldKillPlayer:Boolean = false;
		var hit:Boolean = false;
		
		//level number
		var level:int = 1;
		//var level:int = 2;

		//star collecting
		var starCollected:int = 0;
		var totalStarCollected:int = 0;
		
		//death counter
		var deathCounter:int;
		var death:MovieClip;
		
		//sound
		var soundArray:Array;
		var sound:Sound;
		var soundNum:int = 0;
		
		public function Main() 
		{
			init();
		}
		
		private function init():void 
		{
			if (level == 1) ArrowKeyInput.Init(stage);
			createGrid();
			createPlayer();
			createDeathCounter();
			createDoor();
			createStars();
			if(level == 1) createMenu();
		}
		
		private function createDeathCounter():void 
		{
			if (!death) death = new Death();
			death.x = 0;
			death.y = 0;
			addChild(death);
		}
		
		private function createStars():void 
		{
			var starCollected:int = 0;
			
			if (!star) star = new Star();
			if (level == 1)
			{
				star.x = star1Loc1[1] * TILE_SIZE;
				star.y = star1Loc1[0] * TILE_SIZE;
			}
			else
			{
				star.x = star1Loc2[1] * TILE_SIZE;
				star.y = star1Loc2[0] * TILE_SIZE;
			}
			addChild(star);
			
			if (!star2) star2 = new Star();
			if (level == 1)
			{
				star2.x = star2Loc1[1] * TILE_SIZE;
				star2.y = star2Loc1[0] * TILE_SIZE;
			}
			else 
			{
				star2.x = star2Loc2[1] * TILE_SIZE;
				star2.y = star2Loc2[0] * TILE_SIZE;
			}
			addChild(star2);
			
			if (!star3) star3 = new Star();
			if (level == 1)
			{
				star3.x = star3Loc1[1] * TILE_SIZE;
				star3.y = star3Loc1[0] * TILE_SIZE;
			}
			else
			{
				star3.x = star3Loc2[1] * TILE_SIZE;
				star3.y = star3Loc2[0] * TILE_SIZE;
			}
			addChild(star3);
		}
		
		private function createDoor():void 
		{
			if(!door) door = new Door();
			addChild(door);
			if (level == 1)
			{
				door.x = doorLoc1[1] * TILE_SIZE;
				door.y = doorLoc1[0] * TILE_SIZE;
			}
			else
			{
				door.x = doorLoc2[1] * TILE_SIZE;
				door.y = doorLoc2[0] * TILE_SIZE;
			}
		}
		
		private function createMenu():void 
		{
			deathCounter = 0;
			death.DeathCounterTF.text = deathCounter;
			
			if (!menu) menu = new TitleScreen();
			addChild(menu);
			menu.x = (stage.stageWidth / 2) - (menu.width / 2);
			menu.y = 150;
			stage.addEventListener(MouseEvent.CLICK, start);
		}
		
		private function start(e:MouseEvent):void 
		{
			removeChild(menu);
			stage.removeEventListener(MouseEvent.CLICK, start);
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void 
		{
			movePlayer();
			checkHit();
		}
		
		private function checkHit():void 
		{
			//door
			hit = HitTest.complexHitTestObject(door, player);
			if (hit)
			{
				if (level == 2)
				{
					totalStarCollected += starCollected;
					starCollected = 0;
					soundNum = 0;
					createEndScreen();
				}
				else
				{
					totalStarCollected += starCollected;
					starCollected = 0;
					level = 2;
					soundNum = 0;
					init();
				}
			}
			
			//stars
			hit = HitTest.complexHitTestObject(player, star);
			if ( hit)
			{
				starCollected++;
				removeChild(star);
			}
			hit = HitTest.complexHitTestObject(player, star2);
			if ( hit)
			{
				starCollected++;
				removeChild(star2);
			}
			hit = HitTest.complexHitTestObject(player, star3);
			if ( hit)
			{
				starCollected++;
				removeChild(star3);
			}
		}
		
		private function createEndScreen():void 
		{
			level = 1;
			
			if(!endScreen) endScreen = new EndScreen();
			addChild(endScreen);
			endScreen.x = (stage.stageWidth / 2) - (endScreen.width / 2);
			endScreen.y = 150;
			endScreen.deathNumberTF.text = deathCounter;
			endScreen.starNumberTF.text = totalStarCollected;
			
			removeChild(player);
			removeEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(MouseEvent.CLICK, mainMenu);
		}
		
		private function mainMenu(e:MouseEvent):void 
		{
			removeChild(endScreen);
			stage.removeEventListener(MouseEvent.CLICK, mainMenu);
			totalStarCollected = 0;
			init();
		}
		
		private function killPlayer():void 
		{
			deathCounter++;
			if (deathCounter > 999999999)
			{
				deathCounter = 1000000000;
			}
			death.DeathCounterTF.text = deathCounter;
			
			if (level == 1)
			{
				player.x = playerLoc1[1] * TILE_SIZE;
				player.y = playerLoc1[0] * TILE_SIZE;
			}
			else
			{	
				player.x = playerLoc2[1] * TILE_SIZE;
				player.y = playerLoc2[0] * TILE_SIZE;
			}
			
			createStars();
			starCollected = 0;
			ySpeed = 0;
			shouldKillPlayer = false;
		}
		
		private function movePlayer():void 
		{
			var newX:Number = player.x;
			var newY:Number = player.y;
			var playerCol:int;
			var playerRow:int;
			
			if (ArrowKeyInput.left)
			{
				newX -= speed;
				if (!checkCorners(newX, newY))
				{
					playerCol = player.x / TILE_SIZE;
					newX = playerCol * TILE_SIZE;
				}
			}
			if (ArrowKeyInput.right)
			{
				newX += speed;
				if (!checkCorners(newX, newY))
				{
					playerCol = (newX + player.width) / TILE_SIZE;
					newX = (playerCol * TILE_SIZE) - player.width;
				}
			}	
			
			playerJumping(newX, newY);
		}
		
		private function playerJumping(newX:Number, newY:Number):void 
		{
			var PlayerRow:int;
			
			var TileLocX:int;
			var TileLocY:int;
			
			if (ySpeed == Infinity)
			{				
				playSound();
				ySpeed = jumpStart;
			}
			
			if (ySpeed != Infinity)
			{
				if (ySpeed >= 22) ySpeed = 22;
				else ySpeed += gravity;
				newY += ySpeed;
				
				if (!checkCorners(newX, newY))
				{
					if (ySpeed >= 0)
					{
						PlayerRow = (newY + player.height) / TILE_SIZE;
						newY = (PlayerRow * TILE_SIZE) - player.height;
						ySpeed = Infinity;
					}
					else
					{
						PlayerRow = player.y / TILE_SIZE;
						newY = PlayerRow * TILE_SIZE;
						ySpeed = 0;
					}
				}
			}
			
			player.x = newX;
			player.y = newY;
			if (shouldKillPlayer) killPlayer();
		}
		
		private function playSound():void 
		{
			soundArray = [C1, D, E, F, G, A, B, C2];
			var className:Class = soundArray[soundNum];
			sound = new className();
			sound.play();
			if (soundNum >= soundArray.length - 1)
			{
				soundNum = 0;
			}
			soundNum++;
		}
		
		private function checkCorners(newX:Number, newY:Number):Boolean 
		{
			var leftX:int = newX / TILE_SIZE;
			var rightX:int = (newX + player.width - 1) / TILE_SIZE;
			var upY:int = newY / TILE_SIZE;
			var downY:int = (newY + player.height - 1) / TILE_SIZE;
			
			var upLeftTile:Tile = tileMap[upY][leftX];
			var upRightTile:Tile = tileMap[upY][rightX];
			var downLeftTile:Tile = tileMap[downY][leftX];
			var downRightTile:Tile = tileMap[downY][rightX];
			
			if (upLeftTile.isDeadly || upRightTile.isDeadly || downLeftTile.isDeadly || downRightTile.isDeadly)
			{
				shouldKillPlayer = true;
				return true;
			}
			
			var upLeft:Boolean = upLeftTile.isEmpty;
			var upRight:Boolean = upRightTile.isEmpty;
			var downLeft:Boolean = downLeftTile.isEmpty;
			var downRight:Boolean = downRightTile.isEmpty;
			
			return upLeft && upRight && downLeft && downRight;
		}
		
		private function createGrid():void 
		{
			tileArray = [Tile0, Tile1, SpikeTile];
			
			map1 = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
					[0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0],
					[0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0],
					[0, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 0, 2, 2, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0],
					[0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0],
					[0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0],
					[0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0],
					[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]];
					
			map2 = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 2, 0],
					[0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
					[0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
					[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0],
					[0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 0],
					[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]];

			if (level == 1) buildMap(1);
			else 
			if (level == 2) buildMap(2);
		}
		
		private function buildMap(MapNum:int):void 
		{	
			map = this["map" + MapNum];
			tileMap = [];
			
			for (var i:int = 0; i < map.length; i++) 
			{
				var row:Array = map[i];
				var newRow:Array = [];
				tileMap.push(newRow);
				
				for (var j:int = 0; j < row.length; j++) 
				{
					var tileNum:int = row[j];
					var className:Class = tileArray[tileNum];
					var tile:Tile = new className();
					addChild(tile);
					tile.x = tile.width * j;
					tile.y = tile.height * i;
					newRow.push(tile);
				}
			}
		}
		
		private function createPlayer():void 
		{
			if(!player) player = new Player();
			addChild(player);
			if (level == 1)
			{
				player.y = playerLoc1[0] * TILE_SIZE;
				player.x = playerLoc1[1] * TILE_SIZE;
			}
			else
			{
				player.y = playerLoc2[0] * TILE_SIZE;
				player.x = playerLoc2[1] * TILE_SIZE;
			}
		}
	}
}