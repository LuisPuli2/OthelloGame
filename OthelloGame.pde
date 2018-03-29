import java.util.Scanner;
/* Clase que emula un tablero para el juego de Othello */
class Tablero {
  int[][] tablero;
  int dimension; 
  boolean turno; 
  int negras;
  int blancas;
  
  /* Constructor */
  Tablero(int N) {
      this.tablero = new int[N][N];
      this.dimension = N; 
      this.turno = false; 
      this.negras = 2; 
      this.blancas = 2; 
      /* Son las cuatro fichas en el centro */
      tablero[(this.dimension/2)-1][(this.dimension/2)-1] = 1;
      tablero[(this.dimension/2)-1][this.dimension/2] = -1;
      tablero[this.dimension/2][(this.dimension/2)-1] = -1;
      tablero[this.dimension/2][this.dimension/2] = 1;
    }
  
  
  boolean getTurno() {
    return this.turno; 
  }
  
  void setTurno(boolean turno) {
    this.turno = turno; 
  }
  
  void setBlancasNegras(){
   int color_aux = turno?1:-1;
   int negras = 0;
   int blancas = 0; 
   for (int i = 0; i < this.dimension; i++) {
     for (int j = 0; j < this.dimension; j++) {
       if (this.tablero[i][j] == 1) {
          blancas++;
        } else if (this.tablero[i][j] == -1) {
          negras++; 
        }
      }
    }
   if (color_aux==1)  blancas++;
   else  negras++;
    this.negras = negras; 
    this.blancas = blancas;
 }

  void display() {
    int recH = 512/this.dimension;
    int recV = width/this.dimension;

    for (int i = 0; i < this.dimension+1; i++) {
      line(recH*i, 0, recH*i, 512); 
      line(0, recV*i, width, recV*i);
    }

    for (int i = 0; i < this.dimension; i++) {
      for (int j = 0; j < this.dimension; j++) {
        if (this.tablero[i][j] == 1) {
          fill(255);
          noStroke();
          ellipse((j*recV) + (recV/2), (i*recV) + (recV/2), recV*3/4, recV*3/4);
        } else if (this.tablero[i][j] == -1) {
          fill(0);
          noStroke();
          ellipse((j*recV) + (recV/2), (i*recV) + (recV/2), recV*3/4, recV*3/4);
        }
      }
    }
    
    fill(114, 255, 224);
    rect(10, 532, 250, 600);
    textSize(40);
    fill(255);
    text("Blancas:"+ this.blancas , 10, 532, 250, 600);
    
    fill(114, 255, 224);
    rect(286, 532, 512, 600);
    textSize(40);
    fill(10);
    text("Negras:"+ this.negras , 286, 532, 512, 600);
    
  }
  
  /*Regresa true si el juego aun no termina. False en otro caso*/
  public boolean noTermine(){
    for (int i =0;i<tablero.length ;i++ ) {
      for (int j =0;j<tablero.length ;j++ ) {
        if (tablero[i][j]==0) 
          return true;  
      }
    }
    return false; 
  }

  int hayDiagonalInferiorIzq (int fila, int columna,int turno_actual){
    /* Para no salir del intervalo */
    if (columna == dimension-1 || fila == 0) return 0;
    int fichas = 0;
    int turno_oponente=(turno_actual==1)?-1:1;
    columna ++;
    fila --;
    while (fila > 0 && columna < dimension-1  && tablero[fila][columna] == turno_oponente){
      fichas++;
      columna ++;
      fila --;
    } 
    /* Si no es válido. */
    if (tablero[fila][columna] != turno_actual) return 0;
    return fichas;
  }

  /* Recibe las coordenadas de la tirada */
  boolean generaDiagonalInferiorIzq (int fila, int columna,int turno_actual){
    /* Coloreamos las fichas del nuevo turno,  ahora que sabemos que son válidas */
    int fichas = hayDiagonalInferiorIzq(fila,columna,turno_actual);
    int i = 1;
    while (i <= fichas ){
      columna ++;
      fila --;
      i++;
      tablero[fila][columna] = turno_actual;
    }
    return fichas > 0;
  }

  int hayDiagonalSuperiorDer (int fila, int columna,int turno_actual){
    if (fila == dimension-1 || columna == 0) return 0;
    int fichas = 0;
    int turno_oponente=(turno_actual==1)?-1:1;
    columna--; fila ++;
    while (columna > 0 && fila < dimension-1  && tablero[fila][columna] == turno_oponente){
      fichas ++;
      columna --;
      fila ++;
    }  
    /* Si no es válido. */
    if (tablero[fila][columna] != turno_actual) return 0;
    return fichas;
  }

  /* Recibe las coordenadas de la tirada */
  boolean generaDiagonalSuperiorDer (int fila, int columna,int turno_actual){
    /* Coloreamos las fichas del nuevo turno,  ahora que sabemos que son válidas */
    int fichas = hayDiagonalSuperiorDer(fila,columna,turno_actual);
    int i =1;
    while (i <= fichas){
      columna --;
      fila ++;
      i++;
      tablero[fila][columna] = turno_actual;
    }
    return fichas > 0;
  }

  int hayDiagonalSuperiorIzq (int fila, int columna,int turno_actual){
    /* Para no salir del intervalo */
    if (columna == dimension-1 || fila == dimension-1) return 0;
    int fichas = 0;
    int turno_oponente=(turno_actual==1)?-1:1;
    columna++; fila ++;
    while (fila < dimension-1 && columna < dimension-1  && tablero[fila][columna] == turno_oponente){
      fichas++;
      columna ++;
      fila ++;
    }  
    /* Si no es válido. */
    if (tablero[fila][columna] != turno_actual) return 0;
    return fichas;
  }

  /* Recibe las coordenadas de la tirada */
  boolean generaDiagonalSuperiorIzq (int fila, int columna,int turno_actual){
    int fichas = hayDiagonalSuperiorIzq(fila,columna,turno_actual);
    /* Coloreamos las fichas del nuevo turno,  ahora que sabemos que son válidas */
    int i =1;
    while (i <= fichas){
      columna++;
      fila ++;
      i++;
      tablero[fila][columna] = turno_actual;
    }
    return fichas > 0;
  }

  int hayDiagonalInferiorDer (int fila, int columna,int turno_actual){
    if (columna == 0 || fila == 0) return 0;
    int turno_oponente=(turno_actual==1)?-1:1;
    int fichas = 0;
    /* A la inversa */
    columna--; fila --;
    while (fila>0 && columna > 0  && tablero[fila][columna] == turno_oponente){
      columna --;
      fila --;
      fichas ++;
    }  
    /* Si no es válido. */
    if (tablero[fila][columna] != turno_actual) return 0;
    return fichas;
  }

  boolean generaDiagonalInferiorDer (int fila, int columna,int turno_actual){
    int fichas = hayDiagonalInferiorDer(fila,columna,turno_actual);
    /* Coloreamos las fichas del nuevo turno,  ahora que sabemos que son válidas */
    int i = 1; 
    while (i<= fichas){
      columna--;
      fila --;
      i++;
      tablero[fila][columna] = turno_actual;
    }
    return fichas > 0;
  }

  int hayJugadaDerecha (int fila, int columna,int turno_actual){
    /* Para no salir del intervalo */
    if (columna == dimension-1) return 0;
    int fichas = 0;
    int turno_oponente=(turno_actual==1)?-1:1;
    columna++;
    while (columna < dimension-1  && tablero[fila][columna] == turno_oponente){
      columna++;
      fichas ++;
    }  
    /* Si no es válido. */
    if (tablero[fila][columna] != turno_actual) return 0;
    return fichas;
  }

  /* Recibe las coordenadas de la tirada */
  boolean generaJugadaDerecha (int fila, int columna,int turno_actual){
    int fichas = hayJugadaDerecha(fila,columna,turno_actual);
    /* Coloreamos las fichas del nuevo turno,  ahora que sabemos que son válidas */
    int i =1;
    while (i<= fichas ) {
      columna++;
      i++;
      tablero[fila][columna] = turno_actual;
    }
    return fichas > 0;
  }

  int hayJugadaAbajo (int fila, int columna,int turno_actual){
    /* Para no salir del intervalo */
    if (fila == dimension-1) return 0;
    int fichas = 0;
    int turno_oponente=(turno_actual==1)?-1:1;
    fila++;
    while (fila < dimension-1  && tablero[fila][columna] == turno_oponente){
      fichas ++;
      fila++;
    }  
    /* Si no es válido. */
    if (tablero[fila][columna] != turno_actual) return 0;
    return fichas;
  }

  /* Recibe las coordenadas de la tirada */
  boolean generaJugadaAbajo(int fila, int columna,int turno_actual){
    int fichas = hayJugadaAbajo(fila,columna,turno_actual);
    int i = 1;
    /* Coloreamos las fichas del nuevo turno,  ahora que sabemos que son válidas */
    while (i<=fichas) {
      fila++;
      i++;
      tablero[fila][columna] = turno_actual;
    }
    return fichas > 0;
  }

  int hayJugadaArriba(int fila, int columna,int turno_actual){
    /* Para no salir del intervalo */
    if (fila == 0) return 0;
    int fichas = 0;
    int turno_oponente=(turno_actual==1)?-1:1;
    fila--;
    while (fila > 0  && tablero[fila][columna] == turno_oponente){
      fila--;
      fichas ++;
    }  
    /* Si no es válido. */
    if (tablero[fila][columna] != turno_actual) return 0;
    return  fichas;
  }

  /* Recibe las coordenadas de la tirada */
  boolean generaJugadaArriba(int fila, int columna,int turno_actual){
    int fichas = hayJugadaArriba(fila,columna,turno_actual);
    int i = 1;
    /* Coloreamos las fichas del nuevo turno,  ahora que sabemos que son válidas */
    while (i <= fichas) {
      fila--;
      i++;
      tablero[fila][columna] = turno_actual;
    }
    return fichas>0;
  }

  int hayJugadaIzquierda(int fila, int columna,int turno_actual){
    /* Para no salir del intervalo */
    if (columna == 0) return 0;
    int fichas = 0;
    int turno_oponente=(turno_actual==1)?-1:1;
    columna--;
    while (columna > 0  && tablero[fila][columna] == turno_oponente){
      columna--;
      fichas ++;
    }  
    /* Si no es válido. */
    if (tablero[fila][columna] != turno_actual) return 0;
    return fichas;
  }

  /* Recibe las coordenadas de la tirada */
  boolean generaJugadaIzquierda (int fila, int columna,int turno_actual){
    int fichas = hayJugadaIzquierda(fila,columna,turno_actual);
    int i = 1;
    /* Coloreamos las fichas del nuevo turno,  ahora que sabemos que son válidas */
    while (i<=fichas) {
      columna--;
      i++;
      tablero[fila][columna] = turno_actual;
    }
    return fichas > 0;
  }

  /*  
    Calcula todas las jugadas disponibles para la máquina. 
    Regresa una arreglo de dos posiciones; la primera indica las filas, la segunda las columnas. 
  */
  int[] calcula_jugadas (boolean turno){
    int turno_actual = turno?1:-1;
    int fichas;
    /* Temporales */
    int fila,columna,max;
    fila = -1;
    columna = -1;
    max = 0;
    for (int i = 0;i<dimension ;i++ ) {
      for (int j = 0;j<dimension ;j++ ) {
        fichas = 0;
        if (tablero[i][j]==0) {
          fichas += hayJugadaIzquierda (i,j,turno_actual);
          fichas += hayJugadaArriba (i,j,turno_actual);
          fichas += hayJugadaAbajo (i,j,turno_actual);
          fichas += hayJugadaDerecha (i,j,turno_actual);
          fichas += hayDiagonalInferiorDer (i,j,turno_actual);
          fichas += hayDiagonalInferiorIzq (i,j,turno_actual);
          fichas += hayDiagonalSuperiorIzq (i,j,turno_actual);
          fichas += hayDiagonalSuperiorDer (i,j,turno_actual);
          /* Si encontró un tiro mejor. */
          if (max < fichas ) {
            println("Hay jugada disponible en: " + i + ","+ j +", perro.");
            println(fichas);
            max = fichas;
            fila = i;
            columna = j;
          }
        }
      }
    }
    /* Regresa las coordenadas */
    return new int [] {fila,columna};
  } 

  boolean esJugadaValida(int k, int l, boolean turno_actual){
    /* Si no está vacío el espacio */ 
    if(tablero[k][l]!=0) return false; 
    int turno = turno_actual?1:-1;
    boolean existe_jugada =  generaDiagonalSuperiorIzq (k,l,turno);
    existe_jugada = generaJugadaIzquierda (k,l,turno) || existe_jugada ;
    existe_jugada = generaJugadaDerecha(k,l,turno) || existe_jugada ;
    existe_jugada = generaDiagonalInferiorDer (k,l,turno) || existe_jugada ;
    existe_jugada = generaDiagonalSuperiorDer (k,l,turno) || existe_jugada ;
    existe_jugada = generaDiagonalInferiorIzq (k,l,turno) || existe_jugada ;
    existe_jugada = generaJugadaArriba (k,l,turno) || existe_jugada ;
    existe_jugada = generaJugadaAbajo (k,l,turno) || existe_jugada ;

  return existe_jugada;
  }
} /* Fin Clase Tablero */

Tablero tablero = new Tablero(8);
// boolean turno = false; 
void setup() {
  /* Configuraciones iniciales */
  background(114, 255, 224);
  size(512, 600);
}

void draw() {
  /* Dibuja el tablero */
  tablero.display();
  /* Si es turno de la máquina */
  if (!tablero.getTurno()) {
    /* Genera la mejor jugada próxima */
    println("Va a calcular la jugada");
    /*
    try {
      Thread.sleep(4000);
    } catch (Exception e){}
    */
    int tirada [] = tablero.calcula_jugadas(tablero.getTurno());
    /* Si no hay jugadas disponibles */
    if (tirada[0] == -1 || tirada[1] == -1) {
      println("Ya no tengo opciones, es tu turno.");
      /* Cambia de turno. */
      tablero.setTurno(!tablero.getTurno());
    }
    /* Si está disponible esa posición. */
    else if (tablero.esJugadaValida(tirada[0],tirada[1],tablero.getTurno())){
      /* ¿? */
      tablero.setBlancasNegras();
      tablero.tablero[tirada[0]][tirada[1]] = (tablero.getTurno()) ? 1 : -1;
      /* Cambia de turno. */
      tablero.setTurno(!tablero.getTurno());
    }
  } 
}

void mouseClicked() {
  int i =  mouseY/(512/tablero.dimension);
  int j = mouseX/(width/tablero.dimension); 
  /* Es turno del usuario */
  if (tablero.getTurno()) {
    /* Verificamos si el jugador tiene jugadas válidas */
    int []jugadas = tablero.calcula_jugadas(tablero.getTurno());
    /* Si no hay jugadas */
    if (jugadas[0] == -1 || jugadas[1] == -1) {
      println("¡No tienes jugadas!");
      tablero.setTurno(!tablero.getTurno());
    }
    /* Si está disponible esa posición. */
    else if (tablero.esJugadaValida(i,j,tablero.getTurno())){
      tablero.setBlancasNegras();
      tablero.tablero[i][j] = (tablero.getTurno()) ? 1 : -1;
      /* Cambia de turno. */
      tablero.setTurno(!tablero.getTurno());
    }
  }  
}