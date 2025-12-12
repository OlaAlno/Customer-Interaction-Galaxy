// --- Global Variables ---
float backgroundSpeed = 0.02;  // Background movement speed
float[] starX, starY;
int numStars = 500;
float flickerSpeed = 0.002;

ArrayList<Customer> customers;
ArrayList<Connection> connections;
float maxLinkDist = 150;

// Selected star info
Customer selected = null;
float zoomSize = 40; // zoomed star size

void setup() {
  size(1000, 700);
  colorMode(HSB, 360, 100, 100, 100);
  noStroke();

  // Initialize background stars
  starX = new float[numStars];
  starY = new float[numStars];
  for (int i = 0; i < numStars; i++) {
    starX[i] = random(width);
    starY[i] = random(height);
  }

  customers = new ArrayList<Customer>();
  connections = new ArrayList<Connection>();

  loadData();

  // Initialize connections
  for (int i = 0; i < customers.size(); i++) {
    for (int j = i + 1; j < customers.size(); j++) {
      connections.add(new Connection(customers.get(i), customers.get(j)));
    }
  }
}

void draw() {
  background(0);

  drawGalaxyBackground();

  Customer hovered = null;

  // Update + display stars
  for (Customer c : customers) {
    c.update();
    c.display();

    if (c.isMouseOver(mouseX, mouseY)) {
      hovered = c;
    }
  }

  // Draw connections
  for (Connection con : connections) {
    con.display();
  }

  // Hover tooltip (only if no star selected)
  if (hovered != null && selected == null) {
    resetMatrix();
    drawTooltip(hovered);
  }

  // Selected star info card
  drawZoomInfo();
}

void keyPressed() {
  if (key == 's' || key == 'S') { // Check if the key is 's' or 'S'
  save("dear_data_snapshot.png"); // Save the image as PNG in the sketch folder
  println("Image saved!");
  }
}

// --- CSV Loader ---
void loadData() {
  String[] rows = loadStrings("Data_Collection.csv");

  if (rows == null) {
    println("ERROR: CSV not found.");
    exit();
  }

  for (int i = 1; i < rows.length; i++) {
    String row = rows[i].trim();
    if (row.length() == 0) continue;
    String[] d = split(row, ',');
    if (d.length == 8) {
      customers.add(new Customer(d[1], d[2], d[3], d[4], d[5], int(d[6]), float(d[7])));
    }
  }
}

// --- Background Galaxy ---
void drawGalaxyBackground() {
  noStroke();
  fill(255, 204, 0, 60);
  for (int i = 0; i < 2; i++) {
    float x = random(width);
    float y = random(height);
    float size = random(300, 500);
    ellipse(x, y, size, size);
  }

  fill(255, 255, 255, random(30, 100));
  for (int i = 0; i < numStars; i++) {
    starX[i] -= backgroundSpeed * random(0.5, 1.5);
    starY[i] += random(-0.5, 0.5);

    if (starX[i] < 0) starX[i] = width;
    if (starX[i] > width) starX[i] = 0;
    if (starY[i] < 0) starY[i] = height;
    if (starY[i] > height) starY[i] = 0;

    ellipse(starX[i], starY[i], random(1, 3), random(1, 3));
  }
}

// --- Tooltip ---
void drawTooltip(Customer c) {
  String info = "Star Info:\n" +
                "Type: " + c.type + "\n" +
                "Mood: " + c.mood + "\n" +
                "Outcome: " + c.outcome + "\n" +
                "Item: " + c.item + "\n" +
                "Interaction: " + c.interaction + "\n" +
                "Busy Level: " + c.busy + "\n" +
                "Duration: " + c.duration +
                "\nClick to view!";

  fill(0, 200);
  noStroke();
  rect(mouseX + 15, mouseY + 15, 220, 120, 10);

  fill(255);
  textSize(12);
  text(info, mouseX + 25, mouseY + 25);
}

// --- Mouse Click selects star ---
void mousePressed() {
  selected = null;
  for (int i = customers.size() - 1; i >= 0; i--) {
    Customer c = customers.get(i);
    if (c.isMouseOver(mouseX, mouseY)) {
      selected = c;
      return;
    }
  }
}

// --- Zoom Info Card ---
void drawZoomInfo() {
  if (selected == null) return;

  float cardX = selected.pos.x + 50;
  float cardY = selected.pos.y - 20;

  // Glow + zoomed star
  pushMatrix();
  translate(selected.pos.x, selected.pos.y);
  noStroke();
  fill(selected.col, 80);
  ellipse(0, 0, zoomSize * 1.7, zoomSize * 1.7);
  fill(selected.col);
  selected.drawStar(0, 0, zoomSize * 0.4, zoomSize * 0.8, 5);
  popMatrix();

  // Info card rectangle
  fill(0, 200);
  noStroke();
  rect(cardX, cardY, 260, 180, 12);

  fill(255);
  textSize(12);
  text("Customer Interaction", cardX + 10, cardY + 20);
  text("--------------------------------", cardX + 10, cardY + 35);
  text("Type: " + selected.type, cardX + 10, cardY + 55);
  text("Mood: " + selected.mood, cardX + 10, cardY + 75);
  text("Item: " + selected.item, cardX + 10, cardY + 95);
  text("Outcome: " + selected.outcome, cardX + 10, cardY + 115);
  text("Busy Level: " + selected.busy, cardX + 10, cardY + 135);
  text("Duration: " + selected.duration, cardX + 10, cardY + 155);
}

// --- Update connections (if you want to remove stars in future) ---
void updateConnections() {
  connections.clear();
  for (int i = 0; i < customers.size(); i++) {
    for (int j = i + 1; j < customers.size(); j++) {
      connections.add(new Connection(customers.get(i), customers.get(j)));
    }
  }
}

// --- Connection Class ---
class Connection {
  Customer p1, p2;

  Connection(Customer a, Customer b) {
    p1 = a;
    p2 = b;
  }

  void display() {
    float d = dist(p1.pos.x, p1.pos.y, p2.pos.x, p2.pos.y);
    if (d < maxLinkDist) {
      float alpha = map(d, 0, maxLinkDist, 255, 0);
      stroke(255, 100, 255, alpha);
      strokeWeight(2);
      line(p1.pos.x, p1.pos.y, p2.pos.x, p2.pos.y);
    }
  }
}
