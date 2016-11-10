
class Vehicle {
  
  PImage img;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float maxforce;        // Máxima fuerza de dirección, limitar su magnitud según el tipo de objeto
  float maxspeed;        // Máxima velocidad


  Vehicle() {
    img = loadImage ("pana1.png");
   
    acceleration = new PVector(0,0);                             // Iniciar aceleración en 0
    velocity = new PVector(0,0);                                 // Iniciar velocidad en 0
    position = new PVector(random(width),random(height));        // Iniciar posición random
    maxspeed = random(5, 10);
    maxforce = 0.5;
  }


  // Método para actualizar la posición
  void update() {
    velocity.add(acceleration);      // Actualizar velocidad
    velocity.limit(maxspeed);        // Limitar la velocidad
    position.add(velocity);          // Obtener la nueva posición
    acceleration.mult(0);            // Resetear acelaración a 0 en cada ciclo para que no vaya aumentando
   }


  // Método para aplicarle todas las fuerzas (PVector) que creé
  // Se puede agregar la masa, A = F / M
  void applyForce(PVector force) {
    acceleration.add(force);
  }


  // Calcular la fuerza de dirección hacia el target (mouse)
  void arrive(PVector target) {
    PVector desired = PVector.sub(target,position);  // desired = vector desde la posición al target
    float d = desired.mag();
      // Si la distancia entre el objeto y el target es menor a 100 píxeles...
    if (d < 100) {
      float m = map(d,0,100,0,maxspeed);
      desired.setMag(m);
    } else {
      // Proceder al máximo de velocidad (maxspeed)
      desired.setMag(maxspeed);
    }

    
    // Fuerza de dirección (steering) = velocidad deseada (desired) - velocidad actual (velocity)
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limitar a la máxima fuerza de dirección
    applyForce(steer);
  }
  
  void separate (ArrayList<Vehicle> vehicles) {
    float desiredseparation = random (0, 300); 
    PVector sum = new PVector();
    int count = 0;
    // buscar todos los elementos en la lista "vehicles" y traer cada elemento,
    // uno atrás de otro, a la variable(objeto) "other"
    for (Vehicle other : vehicles) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < desiredseparation)) {
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        // Mientras más cerca esta el vehículo de otro más se tiene que alejar 
        // (mayor la magnitud del PVector que los aleja), mientras nmás lejos, menos.
        // Dividimos por la distancia para calcular adecuadamente
        diff.div(d); 
        sum.add(diff);
        count++;

      }
    }
    
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }

  }
  
  
  void display() {
     pushMatrix();
     translate(position.x,position.y);
     image(img, 20, 30, 40, 40);
     popMatrix();
  }
}