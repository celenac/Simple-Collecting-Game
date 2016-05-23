//jumping instructions: http://ashbprocessing.blogspot.com/2013/04/second-stage-character-jumping-platforms.html


int x, y, groundY;
int mainSize=10; //white square's width and height
int yinc; //speed of upthrust for character jump
int isjumping=0; //flag to know if character is jumping or not
int groundColor=color(0);
boolean [] keys; //pressing two keys simultaneously
int collectablesArrayListSize=10;
ArrayList <Collectable> collectables =new ArrayList <Collectable>();
int [] randomYpositions;
int randomArrayLength=(int)((Math.random()*3)+2);
int [] randomXpositions;
int enemiesArrayListSize=1; //switch to zero on lvl 1
ArrayList <Enemy> enemies =new ArrayList <Enemy>();
int score=0;
int platformX;
int platformY;
int platformWidth=300;
void setup()
{
  size(1000, 600);
  x=width/2;
  y=390;
  groundY=390;
  noStroke();
  keys=new boolean [3];
  keys[0]=false;
  keys[1]=false;
  keys[2]=false;
  randomYpositions=new int [randomArrayLength];
  randomXpositions=new int [randomArrayLength];

  //creating random platform positions
  int i=1;
  randomXpositions[0]=(int)(Math.random()*(width-platformWidth));
  randomYpositions[0]=300;
  while(i<randomArrayLength)
  {
    do{
      platformX=newRandInt(platformX, width-platformWidth);
      randomXpositions[i]=platformX;
    }
    while(abs((randomXpositions[i]-randomXpositions[i-1]))>350);
    randomYpositions[i]=randomYpositions[i-1]-((int)(Math.random()*50)+50);
    i++;
  }
  
  for (int c=0; c<collectablesArrayListSize; c++)
  {
    collectables.add(new Collectable());
  }

  for (int e=0; e<enemiesArrayListSize; e++){
    enemies.add(new Enemy());
  }
}

public int newRandInt(int tempVar, int maxValue){
  tempVar=(int)(Math.random()*maxValue);
  return tempVar;
}

/* CURRENT TASKS!!!!:
1. red dots evenly spaced out
2. make randomXplatforms code clear
*/

void draw()
{
  background(200);

  //ground
  fill(groundColor);
  rect(-200, 400, width+200, 200);

  //drawing random platforms
  fill(groundColor);
  for (int i=0; i<randomArrayLength; i++)
  {
    rect(randomXpositions[i], randomYpositions[i], platformWidth, 20,4);
  }

  //little box
  fill(255);
  rect(x, y, mainSize, mainSize,3);

  //wrapping around screen
  if (x>width-mainSize) {x=0;}
  if (x<0) {x=width-mainSize;}

  //show score
  textSize(25);
  fill(0);
  text(score + "/" + collectablesArrayListSize, 20, 30);

  //collectables
  for (int c=0; c<collectables.size(); c++)
  {
    collectables.get(c).show();
    collectables.get(c).scoring();
    if ((x==collectables.get(c).getX() || x==collectables.get(c).getX()+1 || x==collectables.get(c).getX()+2 || x==collectables.get(c).getX()+3 || x==collectables.get(c).getX()+5) && y==collectables.get(c).getY())
    {
      collectables.remove(c);
    }
  }

  //enemies
  for(int e=0; e<enemies.size(); e++){
    enemies.get(e).show();
    enemies.get(e).move();
  }

  //pressing two keys simultaneously
  if (keys[0]==true) {x=x+3;}
  if (keys[1]==true) {x=x-3;}

  //character jump
  if (keys[2]==true && isjumping==0)
  {
    isjumping=1;
    yinc=-15;
  }
  if (isjumping==1 || get(x, y+10)!=groundColor) //if character is jumping
  {
    y=y+yinc; //add thrust to current y position
    yinc=yinc+1; //-5,-4,-3,-2,-1,0,1,2
  }
  if (get(x, y+10)==groundColor)//if in range on the x axis of platform 
  {
    isjumping=0;
  }
  if (get(x, y+9)==groundColor || get(x+10, y+9)==groundColor) {
    y--;
  } //makes character walk on the very surface after a jump
}

void keyPressed()
{
  if (keyCode==RIGHT) {keys[0]=true;}
  if (keyCode==LEFT) {keys[1]=true;}
  if (keyCode==UP) {keys[2]=true;}
}

void keyReleased()
{
  if (keyCode==RIGHT) {keys[0]=false;}
  if (keyCode==LEFT) {keys[1]=false;}
  if (keyCode==UP) {keys[2]=false;}
}

class Collectable
{
  int collectableX, collectableY, randomIndex;
  Collectable()
  {
    randomIndex=(int)(Math.random()*randomArrayLength);
    collectableX=randomXpositions[randomIndex]+(int)(Math.random()*(platformWidth-10));
    collectableY=randomYpositions[randomIndex]-10;
  }
  void show()
  {
    fill(255, 0, 0);
    rect(collectableX, collectableY, 10, 10,3);
  }
  void scoring()
  {
    if ((x==collectableX || x==collectableX+1 || x==collectableX+2 || x==collectableX+3 || x==collectableX+5) && y==collectableY)
    {
      score++;
    }
  }
  public int getX(){return collectableX;}
  public int getY(){return collectableY;}
}

class Enemy
{
  int enemyX, enemyY, randomIndex, enemyRandomDirection, enemy_isjumping, enemy_yinc;
  Enemy()
  {
    enemyRandomDirection=(int)(Math.random()*50)-26; //random negative or positive number generator
    enemyX=(int)(Math.random()*(width-10));
    enemyY=400-10;
    enemy_isjumping=0; //flag to know when enemy is jumping or not
  }

  void show(){
    fill(2,198,0);
    rect(enemyX, enemyY, 10, 10, 3);
  }

  void move(){
    if(enemyRandomDirection<0){
      enemyX=enemyX-2;
    }
    else{
      enemyX=enemyX+2;
    }
    if(millis()%200==0){ //for every 100 milliseconds, generate a new random direction
      enemyRandomDirection=(int)(Math.random()*50)-26;
    }

    //wrapping around screen
    if (enemyX>width-mainSize) {enemyX=0;}
    if (enemyX<0) {enemyX=width-mainSize;}

    //enemy random jump
    if (millis()%500==0 && enemy_isjumping==0)
    {
      enemy_isjumping=1;
      enemy_yinc=-15;
    }
    if (enemy_isjumping==1 || get(enemyX, enemyY+10)!=groundColor) //if enemy is jumping
    {
      enemyY=enemyY+enemy_yinc; //add thrust to current enemyY position
      enemy_yinc=enemy_yinc+1; //-5,-4,-3,-2,-1,0,1,2
    }
    if (get(enemyX, enemyY+10)==groundColor)//if in range on the x axis of platform 
    {
      enemy_isjumping=0;
    }
    if (get(enemyY, enemyY+9)==groundColor || get(enemyX+10, enemyY+9)==groundColor) {
      enemyY--;
    } //makes enemy walk on the very surface after a jump
  }
}
