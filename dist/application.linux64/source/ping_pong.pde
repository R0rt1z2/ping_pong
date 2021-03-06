/* Llibreria per reproduir audio */
import processing.sound.*;

/* Variables locals */
float x, y, speedX, speedY;
float diam = 25;
float rectSize = 200;
int points = 0;
int menu_selection = 1; /* Start = 1, Exit = 2 */

/* Media (Imatges, sons i fonts) */
SoundFile colision;
SoundFile game_music;
PImage background;
PFont font;

/* Booleans */
boolean is_game_finished = false;
boolean in_menu = false;
boolean in_instructions = false;
boolean dead = false;
boolean show_points = true;
boolean show_fps = true;
boolean rainbow_mode = false;

/* Debug Mode */
boolean DEBUG_MODE = true;

/* Versió del joc */
float GAME_VERSION = 1.0;

/* Colors */
color[] colors = {#FA0303, #B305FF, #00C647, #F5BC00};
int colornum;

void setup() {
  size(1024, 700);
  
  /* Títol del joc */
  surface.setTitle("Ping-Pong!");

  /* Neteja-ho tot */
  reset(0);

  /* Inicialitza els sons/musica */
  colision = new SoundFile(this, "colision.mp3");
  game_music = new SoundFile(this, "game_music.mp3");

  /* Font del text del joc */
  font = createFont("font.ttf", 32);
  textFont(font);

  /* Imatge del menú */
  background = loadImage("background.jpg");

  /* Quan comença el joc el primer que veiem es el menú principal */
  in_menu = true;
  draw_menu(1);
}

void reset(int reset_booleans) {
  /* Posiciona la pilota al mig de la pantalla */
  x = width/2;
  y = height/2;

  /* Canvia la velocitat de la pilota */
  speedX = random(3, 5);
  speedY = random(3, 5);
  
  /* Desactiva-ho tot */
  if (reset_booleans == 1)
  {
    rainbow_mode = false;
    show_points = false;
    show_fps = false;
  }
}

void draw() 
{
  if (in_menu != true && in_instructions != true) 
  {
    if (dead != true) 
    {
      if (!game_music.isPlaying())
      {
          game_music.play();
      }
      
      /* Colors */
      if (rainbow_mode == true)
      {
        fill(colors[int(random(colors.length - 1))]);
      }

      /* Mostra les coordenades de el ratolí i la pilota en la consola */
      if (DEBUG_MODE == true)
      {
        println(String.format("Coordenades del ratolí: X = %s || Y = %s\n", mouseX, mouseY));
        println(String.format("Coordenades de la pilota: X = %s || Y = %s\n", x, y));
      }

      /* Fons del joc negre */
      background(0);

      /* Dibuixa la pilota */
      ellipse(x, y, diam, diam);

      /* Paret (Esquerra) */
      rect(0, 0, 20, height);

      /* Plataforma (Es mou amb el ratolí) */
      rect(width-30, mouseY-rectSize/2, 10, rectSize);

      /* Velocitats */
      x += speedX;
      y += speedY;

      /* Colisió de la pilota amb la plataforma */
      if ( x > width-30 && x < width -20 && y > mouseY-rectSize/2 && y < mouseY+rectSize/2 ) {
        colision.play();
        speedX = speedX * -1;
      }

      /* Mostra els punts actuals en la pantalla */
      if (show_points == true)
      {
        textSize(25);
        text("Punts: " + points, width/2-100, 50);
        textSize(10);
      }
      
      /* Mostra els FPS */
      if (show_fps == true)
      {
        textSize(8);
        text("FPS: " + int(frameRate), width/2-50, height/2+330);
      }

      /* Detecta si la pilota no ha xocat amb la plataforma */
      if (x > width)
      {
        /* Carrega la foto del fons del menú */
        image(background, 0, 0, width, height);
        reset(1);
        
        /* Estem morts, atura el joc */
        dead = true;
        
        /* Atura la música */
        game_music.stop();
        
        /* Color del text */
        fill(255);
        
        /* Mostra la pantalla de mort */
        textSize(50);
        text("GAME OVER!", width/2-250, height/2);
        
        /* Mostra els punts */
        textSize(20);
        text("Punts: " + points, width/2-100, height/2+50);
        
        /* Mostra com tornar al menú */
        textSize(15);
        text("(Prem ENTER per tornar al menú)", width/2-250, height/2+100);
      }

      /* Col·lisió de la pilota amb la paret (+1 P) */
      if (x < 25) 
      {
        colision.play();
        speedX *= -1.1;
        speedY *= 1.1;
        x += speedX;
        points += 1;
      }

      /* Si la pilota xoca amb el sostre o el sòl canvia la direcció de l'eix Y */
      if ( y > height || y < 0 ) 
      {
        speedY *= -1;
      }
    }
  } else if (in_menu == true || in_instructions != true)
  {
    /* Mostra l'hora actual */
    draw_menu(menu_selection);
    textSize(15);
    text(day()+"/"+month()+"/"+year()+" - "+hour()+":"+minute()+":"+second(), width/2+170, height/2+330);
  }
}

void draw_menu(int selection)
{
  /* Color del text del menú */
  fill(255);

  /* Actualitza la selecció */
  menu_selection = selection;
  if (DEBUG_MODE == true)
  {
    println("Update current selection to " + menu_selection);
  }

  /* Carrega la foto del fons del menú */
  image(background, 0, 0, width, height);

  /* Carrega el text del menú */
  textSize(15);
  text("Roger Ortiz Leal - Tecnologies 2020-2021", width/2-480, height/2-300);

  if (DEBUG_MODE == true)
  {
    text("[*] Debug Mode ON", width/2+170, height/2-300);
  } else
  {
    text("[*] Debug Mode OFF", width/2+170, height/2-300);
  }

  text("Ping-Pong Version " + GAME_VERSION, width/2-480, height/2+330);

  textSize(15);
  text("(Prem la tecla 'i' per veure com funciona el joc)", width/2-380, height/2+200);

  textSize(40);
  text("Ping Pong!", width/2-200, height/2-50);

  /* Selecció */
  if (selection == 1)
  {
    text("> Start", width/2-300, height/2+100);
    text("Exit", width/2+75, height/2+100);
  } else if (selection == 2)
  {
    text("Start", width/2-300, height/2+100);
    text("> Exit", width/2+50, height/2+100);
  }
}

void draw_instructions() {
  /* Carrega la foto del fons de les instruccions */
  image(background, 0, 0, width, height);

  /* Mostra les instruccions del joc */
  textSize(35);
  text("INSTRUCCIONS DEL JOC", 150, 100);

  textSize(15);
  text("- L'objectiu del joc és fer que la pilota xoqui contra la paret\nper aconseguir el màxim nombre de punts possible.\n", 50, 150);
  text("- Si la pilota no xoca amb la plataforma que hi ha a la dreta,\n el joc s'acaba i perds.", 50, 220);
  text("- Cada cop que la pilota toca la paret esquerra, s'incrementa 1\n punt al comptador.", 50, 290);
  text("- Pots activar la visualització dels punts que has aconseguit\n prement la tecla 's/S'.", 50, 360);
  text("- Pots fer el joc més divertit prement la tecla 'r/R' per\n activar el mode 'multicolor'.", 50, 430);
  text("- Pots activar la visualització dels FPS del joc prement\n la tecla 'f/F'.", 50, 500);
  text("- Pots tornar al menú en qualsevol moment fent servir la\n tecla 'm/M'.", 50, 570);

  textSize(20);
  text("Prem la tecla ENTER per tornar al menú", 150, 650);
}

void keyPressed() {
  if (in_menu == true && in_instructions != true)
  {
    if (keyCode == LEFT)
    {
      draw_menu(1);
    } else if (keyCode == RIGHT)
    {
      draw_menu(2);
    } else if (keyCode == 'i' || keyCode == 'I')
    {
      in_instructions = true;
      in_menu = false;
      draw_instructions();
    } else if (keyCode == ENTER)
    {
      if (menu_selection == 2)
      {
        exit();
      } else if (menu_selection == 1)
      {
        in_menu = false;
        fill(colors[int(random(colors.length - 1))]);
      }
    }
  } else if (in_instructions == true && in_menu != true) 
  {
    if (keyCode == ENTER)
    {
      in_instructions = false;
      in_menu = true;
      draw_menu(1);
    }
  } 
  else
  {
    if (keyCode == 'm' || keyCode == 'M')
    {
      if (dead != true)
      {
          if (game_music.isPlaying())
          {
              game_music.stop();
          }          
          in_menu = true;
          draw_menu(1);
          reset(1);
      }
    } 
    else if (keyCode == 's' || keyCode == 'S')
    {
      if (show_points == true)
        show_points = false;
      else
        show_points = true;
    } 
    else if (keyCode == 'f' || keyCode == 'F')
    {
      if (show_fps == true)
        show_fps = false;
      else
        show_fps = true;
    }
    else if (keyCode == 'r' || keyCode == 'R')
    {
      if (rainbow_mode == true)
        rainbow_mode = false;
      else
        rainbow_mode = true;
    } else if (keyCode == ENTER)
    {
      if (dead == true)
      {
        in_menu = true;
        dead = false;
        draw_menu(1);
      }
    }
  }
}
