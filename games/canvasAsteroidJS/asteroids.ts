// FIT2102 2019 Assignment 1
// https://docs.google.com/document/d/1Gr-M6LTU-tfm4yabqZWJYg-zTjEVqHKKTCvePGCYsUA/edit?usp=sharing

// Student Name: ZHI HAO TAN
// Student ID: 29650070
// See Observable.ts line 185-230 to see the new functions that have been added to Observable.ts ************************************************************************************
// The Two Functions are takeWhile and takeOnceWhen
// takeWhile will only fire while a condition evalutes true and stops when it evalutes to false and never fire again henceforth(unsubscribed)
// takeOnceWhen will only fire once when and only when a condition evalutes to true
// The code below uses filter and if statements interchangably. This is to prove that both can be done.
// takeWhile is used alot 
// takeUntil and other provided functions are used too to demonstrate understanding
// GAME_STATE is global
// asteroidArray and bulletArray is kind of global. They are passed around in functions.
// The game works like so:
// At every few milliseconds, we check increment the score of the player (Player gets more score the longer they stay alive). This is done using a Observable.interval.takeWhile(playerStillAlive)
// Then whenever player gains 10 score more than what he/she has obtained on the previous level, the player levels up. This is done inside the Observable stated above.
// Whenever player levels up, the asteroids average size gets bigger and speeds up. Not only that, the rate they spawn and the total number of PURPLE asteroids per level increases. Green asteroids are child asteroids
// Child asteroids are asteroids which are created when a large asteroid is shot. Asteroids 'break down' into smaller asteroids.
// The above is done using an observable. We shoot bullets with an observable that listens to keydowns on 'space' when it is held and while held, continuously shoots.
// Then an Observable.interval is used to move the bullets. And everytime the bullet moves, we check whether the bullet hits any asteroids.
// If it does hit the asteroid, remove the asteroid from the asteroidArray and the bullet from bulletArray. 
// Check if the size of the asteroid is sufficient and then if it is, break it down into two asteroids...removing the old big asteroid.
// IF the size is not sufficient, the asteroid is just deleted and nothing else happens.
// The ship/player moves by aiming using the mouse cursor position. The ship rotates to point towards the mouse position. This is done by having an Observable on mousemoves. Whenever the mouse moves, the ships' angle is rotated and updated
// The player presses 'w' to move in this angle/direction the ship is pointing. The player presses' space' to shoot in this direction too. 'w' hold-downs are also checked using keydown observable.
// Asteroids are spawned using Observable.interval.takeUntil. At every interval, spawn an asteroid and do so until a certain amount of asteroids have been produced.
// When asteroids and bullets are spawned, they are always added immediately to the svgs in the "SUBSCRIBE" of each Observable and also in the "SUBSCRIBE", we add them or remove them from the svg or arrays.
// Finally, the game ends when the player has not enough lives (GAME_STATE.lives === 0). This can happen because whenever the player/ship collides with an asteroid;
// In the observable where we make the ship move, we check if ship collides with the asteroid and the same goes for when the asteroid moves.
// When they collide, we decrement the GAME_STATE.lives inside the "SUBSCRIBE" of the Observables.
// Then using the outermost Observable which checks every few millisecs, if the player is NOT alive. End the game and display the "YOU LOSE".

// NOTE: I HAVE NO IDEA WHAT asteroids[Conflict].js is...


const GAME_STATE = { // GAME_STATE is a global object, there are two other arrays which are 'global'
  score: 0,
  level: 1,
  lives: 3
 };

function asteroids() {
  // Inside this function you will use the classes and functions 
  // defined in svgelement.ts and observable.ts
  // to add visuals to the svg element in asteroids.html, animate them, and make them interactive.
  // Study and complete the Observable tasks in the week 4 tutorial worksheet first to get ideas.

  // You will be marked on your functional programming style
  // as well as the functionality that you implement.
  // Document your code!  
  // Explain which ideas you have used ideas from the lectures to 
  // create reusable, generic functions.
  const svg = document.getElementById("canvas")!;  // Initializing all possible uses mouse and keyboard events Observables here.
  const mousemove = Observable.fromEvent<MouseEvent>(svg, 'mousemove'),
  mouseup = Observable.fromEvent<MouseEvent>(svg, 'mouseup'),
  mousedown = Observable.fromEvent<MouseEvent>(svg, 'mousedown'),
  keydown = Observable.fromEvent<KeyboardEvent>(document, 'keydown'),
  keyup = Observable.fromEvent<KeyboardEvent>(document, 'keyup'),
  currentLocation = initCoordinates(300)(300),
  currentAngle = 170,
  bulletArray = [] as Elem[],
  asteroidArray = [] as Elem[];


  // make a group for the spaceship and a transform to move it and rotate it
  // to animate the spaceship you will update the transform property
  let g = new Elem(svg,'g')
    .attr("transform",`translate(300 300) rotate(${currentAngle})`)  
  
  // create a polygon shape for the space ship as a child of the transform group
  let ship = new Elem(svg, 'polygon', g.elem) 
    .attr("points","-15,20 15,20 0,-20")
    .attr("style","fill:pink;stroke:purple;stroke-width:1")
    shipRotate(g, svg, mousemove)
    shipMove(g, 5, keydown, keyup, svg, asteroidArray)
    shipShoot(g, 7, keydown, keyup, svg, bulletArray, asteroidArray)
    spawnAsteroidRandom(g, svg, 1*GAME_STATE.level, GAME_STATE.level, GAME_STATE.level*10, asteroidArray)


  /**
   * Creating SVG texts as display. 
   * */
  const gameStateBoard = new Elem(svg, 'g')
  const liveDisplay = new Elem(svg, 'text', gameStateBoard.elem)
  const scoreDisplay = new Elem(svg, 'text')
  const levelDisplay = new Elem(svg, 'text')
  liveDisplay.attr('fill', 'white')
  liveDisplay.elem.innerHTML = `Lives: ${GAME_STATE.lives}`
  scoreDisplay.elem.innerHTML = `Score: ${GAME_STATE.score}`
  levelDisplay.elem.innerHTML = `Level: ${GAME_STATE.level}`
  levelDisplay.attr('transform', transformStringBuilder(gameStateBoard, svg.getBoundingClientRect().left, svg.getBoundingClientRect().bottom - 380, 0)).attr('fill', 'white')  // transformStringBuilder is a function which just builds the string "translate(x y) rotate(z)"
  scoreDisplay.attr('transform', transformStringBuilder(gameStateBoard, svg.getBoundingClientRect().left, svg.getBoundingClientRect().bottom - 440, 0)).attr('fill', 'white')  // the literals, 260, 320 and 290 here are just for placing the displays on the bottom left of the svg
  gameStateBoard.attr("transform", transformStringBuilder(gameStateBoard, svg.getBoundingClientRect().left, svg.getBoundingClientRect().bottom - 410, 0))


  const unsubscribeGame = Observable.interval(10).takeWhile(e => (GAME_STATE.lives > 0)).subscribe(time => {  // use takeWhile, which is defined in observable.ts line 185.
    // At every 10 milliseconds, while Player is still alive, fire an Observable and in its subscribe, do the following: 

      GAME_STATE.score = GAME_STATE.score + (0.005) // Updates score
      scoreDisplay.elem.innerHTML = `Score: ${GAME_STATE.score}` // Update the score to be displayed on the SVG

        const collidedArray = asteroidArray.filter(asteroid => isPointInsideCircle(retrievePosition(g.attr("transform")).x, retrievePosition(g.attr("transform")).y, asteroid)) // check if the elements inside asteroidArray, a global var are colliding with the ship 
        if (collidedArray.length !== 0){ // if there is collision
        collidedArray.forEach(collidedAsteroid => { // forEach of the collided elements (if there is more than one which is not likely unless 2 elements coincide)
          removeElement(collidedAsteroid, asteroidArray) // use removeElement to remove the asteroid which has collided from the svg and from the array.

          loseALife(g, liveDisplay, svg); // use the function loseALife to decrement lifeCount and if lifeCount reaches 0, player loses and so stop the game (game stopping is done by takeWhile on other observables)
          // also in loseALife, update the svg elements.

        })}
      checkScoreToChangeLevel(g, levelDisplay,svg, asteroidArray) // When score reaches a certain point, update the levevl and change the difficulty.
    
  })
  

}

/**
 * Decrement lifeCount and if  lifeCount reaches 0, player loses and so stop the game (game stopping is done by takeWhile on other observables)
 * Also updates svg elements.
 * @param g The ship, an Elem
 * @param liveDisplay The display for Lives the player has
 * @param svg the SVG
 */
function loseALife(g:Elem, liveDisplay: Elem, svg:HTMLElement){ 
  GAME_STATE.lives -= 1
  liveDisplay.elem.innerHTML = `Lives: ${GAME_STATE.lives}` // Update the svg lives display
  if (GAME_STATE.lives === 0){ // if player's lives == 0, remove the player's ship from svg.
    g.elem.remove()
    const lostDisplay = new Elem(svg, 'text')
    lostDisplay.attr('fill', 'white') // Display on the screen that the player has lost.
    lostDisplay.attr('font-size', '30px')
    lostDisplay.elem.innerHTML = `YOU LOST`
    lostDisplay.attr('transform', transformStringBuilder(lostDisplay, (0 + svg.getBoundingClientRect().width)/2 - 70, (0 + svg.getBoundingClientRect().height)/2, 0)).attr('fill', 'white') // transformStringBuilder is just building the transform string with parameters instead of Literal strings to prevent typos
  }
  
}

/**
 * Check the current score of the game, if current score == level * 10, change level. Asteroids get faster and asteroids also get bigger.
 * @param g the Ship, an Elem
 * @param levelDisplay the display forr Lives the player has
 * @param svg the SVG
 * @param asteroidArray the global var  that stores the asteroids that are on the svg.
 */
function checkScoreToChangeLevel(g:Elem, levelDisplay:Elem, svg:HTMLElement, asteroidArray:Elem[]){ 
  if (GAME_STATE.score >= GAME_STATE.level * 10){ // if score >= 10* level, switch level
    GAME_STATE.level += 1 
    levelDisplay.elem.innerHTML = `Level: ${GAME_STATE.level}` // change display
    spawnAsteroidRandom(g, svg, 1*GAME_STATE.level, GAME_STATE.level, GAME_STATE.level*10, asteroidArray) // call spawnAsteroidRandom to spawn multiple asteroids at random to make game hrder with increased speed
  }
}

/**
 * Using the transform string from elem.attr("transform") to obtain the pointTuple which consists of the x and y coordinates on the transformString
 * @param transformString the transform string from elem.attr("transform")
 */
function retrievePosition(transformString:string):pointTuple<number>{ 
  return initCoordinates(parseFloat(transformString.replace("translate(", "").replace(")", "").split(" ")[0]))(parseFloat(transformString.replace("translate(", "").replace(")", "").split(" ")[1])) //using split and replace to obtain the string you want and parseFloat to convert the string to number
}

/**
 * Using the transform string from elem.attr("transform") to obtain the angle which is on the transformString
 * @param transformString the transform string from elem.attr("transform")
 */
function retrieveAngle(transformString:string):number{
  return parseFloat((transformString.replace("translate(", "").replace(")", "").split(" "))[2].replace("rotate(", "").replace(")", "")) // using split and replacce to obtain the string you want and parseFloat to convert the string to number
}


/**
 * Change degree to radian
 * @param degree the angle in degrees
 */
function transformDegreeToRadian(degree:number):number{
  return degree*(Math.PI/180)
}

/**
 * move elem towards angle by the speed described on the svg. Implements torus topology here.
 * @param elem the Elem to move
 * @param speed the speed to move the thing
 * @param angle the diirection to move the Elem
 * @param svg the svg
 */
function moveTowardsAngle(elem: Elem, speed:number, angle:number, svg:HTMLElement){
  const x = retrievePosition(elem.attr("transform")).x + speed * Math.cos(transformDegreeToRadian(angle))
  const y = retrievePosition(elem.attr("transform")).y + speed * Math.sin(transformDegreeToRadian(angle))

  if (x > svg.getBoundingClientRect().width) { // if x moves into right boundary of svg, come out from left
    elem.attr("transform", transformStringBuilder(elem, 
      (x - svg.getBoundingClientRect().width), 
      y, 
      retrieveAngle(elem.attr("transform"))))
  }

  else if (x < 0) { // if x moves into left boundary of svg, come out from right
    elem.attr("transform", transformStringBuilder(elem, 
      (x + svg.getBoundingClientRect().width), 
      y, 
      retrieveAngle(elem.attr("transform"))))
  }

  else if (y < 0) { // if y moves into top boundary of svg, come out from bottom
    elem.attr("transform", transformStringBuilder(elem, 
      x, 
      (y + svg.getBoundingClientRect().height), 
      retrieveAngle(elem.attr("transform"))))
  }

  else if (y > svg.getBoundingClientRect().height) { // if y moves into bottom bounday of svg, come out from top.
    elem.attr("transform", transformStringBuilder(elem, 
      x, 
      (y - svg.getBoundingClientRect().height), 
      retrieveAngle(elem.attr("transform"))))
  }

  else{ // otherwose move normally.
    elem.attr("transform", transformStringBuilder(elem, 
      x, 
      y, 
      retrieveAngle(elem.attr("transform"))))
  }

}

/**
 * Move the player's ship
 * @param g the player's ship
 * @param speed the speed to move the ship
 * @param keydown the Observable to observe keydowns
 * @param keyup the Observable to obsserve keyups
 * @param svg the svg
 * @param asteroidArray the array which contains the asteroid. 
 */
function shipMove(g:Elem, speed:number, keydown: Observable<KeyboardEvent>, keyup: Observable<KeyboardEvent>, svg: HTMLElement, asteroidArray: Elem[]){
  
  keydown.filter(ev => (ev.key === "w" && ev.repeat === false)).subscribe(({key, shiftKey}) => { // filter keydown
  
    if (GAME_STATE.lives > 0){ // If Player have more lives than 0.
      Observable.interval(10).takeUntil(keyup.filter(ev => ev.key === "w")).subscribe(_ =>{ // continuously (every 10 millisecs) call moveTowardsAngle but when keyUp happens, stop this Observable. 
      moveTowardsAngle(g, speed, retrieveAngle(g.attr("transform")) -90, svg)
  
      
    }
                                    
      )}
  })
  

}

/**
 * Take in parameters and turn them into `translate(${x} ${y}) rotate(${angle})`
 * @param g the ship
 * @param x the x position to move the ship to
 * @param y the y position to move the ship to
 * @param angle the angle to rotate the ship to
 */
function transformStringBuilder  (g:Elem, x:number, y:number, angle:number):string{

  return `translate(${x} ${y}) rotate(${angle})`
  
}

/**
 * Get the radius of a circle
 * @param circle the circle, an Elem
 */
function getCircleRadius(circle:Elem):number{
  return parseFloat(circle.attr("rx"))
}

/**
 * Check if a point is inside a circle.
 * @param x x coordinate
 * @param y y coordinate
 * @param circle the circle used to check if a point is in it
 */
function isPointInsideCircle(x:number, y:number, circle:Elem):boolean{
  const position = retrievePosition(circle.attr("transform"))
 
  return (Math.pow((x - position.x), 2) + Math.pow((y - position.y), 2) < Math.pow(getCircleRadius(circle), 2)) // Math equation obtained online
}

/**
 * Use isPointInsideCircle to check if a bullet (centre of bullet) touches a circle
 * @param bullet the bullet, a rect Elem
 * @param array the global variable that contains asteroids
 */
function bulletCollision(bullet: Elem, array: Elem[]){
  return array.reduce(((acc, currentValue) => {
    return acc || isPointInsideCircle(retrievePosition(bullet.attr("transform")).x, retrievePosition(bullet.attr("transform")).y, currentValue)
  }), false)
}

/**
 * Find the index of an item in an array
 * @param item the item to search for
 * @param array the array
 */
function findIndexForItemFromArray<T>(item:T, array: T[]){
  return array.findIndex((x) => x === item)
}

/**
 * Shooting with the ship while holding spacebar
 * @param g the ship
 * @param speed the speed of the bullets
 * @param keydown the Observable for keydown events
 * @param keyup the Observable for keyup events
 * @param svg the svg
 * @param bulletArray the global variable containing bullets on the svg 
 * @param asteroidArray the global variable containing asteroids on the svg
 */
function shipShoot(g: Elem, speed: number, keydown: Observable<KeyboardEvent>, keyup: Observable<KeyboardEvent>, svg: HTMLElement, bulletArray: Elem[], asteroidArray: Elem[]) {
  keydown.takeWhile(_ => (GAME_STATE.lives > 0)).filter(ev => (ev.repeat === false && GAME_STATE.lives >= 1)).subscribe(({ key, shiftKey }) => { // use takeWhile to coontinue taking values from the keydown Observable until Player has no more lives.
    // use filter to make sure no repeated keydowns are taken into account and call subsccribe
    if (key === " ") { // can also use filter but haave already done so above, so just trying things out
      Observable.interval(200).takeWhile(_ => (GAME_STATE.lives > 0)) .takeUntil(keyup.filter(ev => (ev.key === " " && ev.repeat === false))).subscribe(_ => // create a rect every 200 millisecs, while game is still alive.
        // need to check again because if Player holds down space while he/she dies he can still fire. hence need to check here again

      {
        const rect: Elem = new Elem(svg, 'rect')
        rect
          .attr('width', 20).attr('height', 5)
          .attr('fill', '#DC143C').attr("transform", transformStringBuilder(rect, retrievePosition(g.attr("transform")).x, retrievePosition(g.attr("transform")).y, retrieveAngle(g.attr("transform")) - 90));
          bulletArray.push(rect)
        
        const twentyMillisecObserver = Observable.interval(20) // fire at interval of 20's to move bullet

          const unsub = twentyMillisecObserver.takeWhile(e=>(e <= 10000)).subscribe((subscription) => {  //takeWhile to the rescue, this is to ensure that after missing, it doesnt continue calculating/moving the bullet forever.
            moveTowardsAngle(rect, speed, retrieveAngle(rect.attr("transform")), svg); // move the bullet
        
            
            const collidedArray = asteroidArray.filter(asteroid => isPointInsideCircle(retrievePosition(rect.attr("transform")).x, retrievePosition(rect.attr("transform")).y, asteroid)) // check if the elements insidee asteroidArray, a global var are colliding with the ship 
            if (collidedArray.length !== 0){ // if has collision
            collidedArray.forEach(collidedAsteroid => {
              
              
              removeElement(rect, bulletArray) // forEach of the asteroid that has collided, remove the bullet from the bulletArray and from the svg
              
              unsub();
              if (getCircleRadius(collidedAsteroid)/2 >= 10){

                spawnAsteroid(g, svg, retrievePosition(collidedAsteroid.attr("transform")).x,retrievePosition(collidedAsteroid.attr("transform")).y, getCircleRadius(collidedAsteroid)/2,GAME_STATE.level * 10, asteroidArray, "#008000")
                spawnAsteroid(g, svg, retrievePosition(collidedAsteroid.attr("transform")).x,retrievePosition(collidedAsteroid.attr("transform")).y, getCircleRadius(collidedAsteroid)/2,GAME_STATE.level * 10, asteroidArray, "#008000")
        
            }

            removeElement(collidedAsteroid, asteroidArray) // remove the asteroid from the asteroidArray and the svg


            })
            
          }
          Observable.interval(500).takeOnceWhen(e => (e >= 2500)).subscribe(_=>{ // After 2500 millisecs, remove the bullet if hasn't hit anything
            removeElement(rect, bulletArray)
          })
            
          });

      })


    }
  })
}


/**
 * Use splice to remove an Item from an array
 * @param element the item to remove
 * @param array the array to remove the item from
 */
function removeItemFromArray<T>(element:T, array:T[]){

  array.splice(array.findIndex((currentValue) => (currentValue === element)), 1) // NOT USING filter to return array but using splice because if I use filter and return I need to use let instead of const for my global instance of array.
}


/**
 * Call this to use removeItemFromArray and element.elem.remove() to help remove the item from the svg and from the array
 * @param element the item to remove from svg and the array
 * @param index the index to remove the 
 * @param tagName 
 * @param svg 
 * @param array 
 */
function removeElement(element:Elem, array:Elem[]){
  element.elem.remove()
  removeItemFromArray(element, array)

}

/**
 * Random between two numbers inclusive, if two same numbers are chosen, that number will be returned
 * @param min just a number
 * @param max just another number
 */
function getRandomBetweenTwoNumbers(min:number, max:number): number{
  return (Math.random() * (+max - +min) + +min) // code from geeksforgeeks
}

/**
 * Rotate the ship to point towards/aim at mouse position
 * @param g the ship
 * @param svg the svg
 * @param mousemove the mousemove Observable
 */
function shipRotate(g:Elem, svg:HTMLElement, mousemove: Observable<MouseEvent>){
  mousemove.map(({clientX, clientY}) => ({xOffSet: (clientX - retrievePosition(g.attr("transform")).x) - svg.getBoundingClientRect().left, // get the X and Y position of the mouse and calculate the OffSets
                                          yOffSet: (clientY - retrievePosition(g.attr("transform")).y) - svg.getBoundingClientRect().top}))
                                          .map(obj=>((Math.atan2(obj.xOffSet, -obj.yOffSet))* (180 / Math.PI))) // use atan2 to calculate the angle.
                                          .subscribe(obj => g.attr("transform", transformStringBuilder(g, retrievePosition(g.attr("transform")).x, retrievePosition(g.attr("transform")).y, obj))) // subscribe to change the direction/angle the ship is facing to point towards the mouse position

}

/**
 * Check if an elem is at least a distance/radius away from another circle.
 * @param g the elem
 * @param radius the radius surrounding the elem, to form an arbitrary circle
 * @param circleX the x coordinate of the centre of the circle
 * @param circleY the y coordinate of the centre of the circle
 * @param circleRadius the radius of the circle
 */
function isInAreaSurroundingElem(g:Elem, radius:number, circleX:number, circleY:number, circleRadius:number):boolean{
  return (Math.pow((retrievePosition(g.attr("transform")).x - circleX), 2)
  + (Math.pow(retrievePosition(g.attr("transform")).y - circleY, 2))) <= (Math.pow(radius + circleRadius, 2))
// 1. If C1C2 == R1 + R2
//      Circle A and B are touch to each other.
// 2. If C1C2 > R1 + R2
//      Circle A and B are not touch to each other.
// 3. If C1C2 < R1 + R2
//       Circle intersects each other.
}

/**
 * Create an asteroid. If x and y is -1 -1 or not specified, then an asteroid will be created at a random position. Asteroids are by default purple.
 * @param g the ship
 * @param svg the svg
 * @param minAsteroidSize the min size of the asteroid to create, randoms between this and maxAsteroidSize
 * @param maxAsteroidSize the max size of the asteroid to create, rarndoms between this and minAsteroidSize
 * @param colorHexCode the hex code for the color, a string
 * @param x the x position to create the asteroid
 * @param y the y coordinate to create the asteroidd
 */
function createAsteroid(g:Elem, svg:HTMLElement, minAsteroidSize:number, maxAsteroidSize:number,  colorHexCode = '#800080', x = -1, y = -1):Elem{ //create asteroid circles within the svg

  if(!svg) throw "Couldn't get canvas element!";
  if (maxAsteroidSize >= 100){
    maxAsteroidSize = 100
  }
  const radius = Math.floor(getRandomBetweenTwoNumbers(minAsteroidSize, maxAsteroidSize)); // if maxAsteroidSize >= 100, make it only 100, we don't want the asteroids to get too big in such a small svg.
  const asteroid:Elem = new Elem(svg, 'ellipse') // create an asteroid as an ellipse Elem
      asteroid.attr("rx", radius) 
      asteroid.attr("ry", radius) // making a circle with ellipse
      asteroid.attr("fill", colorHexCode)

    
    if (x <= -1 && y<= -1){ // check if we want to random, if this evaluates to true, then create asteroid at random position
      const pointTuple = initCoordinates(getRandomBetweenTwoNumbers(svg.getBoundingClientRect().left, svg.getBoundingClientRect().right))(getRandomBetweenTwoNumbers(svg.getBoundingClientRect().top, svg.getBoundingClientRect().bottom)); // initCoordinates create a pointTuple which has x and y values
  
      Observable.interval(20).takeWhile(_=>isInAreaSurroundingElem(g, 50, pointTuple.x, pointTuple.y, getCircleRadius(asteroid))).subscribe(_=> { // at every 20 millisecs, fire. Use takeWhile to do this while we are randoming the asteroid to be too near player.
        pointTuple.x = getRandomBetweenTwoNumbers(svg.getBoundingClientRect().left, svg.getBoundingClientRect().right); // this makes sure that asteroids don't spawn TOO near to/on players.
        pointTuple.y = getRandomBetweenTwoNumbers(svg.getBoundingClientRect().top, svg.getBoundingClientRect().bottom);

      })

      asteroid.attr("transform", transformStringBuilder(asteroid,  // set the asteroid position to be what is randomed.
        (pointTuple.x),
        (pointTuple.y),
        0));
      }

  else{
    asteroid.attr("transform", transformStringBuilder(asteroid,  // set the asteroid position to be what is specified otherwise
      (x),
      (y),
      0));
  }
  return asteroid;

}


/**
 * Spawn asteroid at specific location
 * @param g the ship
 * @param svg the svg
 * @param x the x coordinate of the asteroid to spawn
 * @param y the y coordinate of the asteroid to spawn
 * @param size the size of the asteroid to spawn
 * @param speed the speed of the asteroid
 * @param asteroidArray the array to store the new asteroid in
 * @param colorHexCode the color of the asteroid
 */
function spawnAsteroid(g:Elem, svg: HTMLElement, x: number, y:number, size: number, speed:number, asteroidArray: Elem[], colorHexCode: string){
  const newAsteroid = createAsteroid(g, svg, size, size, colorHexCode,x, y) // 10 is lowest asteroid size
  asteroidArray.push(newAsteroid)

  Observable.interval(500).takeWhile(_ => (GAME_STATE.lives > 0)).subscribe(_ => { // at every 500 millisecs(while player still alive), change the direction of the asteroid

    const randomedNumber = getRandomBetweenTwoNumbers(0,360)

    Observable.interval(100).takeUntil(Observable.interval(getRandomBetweenTwoNumbers(300, 700))).subscribe(_ => // move at random for 300-700 millisecs before changing dirrection.

      moveTowardsAngle(newAsteroid, speed, randomedNumber, svg)

      )
  })
}



/**
 * Spawn a number of asteroids at random
 * @param g the ship
 * @param svg the svg
 * @param rateOfSpawningPerSecond the speed of spawning the asteroidss
 * @param level the level the player is currently at
 * @param asteroidSpeed the speed of the asteroid
 * @param asteroidArray the array to store the asteroid in
 */
function spawnAsteroidRandom(g:Elem, svg:HTMLElement, rateOfSpawningPerSecond:number, level:number, asteroidSpeed:number, asteroidArray:Elem[]){


  Observable.interval(1000/rateOfSpawningPerSecond).takeUntil(Observable.interval(10*level*1000/rateOfSpawningPerSecond)).takeWhile(_ => (GAME_STATE.lives > 0)).subscribe(_ => { // spawn a number of asteroids at random location
    // at every 1000/rateOfSpawningPerSecond, create an asteroid. Do this until 10 * level number of asteroids has been created but only do this WHILE player is still alive(don't spawn more asteroids after game ends)
    const newAsteroid = createAsteroid(g, svg, 10 * level, 20 * level) // 10 is lowest asteroid size

    asteroidArray.push(newAsteroid)

    Observable.interval(500).takeWhile(_ => (GAME_STATE.lives > 0)).subscribe(_ => { // at every 500 millisecs(while player still alive), change the direction of the asteroid

      const randomedNumber = getRandomBetweenTwoNumbers(0,360)

      Observable.interval(100).takeUntil(Observable.interval(getRandomBetweenTwoNumbers(300, 700))).subscribe(_ => // move at random for 300-700 millisecs before changing dirrection.

        moveTowardsAngle(newAsteroid, asteroidSpeed, randomedNumber, svg)

        )

    })

  })
}





interface pointTuple <T> { // generic type, in our case we are using <number> usually
  x: T;
  y: T;
}

/**
 * A curried function to demonstrate understandding. Can be NOT curried. Used to create a pointTuple which contains x and y coordinates usually
 * @param newX the X, and then returns a function which takes newY as argument and returns a pointTuple object
 */
function initCoordinates(newX:number):(newY:number) => pointTuple<number> {

  return function (newY): pointTuple<number>{
      return {
          x: newX,
          y: newY
      }
  }
}   



// the following simply runs your asteroids function on window load.  Make sure to leave it in place.
if (typeof window != 'undefined')
  window.onload = ()=>{
    asteroids();
  }

 

 
