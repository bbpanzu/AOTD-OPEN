package hud;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxStringUtil;

/**
 * ...
 * @author bbpanzu
 */
class PlayerHud extends FlxSpriteGroup
{
	public var nameTxt:FlxText = new FlxText(2, 1);
	public var coinTxt:FlxBitmapText;
	public var hpBar:FlxSprite;
	public var hpBarB:FlxSprite;
	public var mpBar:FlxSprite;
	public var mpBarB:FlxSprite;
	public var iconHP:FlxSprite;
	public var iconMP:FlxSprite;
	public var iconCoins:FlxSprite;
	public var _player:Player;
	public var bg:FlxSprite;
	
	public function new(player:Player) 
	{
		super();
		//var font = FlxBitmapFont.fromMonospace("assets/fonts/thickfont.png", "abcdefghijklmnopqrstuvwxyz0123456789$%.><- ", new FlxPoint(8, 16));
		coinTxt = new FlxBitmapText(Font.THICK);
		coinTxt.x = 11;
		coinTxt.y = 25;
		coinTxt.text = "0.00";
		bg = new FlxSprite().loadGraphic("assets/sprites/misc/playerhud.png");
		add(bg);
		x = 1 + (player.player - 1) * 120;
		y = 1;
	//	FlxTween.tween(this, {y: -40 * player.player}, 0.5 + 0.1 * player.player, {ease:FlxEase.linear,type:FlxTween.BACKWARD});
		_player = player;
		_player.playerhud = this;
	hpBar = new FlxSprite(12, 18).makeGraphic(100, 2, 0xFF00CC33);
	mpBar = new FlxSprite(12, 25).makeGraphic(100, 2, 0xFF0099FF);
	
	hpBarB = new FlxSprite(12, 18).makeGraphic(100, 2, 0xFF330000);
	mpBarB = new FlxSprite(12, 25).makeGraphic(100, 2, 0xFF000066);
	
		nameTxt.text = player.character.toUpperCase();
		nameTxt.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 1);
		add(nameTxt);
		add(coinTxt);
		add(hpBarB);
		add(mpBarB);
		add(hpBar);
		add(mpBar);
		
		hpBar.scale.x = _player._hp/_player._maxhp;
		mpBar.scale.x = _player.mp/100;
		hpBar.origin.x = 50;
		mpBar.origin.x = 50;
	}
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		hpBar.scale.x = _player._hp/_player._maxhp;
		mpBar.scale.x = _player.mp/100;
		hpBar.updateHitbox();
		mpBar.updateHitbox();
		
		if(!AOTD.playerData[_player.player - 1].dead)coinTxt.text = FlxStringUtil.formatMoney(_player.coins);
		if (AOTD.playerData[_player.player - 1].dead){
			bg.color.brightness = 0.5;
			coinTxt.text = "";
		}
		
	}
	
}