/* ------------------------------------------
AUTHOR : Simon Talaga
STUDENT NUMBER : 160386983
PROCESSING VERSION : 3.4
------------------------------------------ */

// All the used musical samples are copyright-free and taken from https://freewavesamples.com/, except 2 of my own : piano.wav and dodo.wav

//TODO: voir pour la différence entre partie réelle du spectre et bandes de fréquences
//TODO : implémenter diamant carré pour faire du noise
//TODO : faire une colormap pour les hauteurs OK
//TODO : faire de l'eau OK
//TODO : mettre un shader ?
//TODO : textures ?
//TODO : filtrage passe haut / bas sur la color map OK
//TODO :   display / hide image du spectre OK

/////////////////////////////////////////
//              CONTROLS               // 
/////////////////////////////////////////
//
//   /!\ Turn the sound on
//
// I'm sorry I didn't have the time to implement better controls. A lot of parameters are adjustable directly in the code, which, I confess, is pretty bad.
//
// 'i' -- Shows or hides the average the spectrum 
// 'd' -- Shows or hides the live 3D the spectrum (experimental)
// 'c' -- Takes a screenshot and saves it in a folder called "screenshots".
// + Use the mouse to rotate the 3D terrain


/////////////////////////////////////////
//               PARAMS                // 
/////////////////////////////////////////
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
float points[], avgPoints[];
boolean hasPlayed = false;
int timesAdded = 0;
// Change this to increase the resolution of the terrain (values > 150 are likely to slow down the sketch)
int resolution = 130;
// This is the amplitude factor for the terrain. Higher values will lead to higher mountains and deeper trenches
int terrainAmp = 15;
color[] colorMap;
color[] skyColorMap;
AudioPlayer audioSample;
FFT fft;

// Values used to filter the spectrum
int lowPass = 0;
int highPass = 0;

boolean toggleSpectrum = true;
boolean toggle3DSpectrum = false;

// Change this manually with the files in the folder, or add your own !
String filename = "clarinet.wav";

void setup()
{
  size(800, 800, P3D);
  fill(255);  
  smooth(4);
  strokeWeight(1/80.0);
  
  // Loads the color map for the heights
  PImage colorMapImage = loadImage("colorMap.png");
  colorMapImage.loadPixels();
  colorMap = colorMapImage.pixels;

  // Loads the color map for the sky
  PImage skyColorMapImage = loadImage("skyColorMap.png");
  skyColorMapImage.loadPixels();
  skyColorMap = skyColorMapImage.pixels;

  colorMode(RGB, 255);
  //colorMode(HSB, 360, 100, 100);
  avgPoints = new float[resolution];
  minim = new Minim(this);

  audioSample = minim.loadFile(filename, 512);
  audioSample.play();

  fft = new FFT(audioSample.bufferSize(), audioSample.sampleRate());
}

// Draws the sky depending on the sky colour map (an image in the folder)
void drawSky() {
  for (int i = 0; i < width * height; i++) {
    set(i % width, i / width, skyColorMap[round(map(i / height, 0, height, 0, 255))]);
  }
}

void draw()
{
  background(128);
  drawSky();
  lights();
  points = new float[resolution];

  if (audioSample.isPlaying()) {
    hasPlayed = true;
    fft.forward(audioSample.mix);

    // Gets the stronger frequency
    float amp = 0;
    int maxIndex = 0;
    for (int i = 0; i < fft.specSize(); i++) {
      if (amp < fft.getBand(i)) {
        amp = fft.getBand(i);
        maxIndex = i;
      }
    }
    
    // Used to compute the shape of the timbre
    float maxFreq = 0.0 + fft.indexToFreq(maxIndex);
    
    
    /////////////////////////////////////////
    //         UNCOMMENT TO FILTER         // 
    /////////////////////////////////////////
    // 1/40 of the spectrum is low-passed
    //lowPass = fft.specSize() / 40;
    // 1/3 of the spectrum is high-passed
    //highPass = fft.specSize() - (fft.specSize() / 3);    
   
    for (int i = 0 + lowPass; i < fft.specSize() - highPass; i++)
    {
      float freq = fft.indexToFreq(i);
      points = addWave(points, maxFreq, freq, fft.getFreq(freq), atan2(fft.getSpectrumImaginary()[i], fft.getSpectrumReal()[i]));
      
      // This two lines of code are part of the process of averaging all the values to compute simply the "signature" of the audio sample 
      avgPoints = addArray(avgPoints, points);
      timesAdded++;
    }

    if(toggle3DSpectrum) {
      // Draws the terrain on live
      translate(width - 200, 200, -200);
      float rx = map(mouseX, 0,width,-PI,PI);
      float ry = map(mouseY, 0,height,-PI,PI); 
      rotateY(rx);
      rotateX(ry);
      rotateX(0.40);
      scale(5);
      
      for (int y = 0; y < resolution - 1; y++) {
        beginShape(QUAD_STRIP);
        for (int x = 0; x <= resolution - 1; x++) {
          int colorValue = (int) map(points[x] + points[y], min(points), max(points), 0, 255);
          color c = color(colorValue, colorValue, colorValue);
          fill(c);
          float z = (int) map(points[x] + points[y], min(points), max(points), -terrainAmp, terrainAmp);
          vertex(x, y, -z);
          z = (int) map(points[x] + points[y + 1], min(points), max(points), -terrainAmp, terrainAmp);
          vertex(x, y+1, -z);
        }
        endShape();
      }
    }
    
    for (int i = 0; i < resolution; i++)
    {
      for (int j = 0; j < resolution; j++) {
        if (min(points) < max(points)) {
          color c = color((int) map(points[i] + points[j], min(points), max(points), 0, 255), (int) map(points[i] + points[j], min(points), max(points), 0, 255), (int) map(points[i] + points[j], min(points), max(points), 0, 255));
          //color c = colorMap[(int) map(points[i] + points[j], min(points), max(points), 0, 255)];
          set(i, j, c);
        }
      }
    }
    
  } else if (!audioSample.isPlaying() && hasPlayed == true) {
    hasPlayed = false;
    avgPoints = scaleArray(avgPoints, timesAdded);
  } else {
    // Draws the grid
    translate(width - 200, 200, -200);
    float rx = map(mouseX, 0, width, -PI, PI);
    float ry = map(mouseY, 0, height, -PI, PI); 
    rotateY(rx);
    rotateX(ry);
    rotateX(0.40);
    scale(5);

    // Creates the terrain
    for (int y = 0; y < resolution - 1; y++) {
      beginShape(QUAD_STRIP);
      for (int x = 0; x <= resolution - 1; x++) {
        int colorValue = (int) map(avgPoints[x] + avgPoints[y], min(avgPoints), max(avgPoints), 0, 255);
        if (colorValue > 255)
          colorValue = 255;
        if (colorValue < 0)
          colorValue = 0;

        color c = colorMap[colorValue];
        //color c = color(colorValue, colorValue, colorValue);
        fill(c);
        float z = (int) map(avgPoints[x] + avgPoints[y], min(avgPoints), max(avgPoints), -terrainAmp, terrainAmp);
        vertex(x, y, -z);
        z = (int) map(avgPoints[x] + avgPoints[y + 1], min(avgPoints), max(avgPoints), -terrainAmp, terrainAmp);
        vertex(x, y+1, -z);
      }
      endShape();
    }

    // Creates the water
    for (int y = 0; y < resolution - 1; y++) {
      beginShape(QUAD_STRIP);
      for (int x = 0; x <= resolution - 1; x++) {
        fill(color(73, 166, 238));
        float z = 5;
        vertex(x, y, z);
        vertex(x, y+1, z);
      }
      endShape();
    }

    if(toggleSpectrum) {
      // Creates the image of the heightmap
      for (int i = 0; i < resolution; i++)
      {
        for (int j = 0; j < resolution; j++) {
          if (min(avgPoints) < max(avgPoints)) {
            int colorValue = (int) map(avgPoints[i] + avgPoints[j], min(avgPoints), max(avgPoints), 0, 255);
            color c = color(colorValue, colorValue, colorValue);
            set(i, j, c);
          }
        }
      }
    }
  }
}

// Returns the index where the max value of an array is at 
int maxAtIndex(float[] array) {
  int currentIndex = 0;
  for (int i = 0; i < array.length; i++) {
    if (array[currentIndex] < array[i])
      currentIndex = i;
  }
  return currentIndex;
}

// Given a set of samples, this method computes a specific sine wave and adds the values to the samples. 
float[] addWave(float[] samples, float found, float freq, float amp, float phase) {
  for (int i = 0; i < samples.length; i++) {
    float t = 1.0 / (found * resolution);
    // Increase this value to see the waveform repeated cycles times
    int cycles = 1;
    // On centre sur la fréquence maximale pour faire un cycle
    samples[i] += amp * sin(TWO_PI * freq * i * t * cycles + phase);
  }
  return samples;
}


float[] addArray(float[] array1, float[] array2) {
  if (array1.length == array2.length) {
    for (int i = 0; i < array1.length; i++) {
      array1[i] += array2[i];
    }
  }
  return array1;
}

float[] scaleArray(float[] array1, float factor) {
  for (int i = 0; i < array1.length; i++) {
    array1[i] /= factor;
  }
  return array1;
}

void keyPressed() {
  if (key == 's' && audioSample.isPlaying())
    audioSample.pause();
  else if (key == 'i')
    toggleSpectrum = !toggleSpectrum;
  else if (key == 'd')
    toggle3DSpectrum = !toggle3DSpectrum;  
  else if (key == 'c')
    saveFrame("screenshots/" + filename + frameCount + ".png");
}
