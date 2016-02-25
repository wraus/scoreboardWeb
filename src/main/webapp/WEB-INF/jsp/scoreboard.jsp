<!DOCTYPE html>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta id="Viewport" name="viewport" width="initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/bootstrap.min.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/scoreboard.css'/>" />
    <script src="<c:url value='/scripts/sockjs-0.3.4.js'/>"></script>
    <script src="<c:url value='/scripts/stomp.js'/>"></script>
    <script src="<c:url value='/scripts/jquery-2.1.4.js'/>"></script>
    <script src="<c:url value='/scripts/easytimer.min.js'/>"></script>
    <script type="text/javascript">
        $(function(){
            if( /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ) {
                var ww = ( $(window).width() < window.screen.width ) ? $(window).width() : window.screen.width; //get proper width
                var mw = 320; // min width of site
                var ratio =  ww / mw; //calculate ratio
                if( ww < mw){ //smaller than minimum size
                    $('#Viewport').attr('content', 'initial-scale=' + ratio + ', maximum-scale=' + ratio + ', minimum-scale=' + ratio + ', user-scalable=yes, width=' + ww);
                }else{ //regular size
                    $('#Viewport').attr('content', 'initial-scale=1.0, maximum-scale=2, minimum-scale=1.0, user-scalable=yes, width=' + ww);
                }
            }
        });

        var stompClient = null;
        var gameClock = new Timer();
        var shotClock = new Timer();
        shotClock.addEventListener('targetAchieved', function (e) {
            //TODO: play shot siren sound
        });
        gameClock.addEventListener('targetAchieved', function (e) {
            //TODO: play quarter siren sound
        });
        var quarterSirenSound = new Audio('sounds/airHorn.mp3');
        var shotClockSound = new Audio('sounds/woopWoop.mp3');
        var umpireSound = new Audio('sounds/dingDong.mp3');

        function init() {
            connect();
            initDisplay();
        }

        function startClocks(gameSecs, shotSecs) {

            //stop clocks and reset
            //TODO: should timers be new instances?
            stopClocks();

            gameClock.start({countdown: true, startValues: {seconds: gameSecs}});
            $("#gameClockMins").html(gameClock.getTimeValues().minutes);
            $("#gameClockSecs").html(gameClock.getTimeValues().seconds);
            gameClock.addEventListener('secondsUpdated', function (e) {
                //console.log("GAME CLOCK",gameClock.getTimeValues());
                //TODO add tenths
                if(gameClock.getTimeValues().minutes === 0){
                    $("#gameClockMins").html(gameClock.getTimeValues().seconds);
                    //$("#gameClockSecs").html(gameClock.getTimeValues().tenths);
                }else{
                    $("#gameClockMins").html(gameClock.getTimeValues().minutes);
                    $("#gameClockSecs").html(gameClock.getTimeValues().seconds);
                }
            });

            startShotClock(shotSecs)
        }

        function startShotClock(secs) {
            shotClock.start({countdown: true, startValues: {seconds: secs}});
            $("#shotClockSecs").html(shotClock.getTimeValues().seconds);
            shotClock.addEventListener('secondsUpdated', function (e) {
                console.log("SHOT CLOCK",shotClock.getTimeValues());
                $("#shotClockSecs").html(shotClock.getTimeValues().seconds);
            });
        }

        function stopClocks() {
            gameClock.stop();
            shotClock.stop();
        }

        function pauseClocks() {
            gameClock.pause();
            shotClock.pause();
        }

        function connect() {
            var socket = new SockJS('<c:url value="/stomp"/>');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function(frame) {
                console.log('Connected: ' + frame);
                stompClient.subscribe('/topic/score', function(score){
                    showScore(JSON.parse(score.body));
                });

            });
        }

        function disconnect() {
            if (stompClient != null) {
                stompClient.disconnect();
            }
            setConnected(false);
            console.log("Disconnected");
        }

        function showScore(message) {
            document.getElementById('team1Score').innerHTML = message.team1.score;
            document.getElementById('team2Score').innerHTML = message.team2.score;
            document.getElementById('team1Name').innerHTML = message.team1.name;
            document.getElementById('team2Name').innerHTML = message.team2.name;
            document.getElementById('period').innerHTML = message.period;

            if(message.command === "START_CLOCK"){
                //synchronize clocks from master clock
                //TODO add tenths secs
                startClocks((+message.gameClock.mins * 60) + parseInt(message.gameClock.secs, 10), +message.shotClock.secs);
            }

            if(message.command === "STOP_CLOCK"){
                //restart clocks with updated times and then pause.
                startClocks((+message.gameClock.mins * 60) + parseInt(message.gameClock.secs, 10), +message.shotClock.secs);
                pauseClocks();
            }


            /*document.getElementById('gameClockMins').innerHTML = message.gameClockMins;
            document.getElementById('gameClockSecs').innerHTML = message.gameClockSecs;
            document.getElementById('gameClockTenthSecs').innerHTML = message.gameClockTenthSecs;
            document.getElementById('shotClockSecs').innerHTML = message.shotClockSecs;
            document.getElementById('shotClockTenthSecs').innerHTML = message.shotClockTenthSecs;
            document.getElementById('direction').innerHTML = message.direction;*/

            /*if (message.wideNBThisOver == 0) {
                $('#wideNBThisOver').hide();
            } else {
                $('#wideNBThisOver').show();
            }*/

            $("[id^=timeoutT]").fadeTo(0, 0.25);
            updateTimeouts("timeoutT1P", message.team1.teamTimeouts);
            updateTimeouts("timeoutT2P", message.team2.teamTimeouts);
            updateTimeouts("timeoutT1C", message.team1.coachTimeouts);
            updateTimeouts("timeoutT2C", message.team2.coachTimeouts);
        }

        function initDisplay() {
            $("[id^=timeoutT]").fadeTo(0, 0.25);
        }

        function updateTimeouts(timeoutGroup, number) {
            if (number != null) {
                for (i=0; i<number; i++) {
                    var num = i+1;
                    $("#"+timeoutGroup+num).fadeTo(0, 1);
                }
            }
        }

    </script>
    <title></title>
</head>
<body onload="init();">
    <div id="wrapper">
        <div id="contentwrap">
            <div id="content">

                <div><a href="<c:url value='/login' />"><img src="<c:url value='/images/banner.jpg' />" class="banner"/></a></div>

                <div class="row">
                    <div class="col-sm-4">
                        <div class="teamPanel panel-primary scorePanel team1">
                            <p><span id="team1Name">${score.team1.name}</span></p>
                            <div class="panel-body">
                                <div class="score"><span id="team1Score">${score.team1.score}</span></div>
                            </div>
                        </div>

                        <div class="teamPanel panel-success scorePanel timeout">
                            Timeouts
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-sm-7">
                                        <img id="timeoutT1P1" src="images/t.jpg" width="30px" height="30px"/>
                                        <img id="timeoutT1P2" src="images/t.jpg" width="30px" height="30px"/>
                                        <img id="timeoutT1P3" src="images/t.jpg" width="30px" height="30px"/>
                                        <img id="timeoutT1P4" src="images/t.jpg" width="30px" height="30px"/>
                                    </div>
                                    <div class="col-sm-4" >
                                        <img id="timeoutT1C1" src="images/t-coach.jpg" width="30px" height="30px"/>
                                        <img id="timeoutT1C2" src="images/t-coach.jpg" width="30px" height="30px"/>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                    <div class="col-sm-4">

                        <div class="panel panel-success">
                            <div class="panel-heading">Game</div>
                            <div class="panel-body game-clock">
                                <div class="digits-alt">
                                    <span id="gameClockMins">${score.gameClock.mins}</span>:<span id="gameClockSecs">${score.gameClock.secs}</span>
                                </div>
                            </div>
                        </div>

                        <div class="panel panel-shotclock">
                            <div class="panel-heading">Shot clock</div>
                            <div class="panel-body shot-clock">
                                <div class="digits-alt">
                                    <span id="shotClockSecs">${score.shotClock.secs}</span>
                                </div>
                            </div>
                        </div>

                        <div class="panel panel-extra">
                            <div class="panel-body">
                                Period: <span id="period">${score.period}</span>
                            </div>
                        </div>

                        <div class="panel panel-shotclock">
                            <div class="panel-body shot-clock">
                                <div><img src="images/geren-arrow-right.png" width="140px" height="80px"/></div>
                                <!--<div><img src="images/geren-arrow-left.png" width="140px" height="80px"/></div>-->
                            </div>
                        </div>

                        <div class="panel panel-extra">
                            <span onclick="quarterSirenSound.play()">Quarter End</span>
                            <span onclick="shotClockSound.play()">Shot Clock</span>
                            <span onclick="umpireSound.play()">Umpire</span>
                        </div>
                        <br/><br/>

                    </div>
                    <div class="col-sm-4">

                        <div class="teamPanel panel-primary scorePanel team1">
                            <p><span id="team2Name">${score.team2.name}</span></p>
                            <div class="panel-body">
                                <div class="score"><span id="team2Score">${score.team2.score}</span></div>
                            </div>
                        </div>

                        <div class="teamPanel panel-success scorePanel timeout">
                            Timeouts
                            <div class="panel-body">
                                <div class="row">
                                    <div class="col-sm-7" >
                                        <img id="timeoutT2P1" src="images/t.jpg" width="30px" height="30px"/>
                                        <img id="timeoutT2P2" src="images/t.jpg" width="30px" height="30px"/>
                                        <img id="timeoutT2P3" src="images/t.jpg" width="30px" height="30px"/>
                                        <img id="timeoutT2P4" src="images/t.jpg" width="30px" height="30px"/>
                                    </div>
                                    <div class="col-sm-4" >
                                        <img id="timeoutT2C1" src="images/t-coach.jpg" width="30px" height="30px"/>
                                        <img id="timeoutT2C2" src="images/t-coach.jpg" width="30px" height="30px"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</body>
</html>