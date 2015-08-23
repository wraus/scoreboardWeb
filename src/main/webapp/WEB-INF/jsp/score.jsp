<!DOCTYPE html>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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
        var socket = new SockJS('<c:url value="/scoreTopic"/>');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function(frame) {
        console.log('Connected: ' + frame);
        stompClient.subscribe('/topic/score', function(score){
        showScore(JSON.parse(score.body));
        });
        stompClient.subscribe('/topic/tweet', function(tweet){
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

        function sendTweet() {

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
                <div><img src="<c:url value='/images/banner.jpg' />" class="banner"/></div>
                <div class="container">
                    <div class="rows">
                        <div class="row">
                            <div class="column">
                                <div class="heading">Score</div>
                                <div class="digits"><span id="wickets">${score.wickets}</span>-<span id="runs">${score.runs}</span></div>
                            </div>
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
                        <div class="row">
                            <div class="column">
                                <form id="tweet" action="#">
                                    <div>
                                        <input id="tweetText" type="text" size="30">
                                        <input type="submit">
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="row">
                            <div class="column">
                                <div>
                                    <textarea id="tweets" cols="37" rows="6" readonly="true"><c:forEach var="tweet" items="${tweets}">${tweet}<%='\n'%></c:forEach></textarea>
                                </div>
                            </div
                        </div>
                        <div class="row"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        $( "form" ).submit(function( event ) {
        var text = $("input#tweetText").val();
        stompClient.send("/app/tweet", {}, JSON.stringify({ 'text': text }));
        event.preventDefault();
        $("input#tweetText").val("");
        $("input#tweetText").focus();
        });
    </script>
</body>
</html>