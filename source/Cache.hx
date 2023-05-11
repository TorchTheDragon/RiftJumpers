package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import lime.app.Application;
import openfl.display.BitmapData;
import openfl.utils.Assets;
import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
#if windows
import Discord.DiscordClient;
#end
#if cpp
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class Cache extends MusicBeatState
{
    public static var bitmapData:Map<String, FlxGraphic>;
    public static var bitmapData2:Map<String, FlxGraphic>;

    var images = [];
    var music = [];

    // Additional Folders
    var mainMenu = [];
    var customNotes = [];
    var splashes = [];
    var specialNotes = [];

    var loadingText:FlxText;
    var loadingMessage:String = 'Caching';   
    var toBeLoaded:String = ''; 

    var totalNum:Int = 0;
    var totalLoaded:Int = 0;

    var bar:FlxBar;

    override function create()
    {
        FlxG.mouse.visible = false;

        FlxG.worldBounds.set(0, 0);

        bitmapData = new Map<String,FlxGraphic>();
		bitmapData2 = new Map<String,FlxGraphic>();

        var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('loadingscreen-' + FlxG.random.int(1, 4), 'loadingscreens')); // Change the max number when adding more screens
        menuBG.screenCenter();
        add(menuBG);

        #if cpp
		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
		{
			if (!i.endsWith(".png"))
				continue;
			images.push(i);
		}

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/customnotes/images")))
		{
			if (!i.endsWith(".png"))
				continue;
			customNotes.push(i);
		}

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/mainmenu/images")))
		{
			if (!i.endsWith(".png"))
				continue;
			mainMenu.push(i);
		}

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/customnotes/images/specialNotes")))
		{
			if (!i.endsWith(".png"))
				continue;
			specialNotes.push(i);
		}

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/customnotes/images/splashes")))
		{
			if (!i.endsWith(".png"))
				continue;
			splashes.push(i);
		}

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
		{
			music.push(i);
		}
		#end
        
        totalNum = Lambda.count(images) + 
                   Lambda.count(mainMenu) + 
                   Lambda.count(customNotes) + 
                   Lambda.count(specialNotes) + 
                   Lambda.count(splashes) + 
                   Lambda.count(music);

        bar = new FlxBar(0, FlxG.height - 50, LEFT_TO_RIGHT, Std.int(FlxG.width * 0.9), 20, this, 'totalLoaded', 0, totalNum);
        bar.screenCenter(X);
        bar.createFilledBar(0xFF2b2b2b, FlxColor.WHITE);
        add(bar);

        loadingText = new FlxText(0, bar.y - 50, 0, loadingMessage + '...', 12);
        loadingText.screenCenter(X);
        loadingText.scrollFactor.set();
		loadingText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(loadingText);

        sys.thread.Thread.create(() -> {
			cache();
			//fixPosition();
		});

        super.create();
    } 

    override function update(elapsed) 
    {
        super.update(elapsed);
    }

	function fixPosition()
	{
		loadingText.x = (FlxG.width/2) - (loadingText.width/2);
	}

    function cache()
    {
        #if !linux
		loadingText.text = loadingMessage + ' Fresh Voices...';
		fixPosition();

		var sound1:FlxSound;
		sound1 = new FlxSound().loadEmbedded(Paths.voices('fresh'));
		sound1.play();
		sound1.volume = 0.00001;
		FlxG.sound.list.add(sound1);

		loadingText.text = loadingMessage + ' Fresh Inst...';
		fixPosition();

		var sound2:FlxSound;
		sound2 = new FlxSound().loadEmbedded(Paths.inst('fresh'));
		sound2.play();
		sound2.volume = 0.00001;
		FlxG.sound.list.add(sound2);

		loadingText.text = loadingMessage + ' Characters...';
		fixPosition();
		
		for (i in images)
		{
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile("assets/shared/images/characters/" + i);
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			trace(i);
            totalLoaded++;
		}
		
		loadingText.text = loadingMessage + ' Main Menu Assets...';
		fixPosition();

        for (i in mainMenu)
		{
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile("assets/mainmenu/images/" + i);
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			trace(i);
            totalLoaded++;
		}

		loadingText.text = loadingMessage + ' Custom Note Assets...';
		fixPosition();

        for (i in customNotes)
		{
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile("assets/customnotes/images/" + i);
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			trace(i);
            totalLoaded++;
		}
		
		loadingText.text = loadingMessage + ' Special Note Assets...';
		fixPosition();

        for (i in specialNotes)
		{
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile("assets/customnotes/images/specialNotes/" + i);
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			trace(i);
            totalLoaded++;
		}
		
		loadingText.text = loadingMessage + ' Splashes Assets...';
		fixPosition();

        for (i in splashes)
		{
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile("assets/customnotes/images/splashes/" + i);
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			trace(i);
            totalLoaded++;
		}
		
		loadingText.text = loadingMessage + ' Music...';
		fixPosition();

		for (i in music)
		{
			var path = 'assets/songs/' + i;
            trace(i);
			FlxG.sound.cache(FileSystem.absolutePath(path + '/Inst'));
			FlxG.sound.cache(FileSystem.absolutePath(path + '/Voices'));
            totalLoaded++;
		}

		#end
		FlxG.switchState(new TitleState());
    }
}