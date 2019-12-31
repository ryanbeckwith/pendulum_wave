/* Class representing a simple pendulum. Each Pendulum object
  moves according to a time-dependent, sinusoidal function
  representing the angular displacement of the Pendulum
  from the vertical axis. */
class Pendulum {
  // Length of string in meters
  float len;
  // Starting angle from the vertical in degrees
  float angle;
  // Float representing the time-dependent anglular displacement
  float theta;
  // Time in seconds specified as a parameter in the update() method
  float t;
  // Float representing the angular frequency
  float omega;
  // Velocity vector represented using a PVector object
  PVector vel;
  // Variable scaling the string length from meters to pixels onscreen
  float scale = 1;
  // RGB color values
  float red, green, blue;
  // Radius of circular pendulum bobs in pixels
  final float radius = 15;
  
  /* Main constructor with non-customizable color. If the Pendulum object
    does not have a length corresponding to that of a functioning pendulum
    wave, the isFaulty parameter is set to true, and the resulting Pendulums
    are drawn in red/orange. Functioning Pendulums are drawn in cyan/teal.
    l represents the length of the pendulum,
    and a represents the starting angle of the pendulum. */
  Pendulum(float l, float a, boolean isFaulty)
  {
    len = l;
    angle = a;
    // Sets omega to the square root of g/l, the angular frequency for a simple pendulum
    omega = sqrt(g/l);
    // Instantiates vel as a 0 PVector
    vel = new PVector(0, 0);
    // Conditional checking to see if the Pendulum is faulty
    if (isFaulty)
    {
      // Sets the red attribute to a random value between 200 and 255
      red = random(200, 255);
      green = random(0, 75);
      blue = 0;
    }
    else
    {
      red = 20;
      green = 200;
      blue = random(200, 255);
    }
  }
  
  /* Method used to update the position of the Pendulum object
    after time has passed. Instead of being frame-dependent,
    this method utilizes the time since the space key has been
    pressed to model the system in seconds, thus providing a 
    more accurate simulation that is not impacted by dropped frames.
    time represents the time since the space key has been pressed
    in seconds. */
  void update(float time)
  {
    // Sets the color of lines and shape borders to white with a 90% opacity
    stroke(255, 90);
    // Sets the thickness of lines and shape borders to 2px
    strokeWeight(2);
    // Sets the t attribute to the number of seconds since the script began
    t = time;
    /* Sets the theta attribute to a function of the cosine of the elapsed time
      times the angular frequency. By multiplying by the angle function, the
      Pendulum object starts at the specified value of angle. */
    theta = angle * cos(omega * t);
    // Pushes the current transformation matrix onto the matrix stack
    pushMatrix();
    /* Rotates the screen as a function of time. It is important to note
      that the rotate function rotates the coordinate system in its entirety,
      and not the objects drawn to the screen. The pendulum itself stays fixed
      vertically relative to the coordinate system, but the coordinate system
      itself rotates to simulate harmonic oscillation of the Pendulum object. */
    rotate(radians(theta));
    // Draws the string of the pendulum on the screen if lPressedOdd is false
    if (!lPressedOdd)
    {
      line(0, 0, 0, len * scale - radius);
    }
    // Removes the stroke attribute for the circle
    noStroke();
    // Sets the color of the interior of the circle to the RGB attributes with a 99% opacity
    fill(red, green, blue, 99);
    // Draws a circle at the end of the string if bPressedOdd is false
    if (!bPressedOdd)
    {
      ellipse(0, len * scale, radius * 2, radius * 2);
    }
    // Draws the velocity vector on the screen as a line and triangle if vPressedOdd is true
    if (vPressedOdd)
    {
      drawVelVector();
    }
    // Pops the current transformation matrix off the matrix stack.
    popMatrix();
  }
  
  // Method that creates a visual representation of the velocity vector of the Pendulum object
  void drawVelVector()
  {
    // Defines the x-component of the velocity vector as the derivative of the angle scaled down by a factor of 5
    vel.x = (angle * omega * sin(omega * t)) * len / 5.0;
    // Sets the color of lines and shape borders to red
    stroke(255, 0, 0);
    /* Draws a line from the center of the pendulum bob perpendicular to the string of 
    the Pendulum object of magnitude equal to the x-component of the velocity vector. */
    line(0, len * scale, vel.x, len * scale);
    // Conditional statement that determines direction of the vector arrowhead
    if (vel.x > 0)
    {
      // Draws the vector arrowhead as a triangle facing right
      triangle(vel.x + 3, len * scale, vel.x, len * scale - 1.5, vel.x, len * scale + 1.5);
    }
    else
    {
      // Draws the vector arrowhead as a triangle facing left
      triangle(vel.x - 3, len * scale, vel.x, len * scale - 1.5, vel.x, len * scale + 1.5);
    }
  }
}





// ArrayList containing all Pendulum objects in the pendulum wave
ArrayList<Pendulum> pendulums = new ArrayList<Pendulum>();
// Float containing the time in seconds since the start of the program to when the space key is pressed
float startTime = 0;
// Float containing the time of realignment of the pendulum wave
float tRealign = 0;
// Float containing the number of swings of longest pendulum per time of realignment
float numSwingsPerTRealign = 0;
// Float containing the common starting angle of the pendulum wave
float startingAngle = 0;
// Float representing the number of Pendulum objects in the pendulums ArrayList
float numPendulums = 0;
// Float containing the number of times the 'v' key has been pressed
float timesVPressed = 0;
// Float containing the number of times the 's' key has been pressed
float timesSPressed = 0;
// Float containing the number of times the 'l' key has been pressed
float timesLPressed = 0;
// Float containing the number of times the 'b' key has been pressed
float timesBPressed = 0;
// Float containing the number of times the 'c' key has been pressed
float timesCPressed = 0;
// Acceleration due to gravity
final float g = 9.81;
// Boolean that contains whether or not the 'v' key has been pressed an odd number of times
boolean vPressedOdd = false;
// Boolean that contains whether or not the 's' key has been pressed an odd number of times
boolean sPressedOdd = false;
// Boolean that contains whether or not the 'l' key has been pressed an odd number of times
boolean lPressedOdd = false;
// Boolean that contains whether or not the 'b' key has been pressed an odd number of times
boolean bPressedOdd = false;
// Boolean that contains whether or not the 'c' key has been pressed an odd number of times
boolean cPressedOdd = false;
// Boolean that contains whether or not the pendulums ArrayList contains faulty/non faulty pendulums
boolean arrayIsFaulty = true;
// Boolean that contains whether or not the space key is being pressed down
boolean spacePressed = false;
// Boolean that contains whether or not the space key has been pressed at least once
boolean spaceHasBeenPressed = false;

/* Method that instantiates and adds a specified number of Pendulum objects
  to the pendulums ArrayList. This method ensures that each pendulum will
  have the correct length specified by the expression for the period of a
  simple pendulum, thus creating a functioning pendulum wave.
  num represents the number of pendulums to be instantiated,
  angle represents the common starting angle for each pendulum,
  tMax represents the amount of time it takes for all pendulums to realign,
  and numSwings represents the number of times the pendulum of the longest
  length swings during tMax.
  Note: this method sets the scale attribute of each pendulum such that
  the longest pendulum is a distance of 150 pixels from the bottom of the
  screen when at the bottom of its swing. */
void createPendulums(float num, float angle, float tMax, float numSwings)
{
  tRealign = tMax;
  numSwingsPerTRealign = numSwings;
  startingAngle = angle;
  numPendulums = num;
  // for loop iterating num times
  for (int i = 0; i < num; i++)
  {
    // Float representing the length of the longest pendulum
    float lMax = g * (tMax / (2 * PI * numSwings)) * (tMax / (2 * PI * numSwings));
    // Float representing the length of the pendulum at index i
    float l = g * (tMax / (2 * PI * (numSwings + i))) * (tMax / (2 * PI * (numSwings + i)));
    // Adds a new non-faulty Pendulum object to the pendulums ArrayList
    pendulums.add(new Pendulum(l, angle, false));
    // Resets the scale attribute of each Pendulum object in pendulums
    pendulums.get(i).scale= (height - 150) / lMax;
  }
}

/* Method that instantiates and adds a specified number of Pendulum objects
  to the pendulums ArrayList. These Pendulum object vary in length by 0.25 meters,
  and therefore do not exhibit the behavior of a pendulum wave.
  Note: this method sets the scale attribute of each pendulum such that
  the longest pendulum is a distance of 150 pixels from the bottom of the
  screen when at the bottom of its swing. */
void createFaultyPendulums(float num, float angle)
{
  numPendulums = num;
  startingAngle = angle;
  // for loop iterating num times
  for (int i = 0; i < num; i++)
  {
    // Adds a new faulty Pendulum object to the pendulums ArrayList
    pendulums.add(new Pendulum(3 + 0.25 * i, angle, true));
    // Float representing the length of the longest pendulum
    float lMax = num * 0.25 + 3;
    // Resets the scale attribute of each Pendulum object in pendulums
    pendulums.get(i).scale= (height - 150) / lMax;
  }
}

/* The setup method is called immediately when the script is run,
  and is used to set initial values for fields. It also contains
  a single call to the size() method. */
void setup()
{
  // Sets size of window to specified pixel size (width, height)
  size(1600, 950);
  // Sets background of window to black
  background(0);
  // Sets the color of lines and shape borders to white
  stroke(255);
}

/* The draw method is called every frame. The default framerate is
  60 fps, but the framerate can be adjusted using a call to the 
  frameRate() method. The draw method can be thought of as the 
  main method of any Processing script, as it allows for objects
  to be updated each frame. */
void draw()
{
  // Redraws the background each frame, preventing overlap from previous frames
  background(0);
  // Sets the origin of the coordinate system to the specified coordinate
  translate(width/2, 0);
  /* Instantiates the pendulums ArrayList to the correct model
    if the 'c' key has been pressed an even number of times and
    if the array previously contained faulty pendulums. */
  if (!cPressedOdd && arrayIsFaulty)
  {
    pendulums = new ArrayList<Pendulum>();
    createPendulums(25, 45, 75, 10);
    arrayIsFaulty = false;
  }
  /* Instantiates the pendulums ArrayList to the incorrect model
    if the 'c' key has been pressed an odd number of times and
    if the array previously contained non-faulty pendulums. */
  if (cPressedOdd && !arrayIsFaulty)
  {
    pendulums = new ArrayList<Pendulum>();
    createFaultyPendulums(20, 45);
    arrayIsFaulty = true;
  }
  // Iterates through the entire Pendulum ArrayList
  for (int i = 0; i < pendulums.size(); i++)
  {
    // Resets the simulation if the space key is pressed
    if (spacePressed)
    {
      startTime = millis() / 1000.0;
      spaceHasBeenPressed = true;
      spacePressed = false;
    }
    // Checks to see if the space key has been pressed at least once to start the simulation
    if (spaceHasBeenPressed)
    {
      // Calls the update method of each Pendulum object in pendulums with the current time minus the start time
      pendulums.get(i).update(millis() / 1000.0 - startTime);
    }
    else
    {
      // Calls the update method of each Pendulum object for time 0, thus preventing motion
      pendulums.get(i).update(0);
    }
    fill(255);
    /* Hides the length of each Pendulum object in pendulums on the screen 
      if the 's' key has been pressed. Because the faulty and non-faulty methods
      for instantiating Pendulums add the Pendulums in opposite order of length,
      the two following conditional methods are necessary to ensure the correct
      order of the displayed text. */
    if (!sPressedOdd && !cPressedOdd)
    {
      text("Length " + (i + 1) + ": " + pendulums.get(pendulums.size() - i - 1).len + " m", -width/2 + 50, 50 + 20 * i);
    }
    // Displays the opposite order for when the faulty pendulums are being displayed
    if (!sPressedOdd && cPressedOdd)
    {
      text("Length " + (i + 1) + ": " + pendulums.get(i).len + " m", -width/2 + 50, 50 + 20 * i);
    }
  }
  fill(255);
  // Prevents text from being displayed if the 's' key has been pressed
  if (!sPressedOdd)
  {
    // Displays the elapsed time on the screen since the last press of the space key
    text("Time elapsed: " + pendulums.get(0).t + " s", width/2 - 200, 50);
    // Shows the user if velocity vectors are being displayed depending on the value of vPressedOdd
    if (vPressedOdd)
    {
      text("Velocity vectors are shown", width/2 - 200, 90);
      text("Press 'v' to hide velocity vectors", width/2 - 200, 110);
    }
    else
    {
      text("Velocity vectors are hidden", width/2 - 200, 90);
      text("Press 'v' to show velocity vectors", width/2 - 200, 110);
    }
    // Shows the user if strings are being displayed depending on the value of lPressedOdd
    if (lPressedOdd)
    {
      text("Strings are hidden", width/2 - 200, 150);
      text("Press 'l' to show strings", width/2 - 200, 170);
    }
    else
    {
      text("Strings are shown", width/2 - 200, 150);
      text("Press 'l' to hide strings", width/2 - 200, 170);
    }
    // Shows the user if bobs are being displayed depending on the value of bPressedOdd
    if (bPressedOdd)
    {
      text("Bobs are hidden", width/2 - 200, 210);
      text("Press 'b' to show bobs", width/2 - 200, 230);
    }
    else
    {
      text("Bobs are shown", width/2 - 200, 210);
      text("Press 'b' to hide bobs", width/2 - 200, 230);
    }
    // Shows user what key to press to hide the text overlay
    text("Press 's' to hide the text overlay", width/2 - 200, 270);
    /* Displays both the time of realignment and number of swings of 
      longest pendulum per time of realignment on the screen for both
      accurate and inaccurate systems. */
    if (!cPressedOdd)
    {
      text("Time of realignment: " + tRealign + " s", width/2 - 200, 290);
      text("Number of swings of longest\npendulum per time of\nrealignment: " + round(numSwingsPerTRealign), width/2 - 200, 310);
    }
    else
    {
      text("Time of realignment: ???" + " s", width/2 - 200, 290);
      text("Number of swings of longest\npendulum per time of\nrealignment: ???", width/2 - 200, 310);
    }
    // Displays the common starting angle of each pendulum on the screen
    text("Starting angle: " + startingAngle + " degrees", width/2 - 200, 380);
    // Displays the number of pendulums on the screen
    text("Number of pendulums: " + round(numPendulums), width/2 - 200, 400);
    /* Shows the user which pendulum wave system (accurate/inaccurate) is 
      currently being displayed, along with the maximum length for each system. */
    if (!cPressedOdd)
    {
      // Displays the length of the longest pendulum on the screen for the accurate system
      text("Maximum length: " + pendulums.get(0).len, width/2 - 200, 420);
      // Shows the user that the correct model is currently being displayed
      text("Currently displaying the correct\nmodel of a pendulum wave", width/2 - 200, 460);
      text("Press 'c' to display the incorrect\nmodel of a pendulum wave", width/2 - 200, 490);
    }
    else
    {
      // Displays the length of the longest pendulum on the screen for the inaccurate system
      text("Maximum length: " + pendulums.get(pendulums.size() - 1).len, width/2 - 200, 420);
      // Shows the user that the incorrect model is currently being displayed
      text("Currently displaying the incorrect\nmodel of a pendulum wave", width/2 - 200, 460);
      text("Press 'c' to display the correct\nmodel of a pendulum wave", width/2 - 200, 490);
    }
    // Shows the user how to start/reset the simulation with the space key
    if (!spaceHasBeenPressed)
    {
      text("Press space to start the system", width/2 - 200, 540);
    }
    else
    {
      text("Press space to reset the system", width/2 - 200, 540);
    }
  }
}

// Method called whenever a key is pressed
void keyPressed()
{
  // Conditional testing for when the 'v' key is pressed
  if (keyCode == 86)
  {
    // Increment timesVPressed
    timesVPressed++;
    // Conditional setting vPressedOdd to true if timesVPressed is odd
    if (timesVPressed % 2 != 0)
    {
      vPressedOdd = true;
    }
    else
    {
      vPressedOdd = false;
    }
  }
  // Conditional testing for when the 's' key is pressed
  if (keyCode == 83)
  {
    // Increment timesSPressed
    timesSPressed++;
    // Conditional setting sPressedOdd to true if timesSPressed is odd
    if (timesSPressed % 2 != 0)
    {
      sPressedOdd = true;
    }
    else
    {
      sPressedOdd = false;
    }
  }
  // Conditional testing for when the 'l' key is pressed
  if (keyCode == 76)
  {
    // Increment timesLPressed
    timesLPressed++;
    // Conditional setting lPressedOdd to true if timesLPressed is odd
    if (timesLPressed % 2 != 0)
    {
      lPressedOdd = true;
    }
    else
    {
      lPressedOdd = false;
    }
  }
  // Conditional testing for when the 'b' key is pressed
  if (keyCode == 66)
  {
    // Increment timesBPressed
    timesBPressed++;
    // Conditional setting bPressedOdd to true if timesBPressed is odd
    if (timesBPressed % 2 != 0)
    {
      bPressedOdd = true;
    }
    else
    {
      bPressedOdd = false;
    }
  }
  
  // Conditional testing for when the 'c' key is pressed
  if (keyCode == 67)
  {
    // Increment timesCPressed
    timesCPressed++;
    // Conditional setting cPressedOdd to true if timesCPressed is odd
    if (timesCPressed % 2 != 0)
    {
      cPressedOdd = true;
    }
    else
    {
      cPressedOdd = false;
    }
  }
  // Conditional testing for when the space key is pressed
  if (keyCode == ' ')
  {
    spacePressed = true;
  }
}
