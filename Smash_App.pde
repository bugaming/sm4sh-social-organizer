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
final int SIDEBAR_BOX_WIDTH = 2*SIDEBAR_PADDING+SIDEBAR_WIDTH_PER_MATCH;
final int PLAYER_SELECT_ROWS = 7;
String mode;
// used to scroll
int standingsOffset, setOffset;
int sidebarWidth;
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
ArrayList<String> availFighters;
HashMap<String,PImage> fighterImg;
String selectName;
ArrayList<String> selectedFighters;
// keep track of matchups
ArrayList<Player> players;
ArrayList<Match> matches;
ArrayList<MatchSet> sets;

void setup(){
  size(1184,650);
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
  String str;
  availFighters = new ArrayList<String>();
  fighterImg = new HashMap<String,PImage>();
  players = new ArrayList<Player>();
  matches = new ArrayList<Match>();
  sets = new ArrayList<MatchSet>();
  mode = "Player";
  XML xml = loadXML("smash social roster.xml");
  if( xml != null ){
    XML[] fighters = xml.getChildren("fighter");
    for( int i = 0 ; i < fighters.length ; i++ ){
      str = fighters[i].getContent();
      loadFighter(str);
    }
  } else {
    String[] temp = {"Mario","Luigi","Peach", "Bowser","Yoshi","Rosalina",
         "Bowser Jr","Wario","Game and Watch","DK","Diddy Kong",
        "Link","Zelda","Sheik","Ganondorf","Toon Link","Samus",
        "Zero Suit Samus","Pit","Palutena","Marth","Ike",
        "Robin","Kirby","King Dedede","Meta Knight",
        "Little Mac","Fox","Falco","Pikachu","Charizard",
        "Lucario","Jigglypuff","Greninja","Duck Hunt","ROB",
        "Ness","Captain Falcon","Villager","Olimar",
        "Wii Fit Trainer","Dr Mario","Dark Pit","Lucina",
        "Shulk","Pacman","Megaman","Sonic","Random"};
    for( int i = 0 ; i < temp.length ; i++ ){
      loadFighter( temp[i] );
    }
  }
  setPlayersPerMatch( 4 );
  setMatchesPerSet( 4 );
  fightersPerPlayer = 3;
  pointsPerRank = new int[]{6,4,2,1};
  pointsKO = 1;
  pointsFall = -1;
  pointsSD = -2;
  //size(PLAYER_WIDTH+(playersPerMatch*MATCH_PLAYER_WIDTH)+(playersPerMatch*matchesPerSet*(2*SIDEBAR_PADDING+SIDEBAR_WIDTH_PER_MATCH)),matchesPerSet*MATCH_HEIGHT+ADD_PLAYER_HEIGHT);
  println(width+","+height);
  println(fighterImg.size());
  players.add( new Player("Jacob Wolfe") );
  players.add( new Player("Alex Trush") );
  players.add( new Player("Pidgey") );
  players.add( new Player("Jeff Cunning") );
}

void loadFighter( String str ){
  PImage t =  loadImage( str+".png" );
  if( t != null ){
    availFighters.add(str);
    fighterImg.put(str, t);
  }
}

void setPlayersPerMatch( int n ){
  playersPerMatch = n;
  sidebarWidth = playersPerMatch * matchesPerSet * SIDEBAR_BOX_WIDTH;
  resize(PLAYER_WIDTH+(playersPerMatch*MATCH_PLAYER_WIDTH)+sidebarWidth,matchesPerSet*MATCH_HEIGHT+ADD_PLAYER_HEIGHT);
}

void setMatchesPerSet( int n ){
  matchesPerSet = n;
  sidebarWidth = playersPerMatch * matchesPerSet * SIDEBAR_BOX_WIDTH;
  resize(PLAYER_WIDTH+(playersPerMatch*MATCH_PLAYER_WIDTH)+sidebarWidth,matchesPerSet*MATCH_HEIGHT+ADD_PLAYER_HEIGHT);
}

void resetPlayerSelect(){
  
}

void addPlayer(){
  
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
  if( "Player".equalsIgnoreCase( mode ) && fighterImg.size() > 0){
    int rows = PLAYER_SELECT_ROWS;
    int cols = (int)Math.ceil((double)fighterImg.size()/rows);
    float wid = playersPerMatch*MATCH_PLAYER_WIDTH/cols;
    float hei = (matchesPerSet*MATCH_HEIGHT-ADD_PLAYER_HEIGHT)/rows;
    // display all possible fighters
    c = 0;
    for( int i = 0 ; i < rows ; i++ ){
      for( int j = 0 ; j < cols ; j++ ){
        if( c >= fighterImg.size() ){ break; }
        image( fighterImg.get(availFighters.get(c++)), PLAYER_WIDTH+j*wid, i*hei, wid, hei );
      }
    }
    
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
  int w = SIDEBAR_BOX_WIDTH;
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
    // print out all the matchups
    for( int j = 0 ; j < matchesPerSet ; j++ ){
      for( int k = 0 ; k < playersPerMatch ; k++ ){
        stroke( fore[k] );
        fill( back[k] );
        rect(xoff+w*(j*playersPerMatch+k)+SIDEBAR_PADDING,o+i*w+SIDEBAR_PADDING,SIDEBAR_WIDTH_PER_MATCH,SIDEBAR_WIDTH_PER_MATCH);
      } 
    }
  }
  // allow addition of more matches
  fill( 72,0,93 );
  noStroke();
  rect( xoff, o+i*w, playersPerMatch*matchesPerSet*w, w);
}

void mouseDragged(){
  //determine how much the mouse moved
  int moveY = mouseY - pmouseY;
  // how high the screen is
  int screenHeight = height - ADD_PLAYER_HEIGHT, heightUsed;
  if( mouseX > PLAYER_WIDTH+playersPerMatch*MATCH_PLAYER_WIDTH ){
    // scroll the match summary
    setOffset += moveY; 
    // the amount of space taken by the match summary
    heightUsed = sidebarWidth * (sets.size()+1);
    // stop the match summary from running away
    if( setOffset > 0 || heightUsed < screenHeight ){
      setOffset = 0;
    } else if( setOffset < screenHeight - heightUsed ){
      setOffset = screenHeight - heightUsed;
    }
  }
  if( mouseX < PLAYER_WIDTH ){
    // scroll the standings
    standingsOffset += moveY;
    // the amount of space being taken up by the standings
    heightUsed = PLAYER_HEIGHT * players.size();
    // ensure the standings don't fly off screen
    if( standingsOffset > 0 || heightUsed < screenHeight ){
      standingsOffset = 0;
    } else if( standingsOffset < screenHeight - heightUsed ){
      standingsOffset = screenHeight - heightUsed;
    }
  }
}

void mouseClicked(){
  if( mouseX > height - sidebarWidth ){
    mode = "Match";
  } else if( mouseX < PLAYER_WIDTH ){
    // clicked the add player button, bring up that menu
    if( mouseY > height - ADD_PLAYER_HEIGHT ){
      mode = "Player";
    // clicked the standings
    } else {
      // when in player entry mode, clear any data 
      if( "Player".equals( mode ) ){
        resetPlayerSelect();
      }
    }
  // the center screen is clicked
  } else {
    // choose a player
    if( "Player".equals( mode ) ){
    }
    // update match data
    if( "Match".equals( mode ) ){
      
    }
  }
}
