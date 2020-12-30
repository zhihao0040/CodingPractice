"use strict";
const GAME_STATE = {
    score: 0,
    level: 1,
    lives: 3
};
function asteroids() {
    const svg = document.getElementById("canvas");
    const mousemove = Observable.fromEvent(svg, 'mousemove'), mouseup = Observable.fromEvent(svg, 'mouseup'), mousedown = Observable.fromEvent(svg, 'mousedown'), keydown = Observable.fromEvent(document, 'keydown'), keyup = Observable.fromEvent(document, 'keyup'), currentLocation = initCoordinates(300)(300), currentAngle = 170, bulletArray = [], asteroidArray = [];
    let g = new Elem(svg, 'g')
        .attr("transform", `translate(300 300) rotate(${currentAngle})`);
    let ship = new Elem(svg, 'polygon', g.elem)
        .attr("points", "-15,20 15,20 0,-20")
        .attr("style", "fill:pink;stroke:purple;stroke-width:1");
    shipRotate(g, svg, mousemove);
    shipMove(g, 5, keydown, keyup, svg, asteroidArray);
    shipShoot(g, 7, keydown, keyup, svg, bulletArray, asteroidArray);
    spawnAsteroidRandom(g, svg, 1 * GAME_STATE.level, GAME_STATE.level, GAME_STATE.level * 10, asteroidArray);
    const gameStateBoard = new Elem(svg, 'g');
    const liveDisplay = new Elem(svg, 'text', gameStateBoard.elem);
    const scoreDisplay = new Elem(svg, 'text');
    const levelDisplay = new Elem(svg, 'text');
    liveDisplay.attr('fill', 'white');
    liveDisplay.elem.innerHTML = `Lives: ${GAME_STATE.lives}`;
    scoreDisplay.elem.innerHTML = `Score: ${GAME_STATE.score}`;
    levelDisplay.elem.innerHTML = `Level: ${GAME_STATE.level}`;
    levelDisplay.attr('transform', transformStringBuilder(gameStateBoard, svg.getBoundingClientRect().left, svg.getBoundingClientRect().bottom - 380, 0)).attr('fill', 'white');
    scoreDisplay.attr('transform', transformStringBuilder(gameStateBoard, svg.getBoundingClientRect().left, svg.getBoundingClientRect().bottom - 440, 0)).attr('fill', 'white');
    gameStateBoard.attr("transform", transformStringBuilder(gameStateBoard, svg.getBoundingClientRect().left, svg.getBoundingClientRect().bottom - 410, 0));
    const unsubscribeGame = Observable.interval(10).takeWhile(e => (GAME_STATE.lives > 0)).subscribe(time => {
        GAME_STATE.score = GAME_STATE.score + (0.005);
        scoreDisplay.elem.innerHTML = `Score: ${GAME_STATE.score}`;
        const collidedArray = asteroidArray.filter(asteroid => isPointInsideCircle(retrievePosition(g.attr("transform")).x, retrievePosition(g.attr("transform")).y, asteroid));
        if (collidedArray.length !== 0) {
            collidedArray.forEach(collidedAsteroid => {
                removeElement(collidedAsteroid, asteroidArray);
                loseALife(g, liveDisplay, svg);
            });
        }
        checkScoreToChangeLevel(g, levelDisplay, svg, asteroidArray);
    });
}
function loseALife(g, liveDisplay, svg) {
    GAME_STATE.lives -= 1;
    liveDisplay.elem.innerHTML = `Lives: ${GAME_STATE.lives}`;
    if (GAME_STATE.lives === 0) {
        g.elem.remove();
        const lostDisplay = new Elem(svg, 'text');
        lostDisplay.attr('fill', 'white');
        lostDisplay.attr('font-size', '30px');
        lostDisplay.elem.innerHTML = `YOU LOST`;
        lostDisplay.attr('transform', transformStringBuilder(lostDisplay, (0 + svg.getBoundingClientRect().width) / 2 - 70, (0 + svg.getBoundingClientRect().height) / 2, 0)).attr('fill', 'white');
    }
}
function checkScoreToChangeLevel(g, levelDisplay, svg, asteroidArray) {
    if (GAME_STATE.score >= GAME_STATE.level * 10) {
        GAME_STATE.level += 1;
        levelDisplay.elem.innerHTML = `Level: ${GAME_STATE.level}`;
        spawnAsteroidRandom(g, svg, 1 * GAME_STATE.level, GAME_STATE.level, GAME_STATE.level * 10, asteroidArray);
    }
}
function retrievePosition(transformString) {
    return initCoordinates(parseFloat(transformString.replace("translate(", "").replace(")", "").split(" ")[0]))(parseFloat(transformString.replace("translate(", "").replace(")", "").split(" ")[1]));
}
function retrieveAngle(transformString) {
    return parseFloat((transformString.replace("translate(", "").replace(")", "").split(" "))[2].replace("rotate(", "").replace(")", ""));
}
function transformDegreeToRadian(degree) {
    return degree * (Math.PI / 180);
}
function moveTowardsAngle(elem, speed, angle, svg) {
    const x = retrievePosition(elem.attr("transform")).x + speed * Math.cos(transformDegreeToRadian(angle));
    const y = retrievePosition(elem.attr("transform")).y + speed * Math.sin(transformDegreeToRadian(angle));
    if (x > svg.getBoundingClientRect().width) {
        elem.attr("transform", transformStringBuilder(elem, (x - svg.getBoundingClientRect().width), y, retrieveAngle(elem.attr("transform"))));
    }
    else if (x < 0) {
        elem.attr("transform", transformStringBuilder(elem, (x + svg.getBoundingClientRect().width), y, retrieveAngle(elem.attr("transform"))));
    }
    else if (y < 0) {
        elem.attr("transform", transformStringBuilder(elem, x, (y + svg.getBoundingClientRect().height), retrieveAngle(elem.attr("transform"))));
    }
    else if (y > svg.getBoundingClientRect().height) {
        elem.attr("transform", transformStringBuilder(elem, x, (y - svg.getBoundingClientRect().height), retrieveAngle(elem.attr("transform"))));
    }
    else {
        elem.attr("transform", transformStringBuilder(elem, x, y, retrieveAngle(elem.attr("transform"))));
    }
}
function shipMove(g, speed, keydown, keyup, svg, asteroidArray) {
    keydown.filter(ev => (ev.key === "w" && ev.repeat === false)).subscribe(({ key, shiftKey }) => {
        if (GAME_STATE.lives > 0) {
            Observable.interval(10).takeUntil(keyup.filter(ev => ev.key === "w")).subscribe(_ => {
                moveTowardsAngle(g, speed, retrieveAngle(g.attr("transform")) - 90, svg);
            });
        }
    });
}
function transformStringBuilder(g, x, y, angle) {
    return `translate(${x} ${y}) rotate(${angle})`;
}
function getCircleRadius(circle) {
    return parseFloat(circle.attr("rx"));
}
function isPointInsideCircle(x, y, circle) {
    const position = retrievePosition(circle.attr("transform"));
    return (Math.pow((x - position.x), 2) + Math.pow((y - position.y), 2) < Math.pow(getCircleRadius(circle), 2));
}
function bulletCollision(bullet, array) {
    return array.reduce(((acc, currentValue) => {
        return acc || isPointInsideCircle(retrievePosition(bullet.attr("transform")).x, retrievePosition(bullet.attr("transform")).y, currentValue);
    }), false);
}
function findIndexForItemFromArray(item, array) {
    return array.findIndex((x) => x === item);
}
function shipShoot(g, speed, keydown, keyup, svg, bulletArray, asteroidArray) {
    keydown.takeWhile(_ => (GAME_STATE.lives > 0)).filter(ev => (ev.repeat === false && GAME_STATE.lives >= 1)).subscribe(({ key, shiftKey }) => {
        if (key === " ") {
            Observable.interval(200).takeWhile(_ => (GAME_STATE.lives > 0)).takeUntil(keyup.filter(ev => (ev.key === " " && ev.repeat === false))).subscribe(_ => {
                const rect = new Elem(svg, 'rect');
                rect
                    .attr('width', 20).attr('height', 5)
                    .attr('fill', '#DC143C').attr("transform", transformStringBuilder(rect, retrievePosition(g.attr("transform")).x, retrievePosition(g.attr("transform")).y, retrieveAngle(g.attr("transform")) - 90));
                bulletArray.push(rect);
                const twentyMillisecObserver = Observable.interval(20);
                const unsub = twentyMillisecObserver.takeWhile(e => (e <= 10000)).subscribe((subscription) => {
                    moveTowardsAngle(rect, speed, retrieveAngle(rect.attr("transform")), svg);
                    const collidedArray = asteroidArray.filter(asteroid => isPointInsideCircle(retrievePosition(rect.attr("transform")).x, retrievePosition(rect.attr("transform")).y, asteroid));
                    if (collidedArray.length !== 0) {
                        collidedArray.forEach(collidedAsteroid => {
                            removeElement(rect, bulletArray);
                            unsub();
                            if (getCircleRadius(collidedAsteroid) / 2 >= 10) {
                                spawnAsteroid(g, svg, retrievePosition(collidedAsteroid.attr("transform")).x, retrievePosition(collidedAsteroid.attr("transform")).y, getCircleRadius(collidedAsteroid) / 2, GAME_STATE.level * 10, asteroidArray, "#008000");
                                spawnAsteroid(g, svg, retrievePosition(collidedAsteroid.attr("transform")).x, retrievePosition(collidedAsteroid.attr("transform")).y, getCircleRadius(collidedAsteroid) / 2, GAME_STATE.level * 10, asteroidArray, "#008000");
                            }
                            removeElement(collidedAsteroid, asteroidArray);
                        });
                    }
                    Observable.interval(500).takeOnceWhen(e => (e >= 2500)).subscribe(_ => {
                        removeElement(rect, bulletArray);
                    });
                });
            });
        }
    });
}
function removeItemFromArray(element, array) {
    array.splice(array.findIndex((currentValue) => (currentValue === element)), 1);
}
function removeElement(element, array) {
    element.elem.remove();
    removeItemFromArray(element, array);
}
function getRandomBetweenTwoNumbers(min, max) {
    return (Math.random() * (+max - +min) + +min);
}
function shipRotate(g, svg, mousemove) {
    mousemove.map(({ clientX, clientY }) => ({ xOffSet: (clientX - retrievePosition(g.attr("transform")).x) - svg.getBoundingClientRect().left,
        yOffSet: (clientY - retrievePosition(g.attr("transform")).y) - svg.getBoundingClientRect().top }))
        .map(obj => ((Math.atan2(obj.xOffSet, -obj.yOffSet)) * (180 / Math.PI)))
        .subscribe(obj => g.attr("transform", transformStringBuilder(g, retrievePosition(g.attr("transform")).x, retrievePosition(g.attr("transform")).y, obj)));
}
function isInAreaSurroundingElem(g, radius, circleX, circleY, circleRadius) {
    return (Math.pow((retrievePosition(g.attr("transform")).x - circleX), 2)
        + (Math.pow(retrievePosition(g.attr("transform")).y - circleY, 2))) <= (Math.pow(radius + circleRadius, 2));
}
function createAsteroid(g, svg, minAsteroidSize, maxAsteroidSize, colorHexCode = '#800080', x = -1, y = -1) {
    if (!svg)
        throw "Couldn't get canvas element!";
    if (maxAsteroidSize >= 100) {
        maxAsteroidSize = 100;
    }
    const radius = Math.floor(getRandomBetweenTwoNumbers(minAsteroidSize, maxAsteroidSize));
    const asteroid = new Elem(svg, 'ellipse');
    asteroid.attr("rx", radius);
    asteroid.attr("ry", radius);
    asteroid.attr("fill", colorHexCode);
    if (x <= -1 && y <= -1) {
        const pointTuple = initCoordinates(getRandomBetweenTwoNumbers(svg.getBoundingClientRect().left, svg.getBoundingClientRect().right))(getRandomBetweenTwoNumbers(svg.getBoundingClientRect().top, svg.getBoundingClientRect().bottom));
        Observable.interval(20).takeWhile(_ => isInAreaSurroundingElem(g, 50, pointTuple.x, pointTuple.y, getCircleRadius(asteroid))).subscribe(_ => {
            pointTuple.x = getRandomBetweenTwoNumbers(svg.getBoundingClientRect().left, svg.getBoundingClientRect().right);
            pointTuple.y = getRandomBetweenTwoNumbers(svg.getBoundingClientRect().top, svg.getBoundingClientRect().bottom);
        });
        asteroid.attr("transform", transformStringBuilder(asteroid, (pointTuple.x), (pointTuple.y), 0));
    }
    else {
        asteroid.attr("transform", transformStringBuilder(asteroid, (x), (y), 0));
    }
    return asteroid;
}
function spawnAsteroid(g, svg, x, y, size, speed, asteroidArray, colorHexCode) {
    const newAsteroid = createAsteroid(g, svg, size, size, colorHexCode, x, y);
    asteroidArray.push(newAsteroid);
    Observable.interval(500).takeWhile(_ => (GAME_STATE.lives > 0)).subscribe(_ => {
        const randomedNumber = getRandomBetweenTwoNumbers(0, 360);
        Observable.interval(100).takeUntil(Observable.interval(getRandomBetweenTwoNumbers(300, 700))).subscribe(_ => moveTowardsAngle(newAsteroid, speed, randomedNumber, svg));
    });
}
function spawnAsteroidRandom(g, svg, rateOfSpawningPerSecond, level, asteroidSpeed, asteroidArray) {
    Observable.interval(1000 / rateOfSpawningPerSecond).takeUntil(Observable.interval(10 * level * 1000 / rateOfSpawningPerSecond)).takeWhile(_ => (GAME_STATE.lives > 0)).subscribe(_ => {
        const newAsteroid = createAsteroid(g, svg, 10 * level, 20 * level);
        asteroidArray.push(newAsteroid);
        Observable.interval(500).takeWhile(_ => (GAME_STATE.lives > 0)).subscribe(_ => {
            const randomedNumber = getRandomBetweenTwoNumbers(0, 360);
            Observable.interval(100).takeUntil(Observable.interval(getRandomBetweenTwoNumbers(300, 700))).subscribe(_ => moveTowardsAngle(newAsteroid, asteroidSpeed, randomedNumber, svg));
        });
    });
}
function initCoordinates(newX) {
    return function (newY) {
        return {
            x: newX,
            y: newY
        };
    };
}
if (typeof window != 'undefined')
    window.onload = () => {
        asteroids();
    };
//# sourceMappingURL=asteroids.js.map