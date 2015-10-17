class Player{
  String name;
  ArrayList<String> fighters;
  Player(String name){
    this.name = name;
  }
  void addFighter(String fighter){
    fighters.add(fighter);
  }
  void clear(){
    fighters.clear();
  }
}

class Match{
  ArrayList<Player> players;
  ArrayList<Integer> rank, ko, fall, sd;
  Match( Iterable<Player> players ){
    this.players = new ArrayList<Player>();
    this.rank = new ArrayList<Integer>();
    this.ko = new ArrayList<Integer>();
    this.fall = new ArrayList<Integer>();
    this.sd = new ArrayList<Integer>();
    int i = 1;
    for( Player p : players ){
      this.players.add(p);
      rank.add(i++);
      ko.add(0);
      fall.add(0);
      sd.add(0);
    }
  }
}

class MatchSet{
  ArrayList<Match> matches;
  MatchSet(){
  }
  void trade( int fromMatch, int fromPlayer, int toMatch, int toPlayer, MatchSet to ){
  }
  int status(){
    return 0;
  }
}

// constants used for sizing the window
final int PLAYER_WIDTH = 200;
final int PLAYER_HEIGHT = 150;
final int ADD_PLAYER_HEIGHT = 50;
final int MATCH_PLAYER_WIDTH = 150;
final int MATCH_HEIGHT = 150;
final int SIDEBAR_WIDTH_PER_MATCH = 20;
final int SIDEBAR_PADDING = 2;
final int SIDEBAR_WIDTH = 2*SIDEBAR_PADDING+SIDEBAR_WIDTH_PER_MATCH;
// used to control what gets placed in the center screen
String mode;
// used to scroll
int standingsOffset, setOffset;
// settings for different tournament types
int playersPerMatch, matchesPerSet, fightersPerPlayer;
// determining the point values for placement
int[] pointsPerRank;
int pointsKO, pointsFall, pointsSD;
// interface colors
color[] back, fore, text;
color standingsOdd, standingsEven;
color backcolor, complete, progress, error;
// control who is allowed to fight
ArrayList<String> availableFighters;
// keep track of matchups
ArrayList<Player> players;
ArrayList<Match> matches;
ArrayList<MatchSet> sets;

void setup(){
  frameRate(4);
  // three different tones of red, blue, yellow, green, orange, light blue, purple, and black ( the colors of each player in smash )
  back=new color[]{ color(102,0,0), color(0,0,102), 
                    color(102,102,0), color(0,102,0),
                    color(102,51,0), color(0,102,102),
                    color(102,0,102), color(0)};
  fore=new color[]{ color(204,0,0), color(0,0,204), 
                    color(204,204,0), color(0,204,0),
                    color(204,102,0), color(0,204,204),
                    color(204,0,204), color(255)};
  text=new color[]{ color(102,0,0), color(0,0,102), 
                    color(102,102,0), color(0,102,0),
                    color(102,51,0), color(0,102,102),
                    color(102,0,102), color(0)};
  // the colours for the scoreboard
  standingsOdd = color(232);
  standingsEven = color(0,63,72);
  // the colours for the match summary
  backcolor = color(40);
  error = color(54,0,0);
  complete = color(0,54,0);
  progress = color(54,54,0);
  // initializing arrays to hold all the info
  players = new ArrayList<Player>();
  matches = new ArrayList<Match>();
  sets = new ArrayList<MatchSet>();
  mode = "Player";
  playersPerMatch = 4;
  matchesPerSet = 4;
  fightersPerPlayer = 3;
  pointsPerRank = new int[]{6,4,2,1};
  pointsKO = 1;
  pointsFall = -1;
  pointsSD = -2;
  //size(PLAYER_WIDTH+(playersPerMatch*MATCH_PLAYER_WIDTH)+(playersPerMatch*matchesPerSet*(2*SIDEBAR_PADDING+SIDEBAR_WIDTH_PER_MATCH)),matchesPerSet*MATCH_HEIGHT);
  size(1184,600);
  players.add( new Player("Jacob Wolfe") );
  players.add( new Player("Alex Trush") );
  players.add( new Player("Pidgey") );
  players.add( new Player("Jeff Cunning") );
  players.add( new Player("Jacob Wolfe") );
  players.add( new Player("Alex Trush") );
  players.add( new Player("Pidgey") );
  players.add( new Player("Jeff Cunning") );
  players.add( new Player("Jacob Wolfe") );
  players.add( new Player("Alex Trush") );
  players.add( new Player("Pidgey") );
  players.add( new Player("Jeff Cunning") );
  players.add( new Player("Jacob Wolfe") );
  players.add( new Player("Alex Trush") );
  players.add( new Player("Pidgey") );
  players.add( new Player("Jeff Cunning") );
  println(width+","+height);
}



void draw(){
  background(backcolor);
  color c;
  int h;
  // keep track of where in the standings we are looking
  int o = standingsOffset;
  noStroke();
  // display the standings on the left
  for( int i = 0 ; i < players.size() ; i++ ){
    c = ( i % 2 == 0 ) ? standingsEven : standingsOdd;
    fill(c);
    rect(0,o+i*PLAYER_HEIGHT,PLAYER_WIDTH,PLAYER_HEIGHT);
  }
  fill(0,83,0);
  rect(0,height-ADD_PLAYER_HEIGHT,PLAYER_WIDTH,ADD_PLAYER_HEIGHT);
  if( "Player".equalsIgnoreCase( mode ) ){
    
  } else if ( "Match".equalsIgnoreCase( mode ) ){
    // display the current match being looked at
    for( int i = 0 ; i < playersPerMatch ; i++ ){
      for( int j = 0 ; j < matchesPerSet ; j++ ){
        if( j % 2 == 0 ){
          fill( fore[i] );
        } else {
          fill( back[i] );
        }
        noStroke();
        rect(PLAYER_WIDTH+i*MATCH_PLAYER_WIDTH,j*MATCH_HEIGHT,MATCH_PLAYER_WIDTH,MATCH_HEIGHT);
      }
    }
  }
  int i;
  o = setOffset;
  // the x coordinate of where the match summary begins
  int xoff = PLAYER_WIDTH+playersPerMatch*MATCH_PLAYER_WIDTH;
  // the size with padding included of each match square
  int w = SIDEBAR_WIDTH;
  // check through every set of matches
  for( i = 0 ; i < sets.size() ; i++ ){
    int status = sets.get(i).status();
    switch( status ){
      case 1:{
        fill( error );
        break;
      }
      case 2:{
        fill( complete );
        break;
      }
      case 3:{
        fill( progress );
        break;
      }
      default:{
        fill( backcolor );
        break;
      }
    }
    // set the background colour according to the status of the matches
    noStroke();
    rect(xoff,o+i*w,playersPerMatch*matchesPerSet*w,w);
    // print out all the characters, adding a 
    for( int j = 0 ; j < matchesPerSet ; j++ ){
      for( int k = 0 ; k < playersPerMatch ; k++ ){
        stroke( fore[k] );
        fill( back[k] );
        rect(xoff+w*(j*playersPerMatch+k)+SIDEBAR_PADDING,o+i*w+SIDEBAR_PADDING,SIDEBAR_WIDTH_PER_MATCH,SIDEBAR_WIDTH_PER_MATCH);
      } 
    }
  }
  fill( 72,0,93 );
  noStroke();
  rect( xoff, o+i*w, playersPerMatch*matchesPerSet*w, w);
}

void mouseDragged(){
  int moveY = mouseY - pmouseY;
  int screenHeight = height - ADD_PLAYER_HEIGHT, heightUsed;
  if( mouseX > PLAYER_WIDTH+playersPerMatch*MATCH_PLAYER_WIDTH ){
    setOffset += moveY; 
    heightUsed = SIDEBAR_WIDTH * (sets.size()+1);
    if( setOffset > 0 || heightUsed < screenHeight ){
      setOffset = 0;
    } else if( setOffset < screenHeight - heightUsed ){
      setOffset = screenHeight - heightUsed;
    }
  }
  if( mouseX < PLAYER_WIDTH ){
    // the amount of space being taken up by the standings
    standingsOffset += moveY;
    heightUsed = PLAYER_HEIGHT * players.size();
    if( standingsOffset > 0 || heightUsed < screenHeight ){
      standingsOffset = 0;
    } else if( standingsOffset < screenHeight - heightUsed ){
      standingsOffset = screenHeight - heightUsed;
    }
  }
}

void mouseClicked(){
  if( mouseX > PLAYER_WIDTH+playersPerMatch*MATCH_PLAYER_WIDTH ){
    mode = "Match";
  }
  if( mouseX < PLAYER_WIDTH && mouseY > height - ADD_PLAYER_HEIGHT ){
    mode = "Player";
  }
}
