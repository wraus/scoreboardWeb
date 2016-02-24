<!DOCTYPE html>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta id="Viewport" name="viewport" width="initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/scoreboard.css'/>" />
    <script src="<c:url value='/scripts/sockjs-0.3.4.js'/>"></script>
    <script src="<c:url value='/scripts/stomp.js'/>"></script>
    <script src="<c:url value='/scripts/jquery-2.1.4.js'/>"></script>
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

        function connect() {
            var socket = new SockJS('<c:url value="/stomp"/>');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function(frame) {
                console.log('Connected: ' + frame);
                stompClient.subscribe('/topic/score', function(score){
                    showScore(JSON.parse(score.body));
                });
                stompClient.subscribe('/topic/tweet', function(tweet) {
                    json = JSON.parse(tweet.body);
                    var text = $("#tweets").val();
                    var newText = json.text + "\n" + text;
                    $("#tweets").val(newText);
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
            document.getElementById('team1Score').innerHTML = message.team1Score;
            document.getElementById('team2Score').innerHTML = message.team2Score;
            document.getElementById('team1Name').innerHTML = message.team1Name;
            document.getElementById('team2Name').innerHTML = message.team2Name;
            /*document.getElementById('gameClockMins').innerHTML = message.gameClockMins;
            document.getElementById('gameClockSecs').innerHTML = message.gameClockSecs;
            document.getElementById('gameClockTenthSecs').innerHTML = message.gameClockTenthSecs;
            document.getElementById('shotClockSecs').innerHTML = message.shotClockSecs;
            document.getElementById('shotClockTenthSecs').innerHTML = message.shotClockTenthSecs;
            document.getElementById('period').innerHTML = message.period;
            document.getElementById('possession').innerHTML = message.possession;*/
            /*if (message.wideNBThisOver == 0) {
                $('#wideNBThisOver').hide();
            } else {
                $('#wideNBThisOver').show();
            }*/

        }
    </script>
    <title></title>
</head>
<body onload="connect()">
    <div id="wrapper">
        <div id="contentwrap">
            <div id="content">
                <div><a href="<c:url value='/login' />"><img src="<c:url value='/images/banner.jpg' />" class="banner"/></a></div>
                <div class="container">
                    <div class="rows">
                        <div class="row">
                            <div class="column">
                                <div class="heading">Score</div>
                                <div class="score"><span id="team1Score">${score.team1Score}</span></div>
                            </div>
                            <div class="column">
                                <div class="heading">Score</div>
                                <div class="score"><span id="team2Score">${score.team2Score}</span></div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="column">
                                <div class="team"><span id="team1Name">${score.team1Name}</span></div>
                            </div>
                            <div class="column">
                                <div class="team"><span id="team2Name">${score.team2Name}</span></div>
                            </div>
                        </div>


                    </div>
                </div>
            </div>
        </div>
    </div>
    <%--<script>
        $( "form" ).submit(function( event ) {
            var text = $("input#tweetText").val();
            stompClient.send("/app/tweet", {}, JSON.stringify({ 'text': text }));
            event.preventDefault();
            $("input#tweetText").val("");
            $("input#tweetText").focus();
        });
    </script>--%>
</body>
</html>