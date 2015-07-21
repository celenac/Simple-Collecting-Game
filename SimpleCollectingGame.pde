//jumping instructions: http://ashbprocessing.blogspot.com/2013/04/second-stage-character-jumping-platforms.html

int x, y, groundY;
int yinc; //speed of upthrust for character jump
int isjumping=0; //flag to know if character is jumping or not
int groundColor=color(0);
boolean [] keys; //pressing two keys simultaneously
int collectablesArrayListSize=10;
ArrayList <Collectable> collectables =new ArrayList <Collectable>();
int [] randomYpositions;
int randomArrayLength=(int)((Math.random()*3)+2);
int [] randomXpositions;
int score=0;
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
  int i=0;
  while(i<randomArrayLength)
  {
    randomXpositions[i]=(int)(Math.random()*350);
    randomYpositions[i]=(((int)(Math.random()*7))*50)+30;
    i++;
  }
  
  for (int c=0; c<collectablesArrayListSize; c++)
  {
    collectables.add(new Collectable());
  }
}

void draw()
{
  background(200);

  //ground
  fill(groundColor);
  rect(-200, 400, 1200, 200);

  //drawing random platforms
  fill(groundColor);
  for (int i=0; i<randomArrayLength; i++)
  {
    rect(randomXpositions[i], randomYpositions[i], 300, 20);
  }

  //little box
  fill(255);
  rect(x, y, 10, 10);

  //wrapping around screen
  if (x>=1005) {x=0; y=y;}
  if (x<-5) {x=1000; y=y;}

  //show score
  textSize(25);
  fill(0);
  text(score + "/" + collectablesArrayListSize, 20, 30);

  for (int c=0; c<collectables.size(); c++)
  {
    collectables.get(c).show();
    collectables.get(c).scoring();
    if ((x==collectables.get(c).getX() || x==collectables.get(c).getX()+1 || x==collectables.get(c).getX()+2 || x==collectables.get(c).getX()+3) && y==collectables.get(c).getY())
    {
      collectables.remove(c);
    }
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
    collectableX=randomXpositions[randomIndex]+(int)(Math.random()*300);
    collectableY=randomYpositions[randomIndex]-10;
  }
  void show()
  {
    fill(255, 0, 0);
    rect(collectableX, collectableY, 10, 10);
  }
  void scoring()
  {
    if ((x==collectableX || x==collectableX+1 || x==collectableX+2 || collectableX==3) && y==collectableY)
    {
      score++;
    }
  }
  public int getX(){return collectableX;}
  public int getY(){return collectableY;}
}
