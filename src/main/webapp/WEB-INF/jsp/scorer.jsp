<!DOCTYPE html>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="req" value="${pageContext.request}" />
<c:set var="url">${req.requestURL}</c:set>
<c:set var="uri" value="${req.requestURI}" />
<html lang="en">
<head>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/bootstrap.min.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/scorer.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/bootstrap-toggle.min.css'/>"/>

    <script src="<c:url value='/scripts/sockjs-0.3.4.js'/>"></script>
    <script src="<c:url value='/scripts/stomp.js'/>"></script>
    <script src="<c:url value='/scripts/jquery-2.1.4.js'/>"></script>
    <script src="<c:url value='/scripts/bootstrap.min.js'/>"></script>
    <script src="<c:url value='/scripts/bootstrap-toggle.min.js'/>"></script>
    <script src="<c:url value='/scripts/scorer-utils.js'/>"></script>
    <script src="<c:url value='/scripts/easytimer.min.js'/>"></script>
    <script src="<c:url value='/scripts/wr-common.js'/>"></script>

    <c:set var="home">${fn:substring(url, 0, fn:length(url) - fn:length(uri))}${req.contextPath}/</c:set>
    <c:set var="teamColours">red,green,yellow,blue,orange,#222,#DDD</c:set>
</head>
<body onload="connect()">

<nav class="navbar navbar-inverse">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Wheelchair Rugby Controller</a>
        </div>
    </div>
</nav>

<div class="container" >

    <ul class="nav nav-pills">
        <li class="active"><a data-toggle="pill" href="#home">Game</a></li>
        <li><a data-toggle="pill" href="#menu1">Team Setup</a></li>
    </ul>
    <div class="tab-content">
        <div id="home" class="tab-pane fade in active">

            <form class="form-horizontal" id="game-manager">


            <div class="panel panel-primary">
                <div class="panel-body">

                    <div class="row">
                        <div class="col-sm-8">
                            <div class="form-group form-group-lg" >
                                <label class="col-sm-3 control-label" >Game clock:</label>
                                <div class="col-sm-2" >
                                    <input type=text class="form-control input-lg" id="gameClockMins">
                                </div>
                                <div class="col-sm-2" >
                                    <input type=text class="form-control input-lg" id="gameClockSecs">
                                </div>
                                <div class="col-sm-2" >
                                    <input type=text class="form-control input-lg" id="gameClockTenths">
                                </div>
                                <div class="col-sm-3" >
                                    <button type="button" id="bth-reset-qtr" class="btn btn-primary btn-lg">Reset Quarter</button>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Period:</label>
                                <div class="col-sm-7">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number" disabled="disabled" data-type="minus" data-field="period[]">
                                            <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="period[]" id="period" value="1" min="1" max="4">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-success btn-number" data-type="plus" data-field="period[]">
                                            <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-8">
                            <div class="form-group form-group-lg" >
                                <label class="col-sm-3 control-label">Shot clock:</label>
                                <div class="col-sm-2" >
                                    <input type=text class="form-control input-lg" id="shotClockSecs">
                                </div>
                                <div class="col-sm-2" >
                                    <input type=text class="form-control input-lg" id="shotClockTenths">
                                </div>
                                <div class="col-sm-2" >
                                    <button type="button" id="bth-reset-40" class="btn btn-primary btn-lg">Reset 40</button>
                                </div>
                                <div class="col-sm-2" >
                                    <button type="button" id="bth-reset-15" class="btn btn-primary btn-lg">Reset 15</button>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                                <label class="col-sm-5 control-label">Possession:</label>
                                <div class="col-sm-5">
                                    <input type="checkbox" id="possession" checked data-toggle="toggle" data-onstyle="info" data-offstyle="warning" data-on="<i class='fa fa-play'></i> ---&gt" data-off="<i class='fa fa-pause'></i> &lt---">
                                </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-sm-8">
                            <div class="form-group">
                                <div class="col-sm-3 align-left" >
                                    <button type="button" id="btn-umpire" class="btn btn-primary btn-lg">Umpire</button>
                                </div>
                                <div class="col-sm-7 align-cntr" >
                                    <input type="checkbox" id="start" checked data-toggle="toggle" data-size="large" data-onstyle="success" data-offstyle="danger" data-on="<i class='fa fa-play'></i> START" data-off="<i class='fa fa-pause'></i> STOP">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div class="row">
                <div class="col-sm-6">

                    <div class="panel panel-success">
                        <div class="panel-heading">Team 1</div>
                        <div class="panel-body">
                            <div class="form-group form-group-lg">
                                <label class="col-sm-4 control-label">Score</label>
                                <div class="col-sm-6">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number btn-lg" disabled="disabled" data-type="minus" data-field="team1Score[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="team1Score[]" id="team1Score" value="0" min="0" max="999">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-success btn-number btn-lg" data-type="plus" data-field="team1Score[]">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Team Timeouts</label>
                                <div class="col-sm-5">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number" disabled="disabled" data-type="minus" data-field="team1Timeout[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="team1Timeout[]" id="team1Timeout" value="0" min="0" max="4">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-success btn-number" data-type="plus" data-field="team1Timeout[]">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Coach Timeouts</label>
                                <div class="col-sm-5">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number" disabled="disabled" data-type="minus" data-field="coach1Timeout[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="coach1Timeout[]" id="coach1Timeout" value="0" min="0" max="2">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-success btn-number" data-type="plus" data-field="coach1Timeout[]">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="panel panel-success">
                        <div class="panel-heading">Team 2</div>
                        <div class="panel-body">
                            <div class="form-group form-group-lg">
                                <label class="col-sm-4 control-label">Score</label>
                                <div class="col-sm-6">

                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number btn-lg" disabled="disabled" data-type="minus" data-field="team2Score[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="team2Score[]" id="team2Score" value="0" min="0" max="999">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-success btn-number btn-lg" data-type="plus" data-field="team2Score[]">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                        </span>
                                    </div>

                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Team Timeouts</label>
                                <div class="col-sm-5">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number" disabled="disabled" data-type="minus" data-field="team2Timeout[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="team2Timeout[]" id="team2Timeout" value="0" min="0" max="4">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-success btn-number" data-type="plus" data-field="team2Timeout[]">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Coach Timeouts</label>
                                <div class="col-sm-5">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number" disabled="disabled" data-type="minus" data-field="coach2Timeout[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="coach2Timeout[]" id="coach2Timeout" value="0" min="0" max="2">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-success btn-number" data-type="plus" data-field="coach2Timeout[]">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            </form>
        </div>


        <!-- ************************************************************************************************** -->
        <!-- SECOND TAB MENU PANEL -->
        <!-- ************************************************************************************************** -->

        <div id="menu1" class="tab-pane fade">
            <form class="form-horizontal" id="score-manager">

            <!--<div class="panel panel-default">-->
                <!--&lt;!&ndash;<div class="panel-heading">Team Configuration</div>&ndash;&gt;-->
                <!--<div class="panel-body">-->

                        <div class="row">
                            <div class="col-sm-12">
                            <div class="panel panel-success">
                                <div class="panel-heading">Logo</div>
                                <div class="panel-body">
                                    <div class="col-sm-3">
                                        <input id="main-filename" type="text" class="form-control" readonly />
                                    </div>
                                    <div class="col-sm-3">
                                        <span class="btn btn-primary btn-file">
                                            Browse<input type="file" id="main-logo-select" name="mainLogo" />
                                        </span>
                                        <button type="button" id="btn-main-logo-upload" class="btn btn-primary">Upload</button>
                                    </div>
                                    <div class="col-sm-6">
                                        <img id="main-logo" src="<c:url value='/scorer/image?key=main-logo&default=/images/banner.png'/>" />
                                    </div>
                                </div>
                            </div>
                            </div>
                        </div>

                <!--</div>-->
            <!--</div>-->

                        <div class="row">
                            <div class="col-sm-6">
                                <div class="panel panel-success">
                                    <div class="panel-heading"><strong>Team 1</strong></div>
                                    <div class="panel-body">
                                        <div class="form-group form-group-lg">
                                            <label class="col-sm-2 control-label">Name</label>
                                            <div class="col-sm-9">
                                                <input type=text class="form-control" id="team1Name">
                                            </div>
                                        </div>
                                        <div class="form-group form-group-lg">
                                            <label class="col-sm-2 control-label">Colour</label>
                                            <div class="col-sm-9">
                                                <div class="radio colour-picker">
                                                    <ul>
                                                        <c:forTokens items="${teamColours}" delims="," var="colour">
                                                            <li><input type="radio" name="team1Colour" value="${colour}"><div style="background:${colour};"></div></li>
                                                        </c:forTokens>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group form-group-lg">
                                            <label class="col-sm-2 control-label">Icon</label>
                                            <div class="col-sm-6">
                                                <input id="team1-filename" type="text" class="form-control" readonly />
                                            </div>
                                            <div class="col-sm-4">
                                                <span class="btn btn-primary btn-file">
                                                    Browse<input type="file" id="team1-logo-select" name="team1Logo" />
                                                </span>
                                                <button type="button" id="btn-team1-logo-upload" class="btn btn-primary">Upload</button>
                                            </div>
                                        </div>
                                        <div class="form-group form-group-lg">
                                            <div class="col-sm-2"></div>
                                            <div class="col-sm-9">
                                                <img id="team1-logo" src="<c:url value='/scorer/image?key=team1-logo'/>" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="panel panel-success">
                                    <div class="panel-heading"><STRONG>Team 2</STRONG></div>
                                    <div class="panel-body">
                                        <div class="form-group form-group-lg">
                                            <label class="col-sm-2 control-label">Name</label>
                                            <div class="col-sm-9">
                                                <input type="text" class="form-control" id="team2Name">
                                            </div>
                                        </div>
                                        <div class="form-group form-group-lg">
                                            <label class="col-sm-2 control-label">Colour</label>
                                            <div class="col-sm-9">
                                                <div class="radio colour-picker">
                                                    <ul>
                                                        <c:forTokens items="${teamColours}" delims="," var="colour">
                                                            <li><input type="radio" name="team2Colour" value="${colour}"><div style="background:${colour};"></div></li>
                                                        </c:forTokens>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group form-group-lg">
                                            <label class="col-sm-2 control-label">Icon</label>
                                            <div class="col-sm-5">
                                                <input id="team2-filename" type="text" class="form-control" readonly />
                                            </div>
                                            <div class="col-sm-4">
                                                <span class="btn btn-primary btn-file">
                                                    Browse<input type="file" id="team2-logo-select" name="team2Logo" />
                                                </span>
                                                <button type="button" id="btn-team2-logo-upload" class="btn btn-primary">Upload</button>
                                            </div>
                                        </div>
                                        <div class="form-group form-group-lg">
                                            <div class="col-sm-2"></div>
                                            <div class="col-sm-9">
                                                <img id="team2-logo" src="<c:url value='/scorer/image?key=team2-logo'/>" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-sm-offset-5 col-sm-10">
                                <button type="button" id="bth-save" class="btn btn-primary btn-lg">Update Scoreboard</button>
                            </div>
                        </div>


            </form>
        </div><!-- end TAB PANE -->
    </div>

</div>

<div class="container">
    <footer>
        <p>
            Sponsored by <a href="http://http://auspost.com.au/">Australia Post</a>
        </p>
    </footer>
</div>

<script type="text/javascript">

    var stompClient = null;
    var gameClock = new Timer();
    var shotClock = new Timer();

    shotClock.addEventListener('targetAchieved', function (e) {
        pauseGameClock();
        shotClock.stop();
        $("#shotClockTenths").val(padDigits(0));
        stompIt("SHOT_CLOCK_END","SHOT_CLOCK_END");
        startShotClock(40);
        shotClock.pause();
        $('#start').off('change');
        $('#start').bootstrapToggle('on');
        $('#start').on('change', handleStartStop);
    });

    gameClock.addEventListener('targetAchieved', function (e) {
        stopClocks();
        $("#shotClockTenths").val(padDigits(0));
        $("#gameClockTenths").val(padDigits(0));
        $('#start').off('change');
        $('#start').bootstrapToggle('on');
        $('#start').on('change', handleStartStop);
        $('#possession').bootstrapToggle('toggle');
        $('#period').val(+$("#period").val() + 1);
        stompIt("QUARTER_END","QUARTER_END");
        startGameClock();
        pauseClocks();
    });

    function connect() {
        var socket = new SockJS('<c:url value="/stomp"/>');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function(frame) {
            console.log('Connected: ' + frame);
            stompClient.subscribe('/topic/score', function(score){
                //showScore(JSON.parse(score.body));
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

    function startGameClock() {

        //start quarter clock, default is 8 mins if not already running
        gameClock.start({precision: 'secondTenths', countdown: true, startValues: {seconds: 480}});
            $("#gameClockMins").val(padDigits(gameClock.getTimeValues().minutes));
            $("#gameClockSecs").val(padDigits(gameClock.getTimeValues().seconds));
            $("#gameClockTenths").val(gameClock.getTimeValues().secondTenths);
        gameClock.addEventListener('secondTenthsUpdated', function (e) {
            //console.log("GAME CLOCK",gameClock.getTimeValues().toString());
            $("#gameClockMins").val(padDigits(gameClock.getTimeValues().minutes));
            $("#gameClockSecs").val(padDigits(gameClock.getTimeValues().seconds));
            $("#gameClockTenths").val(gameClock.getTimeValues().secondTenths);
            if(gameClock.getTimeValues().minutes === 0 && gameClock.getTimeValues().seconds < 40){
                shotClock.stop();
                startShotClock(40);
                shotClock.pause();
                stompIt("HIDE_SHOT_CLOCK","HIDE_SHOT_CLOCK");
            }
        });

        //starting quarter clock should always start shot clock, default 40 secs if not already running
        startShotClock(40);
    }

    function startShotClock(secs) {
        shotClock.start({precision: 'secondTenths', countdown: true, startValues: {seconds: secs}});
        $("#shotClockSecs").val(padDigits(shotClock.getTimeValues().seconds));
        $("#shotClockTenths").val(shotClock.getTimeValues().secondTenths);
        shotClock.addEventListener('secondTenthsUpdated', function (e) {
            //console.log("SHOT CLOCK",shotClock.getTimeValues());
            $("#shotClockSecs").val(padDigits(shotClock.getTimeValues().seconds));
            $("#shotClockTenths").val(shotClock.getTimeValues().secondTenths);
        });
    }

    function handleStartStop() {
        if (!$("#start").is(':checked')) {
            startGameClock();
            stompIt("START_CLOCK","START_CLOCK");
        }else{
            pauseGameClock();
            stompIt("STOP_CLOCK","STOP_CLOCK");
        }
    }

    function stopGameWithoutEventFire() {
        $('#start').off('change');
        if (!$("#start").is(':checked')) {
            $('#start').bootstrapToggle('on')
        }
        $('#start').on('change',handleStartStop);
    }

    jQuery(document).ready(function ($) {

        $("#team1Score").change(function (event) { stompIt("","TEAM1_SCORE"); });
        $("#team2Score").change(function (event) { stompIt("","TEAM2_SCORE"); });
        $("#team1Timeout").change(function (event) { stompIt("","TEAM1_TIMEOUT"); });
        $("#team2Timeout").change(function (event) { stompIt("","TEAM2_TIMEOUT"); });
        $("#coach1Timeout").change(function (event) { stompIt("","COACH1_TIMEOUT"); });
        $("#coach2Timeout").change(function (event) { stompIt("","COACH2_TIMEOUT"); });
        $("#period").change(function (event) { stompIt("","PERIOD"); });
        $("#possession").change(function (event) { stompIt("","POSSESSION"); });
        $("#start").change(handleStartStop);

        $("#bth-reset-qtr").click(function (event) {
            // Prevent the form from submitting via the browser.
            event.preventDefault();
            stopGameClock();
            stopGameWithoutEventFire();
            startGameClock();
            pauseGameClock();
            stompIt("STOP_CLOCK","RESET_QTR");
        });

        $("#bth-reset-40").click(function (event) {
            // Prevent the form from submitting via the browser.
            event.preventDefault();
            shotClock.stop();
            stopGameWithoutEventFire();
            startShotClock(40);
            pauseGameClock();
            stompIt("STOP_CLOCK","RESET_SHOT_40");
        });

        $("#bth-reset-15").click(function (event) {
            // Prevent the form from submitting via the browser.
            event.preventDefault();
            shotClock.stop();
            stopGameWithoutEventFire();
            startShotClock(15);
            pauseGameClock();
            stompIt("STOP_CLOCK","RESET_SHOT_15");
        });

        $("#btn-umpire").click(function (event) {
            // Prevent the form from submitting via the browser.
            event.preventDefault();
            stompIt("NOTIFY_UMPIRE","NOTIFY_UMPIRE");
        });

        //#score-manager
        $("#bth-save").click(function (event) {
            // Prevent the form from submitting via the browser.
            event.preventDefault();
            stompIt("SAVE_TEAM_SETUP","SAVE_TEAM_SETUP");
        });

        $("#main-logo-select").change(function (event) {
            label = event.currentTarget.value.replace(/\\/g, '/').replace(/.*\//, '');
            $("#main-filename").val(label);
        });

        $("#btn-main-logo-upload").click(function (event) {
            event.preventDefault();
            uploadLogo("main-logo");
        });

        $("#team1-logo-select").change(function (event) {
            label = event.currentTarget.value.replace(/\\/g, '/').replace(/.*\//, '');
            $("#team1-filename").val(label);
        });

        $("#btn-team1-logo-upload").click(function (event) {
            event.preventDefault();
            uploadLogo("team1-logo");
        });

        $("#team2-logo-select").change(function (event) {
            label = event.currentTarget.value.replace(/\\/g, '/').replace(/.*\//, '');
            $("#team2-filename").val(label);
        });

        $("#btn-team2-logo-upload").click(function (event) {
            event.preventDefault();
            uploadLogo("team2-logo");
        });
    });

    function uploadLogo(key) {
        var fileSelect = $("#" + key + "-select")[0];
        var files = fileSelect.files;
        var formData = new FormData();

        // Loop through each of the selected files.
        for (var i = 0; i < files.length; i++) {
          var file = files[i];

          // Add the file to the request.
          formData.append('logo', file, file.name);
        }
        formData.append('key', key);
        $.ajax({
            url: 'scorer/image',  //Server script to process data
            type: 'POST',
            xhr: function() {  // Custom XMLHttpRequest
                var myXhr = $.ajaxSettings.xhr();
                if(myXhr.upload){ // Check if upload property exists
                    //myXhr.upload.addEventListener('progress',progressHandlingFunction, false); // For handling the progress of the upload
                }
                return myXhr;
            },
            //Ajax events
            //beforeSend: beforeSendHandler,
            success: function (result) {
                $("#" + key).attr("src", "${pageContext.request.contextPath}/scorer/image?key=" + key + "&"+new Date().getTime());
            },
            //error: errorHandler,
            // Form data
            data: formData,
            //Options to tell jQuery not to process data or worry about content-type.
            cache: false,
            contentType: false,
            processData: false
        });
    }

    function stompIt(clockCommand, logAction) {

        var actionTime = new Date();
        var score = {};
        var team1 = {};
        var team2 = {};
        var gameClock = {};
        var shotClock = {};

        score["command"] = clockCommand;
        score["action"] = logAction;
        score["actionTime"] = actionTime;
        score["period"] = $("#period").val();

        if (!$("#possession").is(':checked')) {
            score["direction"] = "LEFT";
        }
        else {
            score["direction"] = "RIGHT";
        }

        team1["name"] = $("#team1Name").val();
        team1["score"] = $("#team1Score").val();
        team1["coachTimeouts"] = $("#coach1Timeout").val();
        team1["teamTimeouts"] = $("#team1Timeout").val();
        team1["colour"] = $('input[name=team1Colour]:checked', '#score-manager').val();

        team2["name"] = $("#team2Name").val();
        team2["score"] = $("#team2Score").val();
        team2["coachTimeouts"] = $("#coach2Timeout").val();
        team2["teamTimeouts"] = $("#team2Timeout").val();
        team2["colour"] = $('input[name=team2Colour]:checked', '#score-manager').val();

        gameClock["mins"] = $("#gameClockMins").val();
        gameClock["secs"] = $("#gameClockSecs").val();
        gameClock["tenths"] = $("#gameClockTenths").val();

        shotClock["secs"] = $("#shotClockSecs").val();
        shotClock["tenths"] = $("#shotClockTenths").val();

        score["team1"] = team1;
        score["team2"] = team2;
        score["gameClock"] = gameClock;
        score["shotClock"] = shotClock;

        console.log("SUCCESS: ", score);

        stompClient.send("/topic/score", {}, JSON.stringify(score));

    }

</script>

</body>
</html>