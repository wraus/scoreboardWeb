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

        shotClock.addEventListener('secondTenthsUpdated', function (e) {
            $("#shotClockSecs").html(padDigits(shotClock.getTimeValues().seconds));
        });

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

            startShotClock(shotClockTenthsSecs);
        }

        function startShotClock(shotClockTenths ) {

            var shotClockStartTenths = shotClockTenths || 0;
            shotClock.start({precision: 'secondTenths', countdown: true, startValues: {secondTenths: shotClockStartTenths}});
            $("#shotClockSecs").html(padDigits(shotClock.getTimeValues().seconds));
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
            toggleShotClock(true);
            updateDirection("RIGHT");
            startClocks();
            pauseClocks();

            document.getElementById('team1Score').innerHTML = '0';
            document.getElementById('team2Score').innerHTML = '0';
            document.getElementById('team1Name').innerHTML = 'Home';
            document.getElementById('team2Name').innerHTML = 'Away';

            renderTimeouts(4,2);
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
                    if(message.displayShotClock){
                        shotClockSound.play();
                    }    
                    break;
                case "QUARTER_END":
                    syncClocks(message);
                    pauseClocks();
                    quarterSirenSound.play();
                    break;
                case "NOTIFY_UMPIRE":
                    umpireSound.play();
                    break;
                case "UPDATE_GAME_MESSAGE":
                    updateGameMessage(message.scrollerMessage);
                    break;    
                case "SAVE_TEAM_SETUP":
                    $('body').attr('style','background: '+message.backgroundColour);
                    $('div.teamPanel .panel-body').attr('style','background: '+message.backgroundColour);
                    $('div.team1').attr('style','background: '+message.team1.colour);
                    $('div.team2').attr('style','background: '+message.team2.colour);
                    $("#main-logo").attr("src", "${pageContext.request.contextPath}/scorer/image?key=main-logo&&default=/images/banner.png&"+new Date().getTime());
                    $("#team1-logo").attr("src", "${pageContext.request.contextPath}/scorer/image?key=team1-logo&"+new Date().getTime());
                    $("#team2-logo").attr("src", "${pageContext.request.contextPath}/scorer/image?key=team2-logo&"+new Date().getTime());
                    renderTimeouts(message.teamTimeoutLimit, message.coachTimeoutLimit);
                    setTheme(message.themeColour)
                    break;
            }

            toggleShotClock(message.displayShotClock);
            // $("[id^=timeoutT]").fadeTo(0, 0.1);
            updateTimeouts("timeoutT1P", message.team1.teamTimeouts);
            updateTimeouts("timeoutT2P", message.team2.teamTimeouts);
            updateTimeouts("timeoutT1C", message.team1.coachTimeouts);
            updateTimeouts("timeoutT2C", message.team2.coachTimeouts);
        }

        function setTheme(themeColour) {
            var themeTextColor = "white";
            var themeBorderColor = "#666";
            var themeDigits = "#CCAA00";
            var themeLabels = "#AAA;"
            var themeMessage = "inherit";

            if (themeColour == "DARK") {
                themeTextColor = "#222";
                themeBorderColor = "#333";
                themeDigits = "#d60b26";
                themeLabels = "#333";
                themeMessage = "#222";
            } 
            $('div.score').attr('style','color: '+themeTextColor);
            
            $('div.timeout .team-timeouts').attr('style','border-color: '+themeBorderColor);
            $('div.timeout .coach-timeouts').attr('style','border-color: '+themeBorderColor);
            $('div.game-clock').attr('style','border-color: '+themeBorderColor);
            $('div.shot-clock').attr('style','border-color: '+themeBorderColor);

            $('div.timeout .timeoutText').attr('style','color: '+themeDigits);
            $('div.game-clock .digits-alt span').attr('style','color: '+themeDigits);
            $('div.shot-clock .digits-alt span').attr('style','color: '+themeDigits);

            $('.static-label').attr('style','color: '+themeLabels);
            $('.footer-scroller-panel').attr('style','background-color: '+themeMessage);
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

        function updateGameMessage(gameMessage) {
            if (gameMessage) {
                $('#footer-scroller').show();
                $("#scroller-text").html(gameMessage);
            } else {
                $('#footer-scroller').hide();        
            }
        }
        function renderTimeouts(teamLimit, coachLimit) {
            // alert(teamLimit + " - " + coachLimit);
            for (teamIndex=1; teamIndex<=2; teamIndex++) {
                var teamHtml = "";
                var coachHtml = "";
                
                var teamHtml = "<div class=\"timeoutText\" id=\"timeoutT" + teamIndex + "P" + "\">"+teamLimit+"</div>";                
                var coachHtml = "<div class=\"timeoutText\" id=\"timeoutT" + teamIndex + "C" + "\">"+coachLimit+"</div>";

                $("#team" + teamIndex + "Timeouts").html(teamHtml);
                $("#coach" + teamIndex + "Timeouts").html(coachHtml);
            }
            // $("[id^=timeoutT]").fadeTo(0, 0.1);
        }

        function updateTimeouts(timeoutGroup, number) {
            // alert(number);
            if (number != null) {
                $("#"+timeoutGroup).html(number);
            }
        }

        function toggleShotClock(displayShotClock) {
            if (displayShotClock) {
                $(".panel-shotclock").css("visibility", "visible");
                $(".panel-shotclock").removeClass("shot-clock-no-height");
                $("#period-panel").addClass("col-sm-6");
                $("#period-panel").removeClass("col-sm-12");
            } else { $(".panel-shotclock").css("visibility", "hidden"); 
                $(".panel-shotclock").addClass("shot-clock-no-height");
                $("#period-panel").removeClass("col-sm-6");
                $("#period-panel").addClass("col-sm-12");
            }
        }

    </script>
    <title></title>
</head>
<body onload="init();">
    <div id="wrapper">
        <div id="contentwrap">
            <div id="content">
                <div class="row banner-row">
                    <div class="col-sm-4">
                        <img id="team1-logo" src="<c:url value='/scorer/image?key=team1-logo'/>" />
                    </div>
                    <div class="col-sm-4"> 
                        <img id="main-logo" src="<c:url value='/scorer/image?key=main-logo&default=/images/banner.png' />" class="banner"/>
                    </div>
                    <div class="col-sm-4">
                        <img id="team2-logo" src="<c:url value='/scorer/image?key=team2-logo'/>" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-4">
                        <div class="teamPanel panel-primary scorePanel team1">
                            <p><span id="team1Name">${score.team1.name}</span></p>
                            <div class="panel-body">
                                <div class="score"><span id="team1Score">${score.team1.score}</span></div>
                            </div>
                        </div>

                        <div class="timeoutPanel scorePanel timeout">
                            <div class="panel-heading">
                                <h3 class="panel-title static-label">Timeouts</h3>
                            </div>
                            <div class="panel-body">
                                <div class="row digits-alt">
                                    <div class="col-sm-5 team-timeouts" id="team1Timeouts"></div>
                                    <div class="col-sm-2"></div>
                                    <div class="col-sm-5 coach-timeouts" id="coach1Timeouts"></div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-5 static-label">Player</div>
                                    <div class="col-sm-2"></div>
                                    <div class="col-sm-5 static-label">Coach</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">

                        <div class="panel panel-firstpanel">
                            <div class="panel-body game-clock">

                                <div class="digits-alt">
                                    <span id="gameClockMins">${score.gameClock.mins}</span><span>:</span><span id="gameClockSecs">${score.gameClock.secs}</span>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-12 panel-shotclock-period">

                            <div id="period-panel" class="panel panel-extra">
                                <div class="panel-heading">
                                    <h3 class="panel-title static-label">Quarter</h3>
                                </div>
                                <div class="panel-body shot-clock">
                                    <div class="digits-alt">
                                        <span id="period">${score.period}</span>
                                    </div>
                                </div>
                            </div>

                            <div class="col-sm-6 panel panel-shotclock">
                                <div class="panel-heading">
                                    <h3 class="panel-title static-label">Shot Clock</h3>
                                </div>
                                <div class="panel-body shot-clock">
                                    <div class="digits-alt">
                                        <span id="shotClockSecs">${score.shotClock.secs}</span>
                                    </div>
                                </div>
                            </div>
                            
                        </div>

                        <div class="col-sm-12 arrow-panel">
                            <div class="panel-body">
                                <div id="arrowRight"><img src="images/green-arrow-right.png"/></div>
                                <div id="arrowLeft"><img src="images/green-arrow-left.png"/></div>
                            </div>
                        </div>

                    </div>
                    <div class="col-sm-4">
                        
                        <div class="teamPanel panel-primary scorePanel team2">
                            <p><span id="team2Name">${score.team2.name}</span></p>
                            <div class="panel-body">
                                <div class="score"><span id="team2Score">${score.team2.score}</span></div>
                            </div>
                        </div>

                        <div class="timeoutPanel scorePanel timeout">
                            <div class="panel-heading">
                                <h3 class="panel-title static-label">Timeouts</h3>
                            </div>
                            <div class="panel-body">
                                <div class="row digits-alt">
                                    <div class="col-sm-5 team-timeouts" id="team2Timeouts"></div>
                                    <div class="col-sm-2"></div>
                                    <div class="col-sm-5 coach-timeouts" id="coach2Timeouts"></div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-5 static-label">Player</div>
                                    <div class="col-sm-2"></div>
                                    <div class="col-sm-5 static-label">Coach</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>


    <nav class="navbar navbar-default navbar-fixed-bottom footer">
        <div class="container">
            <div class="row">
                <div class="footer-image-left">
                    <img src="/images/logo-old.svg" style="width:72px;height:90px;">
                </div>
                <div class="col-sm-1"></div>
                <div class="col-sm-10">
                    <div class="footer-scroller-panel" id="footer-scroller">
                        <marquee behavior="scroll" direction="left" id="scroller-text">Welcome to the Game!</marquee>
                    </div>
                </div>
                <div class="col-sm-1"></div>
                <div class="footer-image-right">
                    <img src="/images/auspost-logo.png">
                </div>
            </div>
        </div>
    </nav>
</body>
</html>