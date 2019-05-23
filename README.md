# Simulación campestre

Para hacernos amigos de Wollok-game y seguir practicando la definición de clases, vamos a definir una simulación gráfica de un campo en el que hay animales, y dispositivos que los atienden.

Vamos a ir bien de a poco.


## 1. Arrancamos el juego
El código inicial incluye dos archivos en la carpeta `src`.
   
Uno es `animales.wlk`, en este archivo Wollok vamos a definir las clases que modelan distintas especies animales.
El código inicial incluye una clase `Vaca` con dos atributos:
```
var property position = game.at(3,5)
const property image = "vaca.gif"
```
Cualquier objeto al que se le puedan enviar los mensajes `position()`, `position(nuevaPosicion)` e `image`, es un posible **objeto visual** para un Wollok-game. Los dos `property` le agregan exactamente esos métodos a la clase `Vaca`. Perfecto.

Veamos ahora _cómo se inicializaron_ estos atributos.
- La `position` se inicializó usando `game.at(x,y)`. El objeto `game` viene con Wollok, pero para usarlo hay que hacer el `import wollok.game.*` que está arriba de todo en el archivo.
- La `image` se inicializó con un nombre de un archivo que está en la carpeta `asset`. Si queremos agregar más imágenes, las ponemos en esa carpeta. Tamaño: 44x44 píxeles está bien. 

El otro archivo es `simulacionanimales.wpgm`.  
Este no es un archivo Wollok común, es un **programa**. Esto se reconoce por la _extensión_ del archivo: los programas Wollok son `wpgm`, los archivos Wollok son `wlk`.  
Tiene lo mínimo para levantar un Wollok-game: el `import wollok.game.*`, la configuración del tamaño de la pantalla, y al final `game.start()`. Además, se define una variable `animalActual`, que se inicializa con una instancia de `Vaca`. 

Si ejecutamos este archivo, va a aparecer una pantalla separada, ese es el game. Pero ... está vacía, no aparece la vaca por ningún lado.  
Para que aparezca hay que agregarla al `game` como objeto visual: 
```
game.addVisual(animalActual)
```
Agregá esta línea debajo de la definición de `animalActual`, y volvé a ejecutar el programa. Ahora sí debería aparecer el dibujo de la vaca. No se mueve ni hace nada, pero por algo se empieza.

## 2. Algo del modelo de vacas: peso y sed

Empecemos por un modelo de lo más sencillo de una vaca: nos interesa saber solamente el peso, y si tiene sed o no.  
Cuando _come_ se informa cuántos kilos comió, aumenta su peso en la mitad de esa cantidad, y le da sed.  
Cuando _bebe_ se le quita la sed y adelgaza un kilo; en este caso no se informa cuánto bebe.


## 3. Acciones sobre el animal actual

Ahora vamos a darle indicaciones a la vaca que está en el juego. Wollok-game nos permite hacer esto asociando una tecla a cada acción.   
P.ej. de esta forma se le indica que cuando se pulsa la tecla "c", se le dan de comer 12 kilos al animal actual
```
keyboard.c().onPressDo({ animalActual.comer(12) })
```
O sea: al objeto que representa a la tecla "c" le pido que cuando se pulse esa tecla, se ejecute una acción.  
**Atención**: la acción que se pasa como parámetro se tiene que ejecutar recién cuando se pulse la tecla, no mientras se está configurando el juego. Para lograr esto, se pasa un bloque, por eso las llaves.  

Agregar esta línea (debajo del título "configuraciones de teclado") y volver a ejecutar el programa. Pulsar la letra "c". ¿Cómo darse cuenta que se le dio de comer a la vaca? Pasar el cursor por arriba, se va a ver que abajo se indica el valor de los atributos, entre ellos debería estar el peso. Después de darle de comer, el valor de peso debería ser más alto.

Otra cosa interesante: también puedo pedir que se _muestre_ el peso cuando se pulsa una tecla, p.ej. 
```
keyboard.p().onPressDo({ game.say(animalActual, animalActual.peso().toString()) })
```
Acá vemos otra cosa que le podemos decir al `game`, que es `say` con dos argumentos.
Con `say` le estamos indicando al juego que uno de sus elementos tiene que decir algo. 
El primer argumento es el elemento, el segundo es lo que va a decir.

Agregar esta línea al programa y volver a ejecutarlo. Probar pulsando "c" y "p".

Después, agregar la configuración de dos teclas más: 
- una para que el animalActual beba; 
- la otra para indicar "Tengo sed" o "No tengo sed", según si el animal tiene o no tiene sed. Esta va a usar `game.say`, pero tiene que haber un `if` para saber qué mostrar.


## 4. Vaca o gallina

En el archivo `animales.wlk`, agregar una clase `Gallina`, de forma tal que las gallinas sean polimórficas con las vacas para el juego.

Cómo "funciona" una gallina:
- cuando come, acumula _cuántas veces fue a comer_. No le importan los kilos, da lo mismo que coma 1 kilo o 20, lo que se cuenta es cuántas veces comió.
- el peso es fijo, 4 kilos.
- tiene sed si comió exactamente 2 veces, o si comió exactamente 5 veces. Con cualquier otro valor, no tiene sed.

Tenemos que agregar también posición e imagen. Posición elíjanla ustedes. Para imagen hay un `gallina.gif` que pueden usar.

Después de agregar la nueva clase, vuelvan al juego y **cambien** el animal actual, que en lugar de ser una vaca sea una gallina.   
Prueben con las cuatro teclas
- la que le da de comer 12 kilos
- la que muestra el peso
- la que le da de beber
- la que muestra si tiene sed o no

Tal vez alguna se rompa, se dan cuenta porque alguno de los personajes "dice" algo en color rojo. Si les pasa esto, recuerden que tienen que poner en `Gallina` **todos** los métodos necesarios para que el juego pueda usar instancias de esa clase. Si hay que agregar una acción que no haga nada, pues se agrega el método vacío.


Llegó la hora de hacer que nuestro animal se mueva y para eso vamos a tener que jugar con las posiciones, que son objetos que vienen en Wollok y ya los estamos usando para que nuestros animales se muestren.

Básicamente una posición es un par (x,y), donde la x representa a la posición horizontal y la y a la posición vertical (como en matemática, claro). El origen - abajo y a la izquierda - es (0,0) y desde ahí vamos sumando según nos desplacemos hacia arriba o hacia la derecha.

Para facilitar las operaciones, las posiciones de Wollok entienden los mensajes up(n), down(n), left(n) y right(n) que nos devuelven una nueva posición con la coordenada correspondiente cambiada. Veamos un ejemplo:

>>> var posicion = game.at(1, 0)
>>> posicion.up(2)
(1,2)
>>> posicion.right(1)
(2,0)
>>> posicion
(1,0)
Ojo 👀 la posición original no cambia nunca, solo se devuelve una nueva. Si en el ejemplo anterior miramos el valor de posicion, siempre sigue siendo (1,0).

Sabiendo esto, y que en Wollok Game las flechas se llaman up(), down(), left() y right() (no confundir con las posiciones), programar lo necesario para que el animal se desplace cuando tocamos la flecha correspondiente. Por las dudas, va tablita con la traducción:

Inglés	Español
Left	Izquierda
Right	Derecha
Up	Arriba
Down	Abajo
6. Un poco más de lógica: tiene hambre
Ahora nos toca determinar si una vaca o gallina tienen hambre, y usaremos la tecla H para que nos lo muestre.

Para las vacas vamos a determinar lo siguiente:

Las vacas tienen hambre si su peso esta por debajo de los 200 kilogramos.
A partir de ahora solo podrán comer si tienen hambre. Si se les intenta dar de comer cuando no tienen hambre deben arrojar un error con un mensaje acorde.
Con cada movimiento que realiza la vaca pierde el 5% de su peso, pero nunca puede ser menor a 50 kilogramos.
Y para las gallinas el comportamiento será el siguiente:

Una gallina tendrá hambre si la cantidad de veces que fue a comer es par.
Las gallinas siempre pueden comer, independientemente si tienen o no hambre.
Las gallinas no pierden peso con los movimiento que realizan.
Bonus: hacer que la vaca tire un error cuando intento que camine y su energía es igual a 50.

7. Comedero
Vamos a agregar al modelo los comederos, que son... lugares donde los animales pueden ir a comer 😯.

De cada comedero nos va a interesar:

saber si puede atender a un animal;
que efectivamente le de comida a un animal.
Por ahora vamos a tener solamente al comedero normal, que se comporta de la siguiente manera:

puede atender a un animal si este tiene hambre y no supera el peso máximo establecido para ese comedero. Este peso se debe poder configurar para cada comedero;
cuando le da de comer a un animal, lo hace con una ración de 6 kilos. Cada comedero arranca con una determinada cantidad de raciones, y cada vez que le da de comer a un animal pierde una.
Bonus: hacer que el comedero falle (o sea, tire un error) si intenta atender a un animal pero ya no le quedan más raciones.

Se pide modelar el comedero y agregar algunos, distribuidos por todo el tablero. Luego, cuando el animal pase caminando sobre un comedero debería pasar lo siguiente:

si puede atenderlo, lo hace. Como muestra de gratitud el animal lo agradece con un mensaje a elección, que debe salir del animal;
si no puede atenderlo, no lo hace. En este caso debería aparecer un mensaje que sale del comedero y que comunica esta situación.






















