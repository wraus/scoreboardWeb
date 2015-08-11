<!DOCTYPE html>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="css/scoreboard.css" />
    <script src="/scripts/sockjs-0.3.4.js"></script>
    <script src="/scripts/stomp.js"></script>
    <script type="text/javascript">
        var stompClient = null;

        function connect() {
            var socket = new SockJS('/scoreTopic');
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
            document.getElementById('wickets').innerHTML = message.wickets;
            document.getElementById('runs').innerHTML = message.runs;
            document.getElementById('overs').innerHTML = message.overs;
            document.getElementById('balls').innerHTML = message.balls;
            document.getElementById('wideNBThisOver').innerHTML = message.wideNBThisOver;
            document.getElementById('extras').innerHTML = message.extras;
            document.getElementById('target').innerHTML = message.target;
        }
    </script>
    <title></title>
</head>
<body onload="connect()">
    <div id="wrapper">
        <div id="contentwrap">
        <div id="content">
            <div><img src="/images/banner.jpg" class="banner"/></div>
            <div class="container">
                <div class="rows">
                    <div class="row">
                        <div class="column">
                            <div class="heading">Score</div>
                            <div class="digits"><span id="wickets">${score.wickets}</span>-<span id="runs">${score.runs}</span></div>
                        </div
                    </div>
                    <div class="row">
                        <div class="column">
                            <div class="heading">Overs</div>
                            <div class="digits-alt"><span id="overs">${score.overs}</span>.<span id="balls">${score.balls}</span></div>
                        </div>
                        <div class="column">
                            <div class="heading">Wide/NBs</div>
                            <div class="digits"><span id="wideNBThisOver">${score.wideNBThisOver}</span></div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="column">
                            <div class="heading">Extras</div>
                            <div class="digits-alt"><span id="extras">${score.extras}</span></div>
                        </div>
                        <div class="column">
                            <div class="heading">Target</div>
                            <div class="digits"><span id="target">${score.target}</span></div>
                        </div>
                    </div>
                    <div class="row" />
                </div>
            </div>
        </div>
    <div>
</body>
</html>