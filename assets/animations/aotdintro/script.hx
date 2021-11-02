
var bitches = 4;
var ball;

trace("i love women\n\t-bbpanzu");

function frame(){
	//setP(self,"y",y + 1);
	//trace(curFrame);
	
	if (curFrame > 326){
		setP(self,'x', FlxG.random.int( -2, 2));
		setP(self,'y', FlxG.random.int( -2, 2));
	}
	if (curFrame > 535){
		setP(self,'alpha', getP(self,'alpha')-0.15);
	}
	
	if (curFrame == 60 && Game.players.length > 0){
		ball = copy(Game.players[0]._lasthitted.sprite);
		ball.color = 0xFF000000;
	}
	
}

/*
 
setP(target,variable:string,value) // sets a variable from the target
getP(target,variable) //gets a variable from the target




*/



function update(){
	//setP(self,"x",x + 1);
	//trace("i eat hoes for breakfast");
	
}

function end(){
	
	//FlxG.resetGame();
}

bitches;