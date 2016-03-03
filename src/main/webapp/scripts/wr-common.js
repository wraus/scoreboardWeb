function padDigits(number) {
    return ("0" + number).slice(-2);
}

function stopClocks() {
    gameClock.stop();
    shotClock.stop();
}

function pauseClocks() {
    gameClock.pause();
    shotClock.pause();
}

