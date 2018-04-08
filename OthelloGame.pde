  import java.util.Scanner;
  import java.lang.Math;
  /* Clase que emula un tablero para el juego de Othello */
  class Tablero {
    int[][] tablero;
    int dimension; 
    boolean turno;
    boolean turno_maquina; 
    int negras;
    int blancas;
    
    /* Constructor */
    Tablero(int N) {
      this.tablero = new int[N][N];
      this.dimension = N;
      /* Las negras son false */ 
      this.turno = false; 
      this.turno_maquina = false;
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
    
    void cuenta_fichas(){
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

    /* Regresa la función fitnness de un tablero (El número de fichas negras o de mi turno que hay) */
    int fitnness (){
      /* Debería ser implementado según sea el turno */
      int fichas=0;
      for (int i = 0;i<dimension ;i++ ) {
        for (int j = 0;j<dimension ;j++ ) {
          /* Si ve una ficha negra */
          if (tablero[i][j] == -1) fichas++;
        }
      }
      // println("Hay " + fichas + " fichas");
      return fichas;
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

    /* Hace una copia identica de otra matriz (tablero) */
    int [][] copia_matriz (int [][] matriz){
      int [][] copia = new int[matriz.length][matriz.length];
      for (int i = 0;i<copia.length ;i++ ) {
        for (int j = 0;j<copia.length ;j++ ) {
          copia[i][j] = matriz[i][j];
        }        
      }
      return copia;
    }

    /* Regresa true si el turno es de la máquina, false en otro caso */
    boolean esTurnoMaquina (){
      return turno == turno_maquina;
    }

    /* Algoritmo principal, minimax */
    int [] min_max (boolean turno,int profundidad){
      /* Generamos una copia del tablero para poder manipularlo */
      //int [][] tablero_aux = copia_matriz(tablero);
      /* Es turno de la máquina */
      if (turno == turno_maquina) {
        // println("entra a Max" + profundidad);
        return busca_max(turno,profundidad);
      } 
      /* Es turno del oponente */
      else {
        // println("entra a Min" + profundidad);
        return busca_min(turno,profundidad);
      }
      // return null;
    }

    /* Funciones auxiliares */
    /* Busca la mejor jugada para nosotros (la máquina)*/
    int[] busca_max (boolean turno,int profundidad){
      // println("entra profundidad: " + profundidad);
      /* Inicialización de max */
      int max = (int)Double.NEGATIVE_INFINITY;
      int fit;
      int fila = -1;
      int columna = -1;
      /* Generamos una copia del tablero para poder manipularlo */
      int [][] tablero_aux = copia_matriz(tablero);
      /* Iteramos las posibles jugadas */
      for (int i = 0;i<dimension ;i++ ) {
        for (int j = 0;j<dimension ;j++ ) {
          /* Si es espacio en blanco */
          if (tablero[i][j]==0) {
            // Encontró un tiro válido.
            if (esJugadaValida(i,j,turno)) {
              // Caso base de la recursión...
              if (profundidad == 0) {
                fit = fitnness();
                // println("Tirada en: " + i + "," + j +  " fitness: " + fit);
                if (max < fit){
                  max = fit;
                  fila = i;
                  columna = j;
                }
              } else {
                fit = min_max (!turno,profundidad-1)[2];
                // println("Tirada en: " + i + "," + j +  " fitness: " + fit);
                if (fit > max) {
                  max = fit;
                  fila = i;
                  columna = j;
                }
              }
              // Regresa al tablero original
              tablero = copia_matriz(tablero_aux); 
            }
          }
        }
      }
      // println("sale profundidad: " + profundidad);
      // Si no regresa una jugada válida y la profundidad es cero... 
      if (fila == -1 && profundidad != 0) {
        println("entra a el caso chido");
        // Regresa este mismo método pero con profundidad 0.
        return busca_max(turno,0);
      }
      // println("---------------------------");
      /* Regresamos la mejor jugada encontrada */
      return new int [] {fila,columna,max};
    }

    int [] busca_min (boolean turno,int profundidad){
      // println("entra profundidad: " + profundidad);
      /* Inicialización de max */
      int min = (int)Double.POSITIVE_INFINITY;
      int fit;
      int fila = -1;
      int columna = -1;
      /* Generamos una copia del tablero para poder manipularlo */
      int [][] tablero_aux = copia_matriz(tablero);
      /* Iteramos las posibles jugadas */
      for (int i = 0;i<dimension ;i++ ) {
        for (int j = 0;j<dimension ;j++ ) {
          /* Si es espacio en blanco */
          if (tablero[i][j]==0) {
            // Encontró un tiro válido.
            if (esJugadaValida(i,j,turno)) {
              // Caso base de la recursión...
              if (profundidad == 0) {
                fit = fitnness();
                // println("Tirada en: " + i + "," + j +  " fitness: " + fit);
                if (min > fit){
                  min = fit;
                  fila = i;
                  columna = j;
                }
              } else {
                fit = min_max (!turno,profundidad-1)[2];
                // println("Tirada en: " + i + "," + j +  " fitness: " + fit);
                if (min > fit) {
                  min = fit;
                  fila = i;
                  columna = j;
                }
              }
              // Regresa al tablero original
              tablero = copia_matriz(tablero_aux); 
            }
          }
        }
      }
      // println("sale profundidad: " + profundidad);
      if (fila == -1 && profundidad != 0) {
        println("entra a el caso chido");
        // Regresa este mismo método pero con profundidad 0.
        return busca_min(turno,0);
      }
      /* Regresamos la mejor jugada encontrada */
      return new int [] {fila,columna,min};
    }


    int[] calcula_mejor_jugada (boolean turno){
      int columna = -1;
      int fila = -1;
      int fichas_negras;
      int [][] tablero_aux = copia_matriz(tablero);
      int max = -1000;
      int fichas_ganadas;
      int temp, balance;
      int numero;
      for (int i = 0;i<dimension ;i++ ) {
        for (int j = 0;j<dimension ;j++ ) {
          /* Si es espacio en blanco */
          if (tablero[i][j]==0) {
            // Encontró un tiro válido.
            cuenta_fichas();
            fichas_negras = negras;
            if (esJugadaValida(i,j,turno)) {
              fitnness();
              cuenta_fichas();
              fichas_ganadas = negras - fichas_negras;
              println("Hay jugada válida en: " + i + "," + j + ". Ganaré: " + fichas_ganadas);
              temp = calcula_mejor_rama (!turno,2);
              println("Con esta jugada perderé: " +temp + " fichas en promedio.");
              // balance = fichas_ganadas - temp;
              balance = fichas_ganadas - temp;
              println("Balance: " + balance);
              // Si es una tirada en un extremo, lo toma.
              if (i == 0 || j == 0 || i == dimension-1 || j == dimension-1) {
                println("Tomó el extremo alv");
                // Regresa esa opción sin importar nada.
                // return new int [] {i,j};
              } 
              // Si encontró una jugada igual de buena hasta el momento.
              if(balance == max){
                // Genera un número aleatorio entre 0 y 1
                numero = (int) (Math.random() * 2) ;
                // Si el número es cero, sustituye la mejor solución, por esta.
                if (numero<1) {
                  println("****************Encontró el mejor balance: " + balance);
                  max = balance;
                  fila = i;
                  columna = j;
                }
              } else if (balance > max) {
                println("****************Encontró el mejor balance: " + balance);
                max = balance;
                fila = i;
                columna = j;
              }
              // Regresa al tablero original
              tablero = copia_matriz(tablero_aux); 
            }
          }
        }
      }
      /* Regresa las coordenadas y el número de fichas que convierte de la mejor jugada */
      return new int [] {fila,columna};
    }

    int calcula_mejor_rama(boolean turno,int nivel_profundidad){
      /* Caso base de la recursión */
      if (nivel_profundidad == -1) {
        return 0;
      }
      // println("Nivel de profundidad: "+nivel_profundidad);
      // Auxiliares
      // int blancas,negras;
      int fichas_totales = 0;
      // Para ver si cambia en algo..
      int jugadas_totales = 0;
      /* Guardamos el tablero original */
      int [][] tablero_aux = copia_matriz(tablero);
      int fichas_blancas,fichas_negras,fichas_ganadas;
      for (int i = 0;i<dimension ;i++ ) {
        for (int j = 0;j<dimension ;j++ ) {
          /* Si es espacio en blanco */
          if (tablero[i][j]==0) {
            cuenta_fichas();
            fichas_negras = negras;
            fichas_blancas = blancas;
            // Encontró un tiro válido.
            if (esJugadaValida(i,j,turno)) {
              jugadas_totales ++;
              // Contamos las fichas de nuevo para comparar.
              cuenta_fichas();
              // Si es turno de la máquina.  
              if (turno_maquina == turno) {
                fichas_ganadas = negras - fichas_negras - calcula_mejor_rama(!turno,nivel_profundidad-1);
              } else {
                fichas_ganadas = blancas - fichas_blancas - calcula_mejor_rama(!turno,nivel_profundidad-1);
              }
              fichas_totales += fichas_ganadas;
              // Regresa al tablero original
              tablero = copia_matriz(tablero_aux);
            }
          }
        }
      }
      if (jugadas_totales >0) {
        return fichas_totales /jugadas_totales;
      }
      /* Regresa las coordenadas y el número de fichas que convierte de la mejor jugada */
      return fichas_totales;
    }

    /*  
      Calcula todas las jugadas disponibles para la máquina. 
      Regresa una arreglo de dos posiciones; la primera indica las filas, la segunda las columnas. 
    */
    int[] calcula_jugadas (boolean turno,int nivel_profundidad){
      /* Caso base de la recursión */
      if (nivel_profundidad == -1) {
        return new int[] {-1,-1,0};
      }
      /* Temporales */
      int fila,columna,max,min_global;
      fila = -1;
      columna = -1;
      /* 64 es el máximo nunmero de fichas de un color que puede haber */
      max = -64;
      min_global = 64;
      cuenta_fichas();
      /* Guardamos el tablero original */
      int [][] tablero_aux = copia_matriz(tablero);
      int fichas_blancas,fichas_negras,fichas_ganadas;
      for (int i = 0;i<dimension ;i++ ) {
        for (int j = 0;j<dimension ;j++ ) {
          // fichas = 0;
          /* Si es espacio en blanco */
          if (tablero[i][j]==0) {
            // Realiza la tirada, y cuenta las fichas que ganará.
            if (esJugadaValida(i,j,turno)) { 
              /* Encontró un tiro válido */
              fichas_negras = negras;
              fichas_blancas = blancas;
              // Contamos las fichas de nuevo...
              cuenta_fichas();
              // Si es turno de la máquina.
              if (turno_maquina == turno) {
                // println("Fichas antes " + fichas_negras);
                // Las fichas que tengo ahora menos la que tenía antes de la jugada
                // println("Fichas después " +negras);
                fichas_ganadas = negras-fichas_negras;
                //***********************************
                // Si aún puedo hacer llamadas recursivas, calcula el sig nivel del árbol de búsqueda.
                println("Nivel de profundidad: " + nivel_profundidad);
                println("Ganaré: " + fichas_ganadas +" fichas.");
                int [] temp = calcula_jugadas(!turno,nivel_profundidad-1);
                println("Si el usuario tira la mejor jugada en "+ temp[0] + "," + temp[1] + "; él ganará: " + temp[2] + " fichas");
                // Le restamos las fichas que ganamos, con las fichas que el usuario ganará.
                println ("Balance: " + fichas_ganadas);
                fichas_ganadas -= temp[2]; 
                // ********************************
                println("Max: " + max + " fichas gandas: " + fichas_ganadas);
                // Si esta solución es mejor a la que hemos encontrado hasta ahora..
                if (max < fichas_ganadas) {
                  println("*****Se encontró una solución mejor en: " + i + "," + j);
                  fila = i;
                  columna = j;
                  max = fichas_ganadas;
                } 
                println("--------------------------------");
              }
              // Es truno del usuario.
              else {
                // Si encontró una jugada mejor...
                fichas_ganadas = blancas-fichas_blancas;
                // La mejor jugada del oponente.
                if (max < fichas_ganadas) {
                  max = fichas_ganadas;
                  // Si aún puedo hacer llamdas recursivas, calcula el sig nivel del árbol de búsqueda.
                  int [] temp = calcula_jugadas(!turno,nivel_profundidad-1);
                  // println ("Nivel del else " + nivel_profundidad);
                  // Le restamos las fichas que el usuario gana´ra, con las fichas que nosotros ganaremos.
                  fichas_ganadas -= temp[2];
                  if (min_global > fichas_ganadas) {
                    fila = i;
                    columna = j;
                    min_global = fichas_ganadas;
                  } 
                }
              }
              // Colocamos la ficha en esa posición
              tablero[i][j] = turno?1:-1;
              // Regresa al tablero original
              tablero = copia_matriz(tablero_aux);
              cuenta_fichas();
            }
          }
        }
      }
      /* Regresa las coordenadas y el número de fichas que convierte de la mejor jugada */
      return new int [] {fila,columna,max};
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

      if (existe_jugada) {
        tablero[k][l] = turno_actual ? 1 : -1;
      }

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
    if (tablero.esTurnoMaquina()) {
      /* Genera la mejor jugada próxima */
      // int tirada [] = tablero.calcula_jugadas(tablero.getTurno(),0);
      // int tirada [] = tablero.calcula_mejor_jugada(tablero.getTurno());
      int tirada [] = tablero.min_max(tablero.getTurno(),5);
      println("Tirada en: " + tirada[0] + "," + tirada[1]);
      /* Si no hay jugadas disponbles a 5 niveles, intenta con 0 niveles */
      if (tirada[0] == -1 || tirada[1] == -1) {
        println("Ya no tengo opciones, intento con un nivel.");
        tirada  = tablero.min_max(tablero.getTurno(),0);
        println("Tirada en: " + tirada[0] + "," + tirada[1]);
      }
      /* Si no hay jugadas disponibles realmente*/
      if (tirada[0] == -1 || tirada[1] == -1) {
        println("Ya no tengo opciones, tu turno.");
        /* Cambia de turno. */
        tablero.setTurno(!tablero.getTurno());
      }
      /* Si está disponible esa posición. */
      else if (tablero.esJugadaValida(tirada[0],tirada[1],tablero.getTurno())){
        tablero.cuenta_fichas();
        // tablero.tablero[tirada[0]][tirada[1]] = (tablero.getTurno()) ? 1 : -1;
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
      int []jugadas = tablero.calcula_jugadas(tablero.getTurno(),0);
      /* Si no hay jugadas */
      if (jugadas[0] == -1 || jugadas[1] == -1) {
        println("¡No tienes jugadas!");
        tablero.setTurno(!tablero.getTurno());
      }
      /* Si está disponible esa posición. */
      if (tablero.esJugadaValida(i,j,tablero.getTurno())){
        tablero.cuenta_fichas();
        // tablero.tablero[i][j] = (tablero.getTurno()) ? 1 : -1;
        /* Cambia de turno. */
        tablero.setTurno(!tablero.getTurno());
      }
    }  
  }