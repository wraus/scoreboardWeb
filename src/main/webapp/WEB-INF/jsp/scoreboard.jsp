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
    <script src="<c:url value='/scripts/wr-common.js'/>"></script>
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
        var quarterSirenSound = new Audio('sounds/airHorn.mp3');
        var shotClockSound = new Audio('sounds/woopWoop.mp3');
        var umpireSound = new Audio('sounds/dingDong.mp3');

        function init() {
            connect();
            setDefaultValues();
        }

        function startClocks(gameClockTenthsSecs, shotClockTenthsSecs) {

            //stop clocks and reset
            stopClocks();

            var gameTenthsSecs = gameClockTenthsSecs || 0;

            gameClock.start({precision: 'secondTenths', countdown: true, startValues: {secondTenths: gameTenthsSecs}});
            if(gameClock.getTimeValues().minutes === 0){
                $("#gameClockMins").html(padDigits(gameClock.getTimeValues().seconds));
                $("#gameClockSecs").html(gameClock.getTimeValues().secondTenths);
            }else{
                $("#gameClockMins").html(padDigits(gameClock.getTimeValues().minutes));
                $("#gameClockSecs").html(padDigits(gameClock.getTimeValues().seconds));
            }
            gameClock.addEventListener('secondTenthsUpdated', function (e) {
                //console.log("GAME CLOCK",gameClock.getTimeValues());
                if(gameClock.getTimeValues().minutes === 0){
                    $("#gameClockMins").html(padDigits(gameClock.getTimeValues().seconds));
                    $("#gameClockSecs").html(gameClock.getTimeValues().secondTenths);
                }else{
                    $("#gameClockMins").html(padDigits(gameClock.getTimeValues().minutes));
                    $("#gameClockSecs").html(padDigits(gameClock.getTimeValues().seconds));
                }
            });

            startShotClock(shotClockTenthsSecs);
        }

        function startShotClock(shotClockTenths ) {

            var shotClockStartTenths = shotClockTenths || 0;
            shotClock.start({precision: 'secondTenths', countdown: true, startValues: {secondTenths: shotClockStartTenths}});
            $("#shotClockSecs").html(padDigits(shotClock.getTimeValues().seconds));
            shotClock.addEventListener('secondTenthsUpdated', function (e) {
                $("#shotClockSecs").html(padDigits(shotClock.getTimeValues().seconds));
            });
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

        function setDefaultValues() {
            $("[id^=timeoutT]").fadeTo(0, 0.25);
            toggleShotClock("true");
            updateDirection();
            startClocks();
            pauseClocks();
            document.getElementById('team1Score').innerHTML = '0';
            document.getElementById('team2Score').innerHTML = '0';
            document.getElementById('team1Name').innerHTML = 'Home';
            document.getElementById('team2Name').innerHTML = 'Away';

        }

        function syncClocks(message){
            startClocks((+message.gameClock.mins * 600) + (+message.gameClock.secs * 10)
                    + parseInt(message.gameClock.tenths, 10),
                    (+message.shotClock.secs * 10) + parseInt(message.shotClock.tenths, 10));
        }

        function showScore(message) {
            document.getElementById('team1Score').innerHTML = message.team1.score;
            document.getElementById('team2Score').innerHTML = message.team2.score;
            document.getElementById('team1Name').innerHTML = message.team1.name;
            document.getElementById('team2Name').innerHTML = message.team2.name;
            document.getElementById('period').innerHTML = message.period;
            updateDirection(message.direction);

            switch (message.command) {
                case "START_CLOCK":
                    //synchronize clocks from master clock
                    syncClocks(message);
                    break;
                case "STOP_CLOCK":
                case "SCORE":
                case "TIMEOUT":
                    //restart clocks with updated times and then pause.
                    syncClocks(message);
                    pauseClocks();
                    break;
                case "SHOT_CLOCK_END":
                    shotClock.stop();
                    gameClock.pause();
                    $("#shotClockSecs").html(padDigits(0));
                    shotClockSound.play();
                    break;
                case "QUARTER_END":
                    stopClocks();
                    $("#shotClockSecs").html(padDigits(0));
                    $("#gameClockSecs").html(padDigits(0));
                    $("#gameClockTenths").html(padDigits(0));
                    quarterSirenSound.play();
                    break;
                case "HIDE_SHOT_CLOCK":
                    toggleShotClock("false");
                    break;
                case "NOTIFY_UMPIRE":
                    umpireSound.play();
                    break;
                case "SAVE_TEAM_SETUP":
                    $('div.team1').attr('style','background: '+message.team1.colour);
                    $('div.team2').attr('style','background: '+message.team2.colour);
                    $("#main-logo").attr("src", "${pageContext.request.contextPath}/scorer/image?key=main-logo&&default=/images/banner.png&"+new Date().getTime());
                    $("#team1-logo").attr("src", "${pageContext.request.contextPath}/scorer/image?key=team1-logo&"+new Date().getTime());
                    $("#team2-logo").attr("src", "${pageContext.request.contextPath}/scorer/image?key=team2-logo&"+new Date().getTime());
                    toggleShotClock(message.displayShotClock);
                    break;
            }

            renderTimeouts(message.teamTimeoutLimit, message.coachTimeoutLimit);
            updateTimeouts("timeoutT1P", message.team1.teamTimeouts);
            updateTimeouts("timeoutT2P", message.team2.teamTimeouts);
            updateTimeouts("timeoutT1C", message.team1.coachTimeouts);
            updateTimeouts("timeoutT2C", message.team2.coachTimeouts);
        }

        function updateDirection(direction) {
            if (direction == "RIGHT") {
                $("#arrowRight").show();
                $("#arrowLeft").hide();
            } else {
                $("#arrowRight").hide();
                $("#arrowLeft").show();
            }
        }

        function renderTimeouts(teamLimit, coachLimit) {
            //alert(teamLimit + " - " + coachLimit);
            for (teamIndex=1; teamIndex<=2; teamIndex++) {
                var teamHtml = "";
                var coachHtml = "";
                for (i=1; i<=teamLimit; i++) {
                    teamHtml += "<img id=\"timeoutT" + teamIndex + "P" + i + "\" src=\"images/t_bw.png\" width=\"30px\" height=\"30px\"/>";
                }
                for (i=1; i<=coachLimit; i++) {
                    coachHtml += "<img id=\"timeoutT" + teamIndex + "C" + i + "\" src=\"images/c_bw.png\" width=\"30px\" height=\"30px\"/>";
                }
                $("#team" + teamIndex + "Timeouts").html(teamHtml);
                $("#coach" + teamIndex + "Timeouts").html(coachHtml);
            }
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

        function toggleShotClock(displayShotClock) {
            if (displayShotClock === "true") {
                $(".panel-shotclock").css("visibility", "visible");
            } else { $(".panel-shotclock").css("visibility", "hidden"); }
        }

    </script>
    <title></title>
</head>
<body onload="init();">
    <div id="wrapper">
        <div id="contentwrap">
            <div id="content">

                <div><a href="<c:url value='/login' />"><img id="main-logo" src="<c:url value='/scorer/image?key=main-logo&default=/images/banner.png' />" class="banner"/></a></div>

                <div class="row">
                    <div class="col-sm-4">
                        <img id="team1-logo" src="<c:url value='/scorer/image?key=team1-logo'/>" />
                        <div class="teamPanel panel-primary scorePanel team1">
                            <p><span id="team1Name">${score.team1.name}</span></p>
                            <div class="panel-body">
                                <div class="score"><span id="team1Score">${score.team1.score}</span></div>
                            </div>
                        </div>

                        <div class="teamPanel scorePanel timeout">
                            Timeouts
                            <div class="row">
                                <div class="col-sm-7" id="team1Timeouts"></div>
                                <div class="col-sm-5" id="coach1Timeouts"></div>
                            </div>
                        </div>

                    </div>
                    <div class="col-sm-4">

                        <br/><br/>
                        <div class="panel">
                            <div class="panel-body game-clock">
                                <div class="digits-alt">
                                    <span id="gameClockMins">${score.gameClock.mins}</span>:<span id="gameClockSecs">${score.gameClock.secs}</span>
                                </div>
                            </div>
                        </div>

                        <div class="panel panel-shotclock">
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

                        <div class="panel">
                            <div class="panel-body">
                                <div id="arrowRight"><img src="images/geren-arrow-right.png" width="140px" height="80px"/></div>
                                <div id="arrowLeft"><img src="images/geren-arrow-left.png" width="140px" height="80px"/></div>
                            </div>
                        </div>
                        <br/><br/>

                    </div>
                    <div class="col-sm-4">
                        <img id="team2-logo" src="<c:url value='/scorer/image?key=team2-logo'/>" />
                        <div class="teamPanel panel-primary scorePanel team2">
                            <p><span id="team2Name">${score.team2.name}</span></p>
                            <div class="panel-body">
                                <div class="score"><span id="team2Score">${score.team2.score}</span></div>
                            </div>
                        </div>

                        <div class="teamPanel panel-success scorePanel timeout">
                            Timeouts
                            <div class="row">
                                <div class="col-sm-7" id="team2Timeouts"></div>
                                <div class="col-sm-5" id="coach2Timeouts"></div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</body>
</html>