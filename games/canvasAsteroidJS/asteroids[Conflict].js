"use strict";
function asteroids() {
    const svg = document.getElementById("canvas");
    const mousemove = Observable.fromEvent(svg, 'mousemove'), mouseup = Observable.fromEvent(svg, 'mouseup'), mousedown = Observable.fromEvent(svg, 'mousedown'), keydown = Observable.fromEvent(document, 'keydown'), keyup = Observable.fromEvent(document, 'keyup'), currentLocation = initCoordinates(300)(300), currentAngle = 170;
    mousemove.subscribe(e => console.log(e));
    let g = new Elem(svg, 'g')
        .attr("transform", `translate(300 300) rotate(${currentAngle})`);
    let ship = new Elem(svg, 'polygon', g.elem)
        .attr("points", "-15,20 15,20 0,-20")
        .attr("style", "fill:pink;stroke:purple;stroke-width:1");
    let level = 1;
    shipRotate(g, svg, mousemove);
    shipMove(g, 5, keydown, keyup, svg);
    shipShoot(g, 7, keydown, keyup, svg);
    spawnAsteroid(svg, 300 / level, 1 * level, level, level * 10);
    console.log(svg.children);
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
function moveTowardsAngle(elem, speed, angle) {
    elem.attr("transform", transformStringBuilder(elem, retrievePosition(elem.attr("transform")).x + speed * Math.cos(transformDegreeToRadian(angle)), retrievePosition(elem.attr("transform")).y + speed * Math.sin(transformDegreeToRadian(angle)), retrieveAngle(elem.attr("transform"))));
}
function shipMove(g, speed, keydown, keyup, svg) {
    keydown.filter(ev => ev.repeat === false).subscribe(({ key, shiftKey }) => {
        if (key === "w") {
            Observable.interval(10).takeUntil(keyup.filter(ev => ev.key === "w")).subscribe(_ => moveTowardsAngle(g, speed, retrieveAngle(g.attr("transform")) - 90));
        }
    });
}
function transformStringBuilder(g, x, y, angle) {
    return `translate(${x} ${y}) rotate(${angle})`;
}
function shipShoot(g, speed, keydown, keyup, svg) {
    keydown.filter(ev => ev.repeat === false).subscribe(({ key, shiftKey }) => {
        if (key === " ") {
            Observable.interval(200).takeUntil(keyup.filter(ev => (ev.key === " " && ev.repeat === false))).subscribe(_ => {
                const rect = new Elem(svg, 'rect');
                rect
                    .attr('width', 20).attr('height', 5)
                    .attr('fill', '#DC143C').attr("transform", transformStringBuilder(rect, retrievePosition(g.attr("transform")).x, retrievePosition(g.attr("transform")).y, retrieveAngle(g.attr("transform")) - 90));
                Observable.interval(20)
                    .subscribe(() => moveTowardsAngle(rect, speed, retrieveAngle(rect.attr("transform"))));
                Array.prototype.slice.call(svg.getElementsByTagName('rect'), 0).
                    filter(e => {
                });
            });
        }
    });
}
function removeElement(element, svg) {
    svg.removeChild(element);
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
    return (((retrievePosition(g.attr("transform")).x - circleX) ^ 2)
        + ((retrievePosition(g.attr("transform")).y - circleY) ^ 2)) <= ((radius + circleRadius) ^ 2);
}
function createAsteroid(svg, minAsteroidSize, maxAsteroidSize) {
    if (!svg)
        throw "Couldn't get canvas element!";
    const radius = Math.floor(getRandomBetweenTwoNumbers(minAsteroidSize, maxAsteroidSize));
    const asteroid = new Elem(svg, 'circle');
    asteroid.attr("r", radius);
    asteroid.attr("fill", '#800080');
    asteroid.attr("transform", transformStringBuilder(asteroid, (getRandomBetweenTwoNumbers(svg.getBoundingClientRect().left, svg.getBoundingClientRect().right)), (getRandomBetweenTwoNumbers(svg.getBoundingClientRect().top, svg.getBoundingClientRect().bottom)), 0));
    return asteroid;
}
function spawnAsteroid(svg, radiusAwayFromShip, rateOfSpawningPerSecond, level, asteroidSpeed) {
    Observable.interval(1000 / rateOfSpawningPerSecond).takeUntil(Observable.interval(10 * level * 1000 / rateOfSpawningPerSecond)).subscribe(_ => {
        const newAsteroid = createAsteroid(svg, 100 * level, 2 * level);
        Observable.interval(500).subscribe(_ => {
            const randomedNumber = getRandomBetweenTwoNumbers(0, 360);
            Observable.interval(100).takeUntil(Observable.interval(getRandomBetweenTwoNumbers(300, 700))).subscribe(_ => moveTowardsAngle(newAsteroid, asteroidSpeed, randomedNumber));
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