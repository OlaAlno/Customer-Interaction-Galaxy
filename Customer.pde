// --- Customer Class ---
class Customer {
  String type, item, interaction, mood, outcome;
  int busy;
  float duration;

  PVector pos;
  PVector vel;
  float size;
  color col;
  int alphaVal;

  Customer(String t, String i, String inter, String m, String o, int b, float d) {
    type = t;
    item = i;
    interaction = inter;
    mood = m;
    outcome = o;
    busy = b;
    duration = d;

    pos = new PVector(random(width), random(height));
    vel = PVector.random2D();
    vel.mult(random(0.5, 2));
    size = map(duration, 1, 10, 10, 40);
    col = moodColor();
    alphaVal = 255;
  }

  void update() {
    pos.add(vel);
    if (pos.x < 0) pos.x = width;
    if (pos.x > width) pos.x = 0;
    if (pos.y < 0) pos.y = height;
    if (pos.y > height) pos.y = 0;
  }

  void display() {
    if (this == selected) return; // selected star drawn separately
    fill(col, alphaVal);
    drawStar(pos.x, pos.y, size * 0.3, size * 0.6, 5);
  }

  boolean isMouseOver(float mx, float my) {
    return dist(mx, my, pos.x, pos.y) < size / 2;
  }

  color moodColor() {
    if (mood.equals("Happy")) return color(90, 80, 100);
    if (mood.equals("Neutral")) return color(180, 60, 100);
    if (mood.equals("Unsure")) return color(30, 100, 100); 
    if (mood.equals("Frustrated")) return color(330, 80, 100);
    return color(0, 0, 70);
  }

  void drawStar(float x, float y, float inner, float outer, int points) {
    float angle = TWO_PI / (points*2);
    beginShape();
    for (int i = 0; i < points*2; i++) {
      float r = (i % 2 == 0) ? outer : inner;
      float px = x + cos(i * angle) * r;
      float py = y + sin(i * angle) * r;
      vertex(px, py);
    }
    endShape(CLOSE);
  }
}
