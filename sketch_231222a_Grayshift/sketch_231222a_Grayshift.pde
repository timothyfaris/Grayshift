PImage img;

int low;
int mid;
int high;

float rl;
float gl;
float bl;

float rm;
float gm;
float bm;

float rh;
float gh;
float bh;

FloatList redlow;
FloatList greenlow;
FloatList bluelow;

float redlowSum;
float greenlowSum;
float bluelowSum;

float redlowOffset;
float greenlowOffset;
float bluelowOffset;

FloatList redmid;
FloatList greenmid;
FloatList bluemid;

float redmidSum;
float greenmidSum;
float bluemidSum;

float redmidOffset;
float greenmidOffset;
float bluemidOffset;

FloatList redhigh;
FloatList greenhigh;
FloatList bluehigh;

float redhighSum;
float greenhighSum;
float bluehighSum;

float redhighOffset;
float greenhighOffset;
float bluehighOffset;

//low
int r1;
int r2;
//mid
int r3;
int r4;
//high
int r5;
int r6;

//shadows = 0 - 85        or should it be 0-64?
//mids = 85 - 170        or should it be 64-193?
//highlights = 170 - 255        or should it be 193-255?

// is this working as effectively as isolating 50% alone? does it make sense to need to isolate 25,50, and 75% gray values?
// still thinking that this is not an accurate way of defining these discrete zones
// would it be better or more efficient to use a threshold filter directly, rather than needing to run these pixel arrays  ---> filter(THRESHOLD); converts to b/w
// http://localhost:8053/reference/filter_.html

void setup() {
  size(3280, 2464); 
  img = loadImage("RPI400163_curves.jpg"); 

  img.loadPixels();

  redlow = new FloatList();
  greenlow = new FloatList();
  bluelow = new FloatList();

  redmid = new FloatList();
  greenmid = new FloatList();
  bluemid = new FloatList();

  redhigh = new FloatList();
  greenhigh = new FloatList();
  bluehigh = new FloatList();

  redlowSum = 0;
  greenlowSum = 0;
  bluelowSum = 0;

  redmidSum = 0;
  greenmidSum = 0;
  bluemidSum = 0;

  redhighSum = 0;
  greenhighSum = 0;
  bluehighSum = 0;

  //low = 25% B
  r1 = 54;
  r2 = 74;
  //mid = 50% B
  r3 = 119;
  r4 = 139;
  //high = 75% B
  r5 = 183;
  r6 = 203;

  //---------------------------------------------------------------------low
  for (int i = 0; i < img.width * img.height; i++) {

    rl = red(img.pixels[i]);
    gl = green(img.pixels[i]);
    bl = blue(img.pixels[i]);

    if ((rl >= r1 && rl <= r2) && (gl >= r1 && gl <= r2) && (bl >= r1 && bl <= r2)) {

      low++;

      redlow.append(rl);
      greenlow.append(gl);
      bluelow.append(bl);
    }
  }

  for (int p = 0; p < low; p++ ) {

    redlowSum = redlowSum + redlow.get(p);
    greenlowSum = greenlowSum + greenlow.get(p);
    bluelowSum = bluelowSum + bluelow.get(p);
  }

  redlowOffset = redlowSum / low - 64;
  greenlowOffset = greenlowSum / low - 64;
  bluelowOffset = bluelowSum / low - 64;

  for (int i = 0; i < img.width * img.height; i++) {

    rl = red(img.pixels[i]);
    gl = green(img.pixels[i]);
    bl = blue(img.pixels[i]);

    img.pixels[i] = color(round(rl - redlowOffset), round(gl - greenlowOffset), round(bl - bluelowOffset));
  }

  // -------------------------------------------------------------------------------- mid
  for (int ii = 0; ii < img.width * img.height; ii++) {

    rm = red(img.pixels[ii]);
    gm = green(img.pixels[ii]);
    bm = blue(img.pixels[ii]);

    if ((rm >= r3 && rm <= r4) && (gm >= r3 && gm <= r4) && (bm >= r3 && bm <= r4)) {

      mid++;

      redmid.append(rm);
      greenmid.append(gm);
      bluemid.append(bm);
    }
  }

  for (int pp = 0; pp < mid; pp++ ) {

    redmidSum = redmidSum + redmid.get(pp);
    greenmidSum = greenmidSum + greenmid.get(pp);
    bluemidSum = bluemidSum + bluemid.get(pp);
  }

  redmidOffset = redmidSum / mid - 129;
  greenmidOffset = greenmidSum / mid - 129;
  bluemidOffset = bluemidSum / mid - 129;

  for (int ii = 0; ii < img.width * img.height; ii++) {

    rm = red(img.pixels[ii]);
    gm = green(img.pixels[ii]);
    bm = blue(img.pixels[ii]);

    img.pixels[ii] = color(round(rm - redmidOffset), round(gm - greenmidOffset), round(bm - bluemidOffset));
  }

  //----------------------------------------------------------------high
  for (int iii = 0; iii < img.width * img.height; iii++) {

    rh = red(img.pixels[iii]);
    gh = green(img.pixels[iii]);
    bh = blue(img.pixels[iii]);

    if ((rh >= r5 && rh <= r6) && (gh >= r5 && gh <= r6) && (bh >= r5 && bh <= r6)) {

      high++;

      redhigh.append(rh);
      greenhigh.append(gh);
      bluehigh.append(bh);
    }
  }

  for (int ppp = 0; ppp < high; ppp++ ) {

    redhighSum = redhighSum + redhigh.get(ppp);
    greenhighSum = greenhighSum + greenhigh.get(ppp);
    bluehighSum = bluehighSum + bluehigh.get(ppp);
  }

  redhighOffset = redhighSum / high - 193;
  greenhighOffset = greenhighSum / high - 193;
  bluehighOffset = bluehighSum / high - 193;

  for (int iii = 0; iii < img.width * img.height; iii++) {

    rh = red(img.pixels[iii]);
    gh = green(img.pixels[iii]);
    bh = blue(img.pixels[iii]);

    img.pixels[iii] = color(round(rh - redhighOffset), round(gh - greenhighOffset), round(bh - bluehighOffset));



  }
  updatePixels();
  println(redlowOffset,greenlowOffset,bluelowOffset);
  println(redmidOffset,greenmidOffset,bluemidOffset);
  println(redhighOffset,greenhighOffset,bluehighOffset);
  
}



void draw () {
  image(img, 0, 0, 3280, 2464);
  if (mousePressed) {
          saveFrame("output/frame###.jpg"); 
  }
}
