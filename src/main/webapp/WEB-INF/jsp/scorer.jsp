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
    <c:set var="teamColours">red,green,yellow,blue,orange,#222,#333,#DDD,white</c:set>
</head>
<body onload="init()">

<div class="container scorer-container">
    <div class="tab-content">
        <div id="home" class="tab-pane fade in active">

            <form class="form-horizontal" id="game-manager">

            <!-- ************************************************************************************************** -->
            <!-- TEAM SCORE and TIMEOUTS -->
            <!-- ************************************************************************************************** -->

            <div class="row">
                <div class="col-sm-5">
                    <div class="panel panel-success">
                        <div class="panel-heading">Team 1<strong><span id="team1NameLabel"></span></strong></div>
                        <div class="panel-body">
                            <div class="form-group form-group-lg">
                                <label class="col-sm-3 control-label">Score</label>
                                <div class="col-sm-9">
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
                            <div class="form-group form-group-lg">
                                <label class="col-sm-3 control-label">Player Timeouts</label>
                                <div class="col-sm-9">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number btn-lg" data-type="minus" data-field="team1Timeout[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="team1Timeout[]" id="team1Timeout" value="0" min="0" max="4">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-success btn-number btn-lg" disabled="disabled" data-type="plus" data-field="team1Timeout[]">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group form-group-lg">
                                <label class="col-sm-3 control-label">Coach Timeouts</label>
                                <div class="col-sm-9">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number btn-lg" data-type="minus" data-field="coach1Timeout[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="coach1Timeout[]" id="coach1Timeout" value="0" min="0" max="2">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-success btn-number btn-lg" disabled="disabled" data-type="plus" data-field="coach1Timeout[]">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-2">
                    <div class="panel panel-success">
                        <div class="panel-heading">Controls</div>
                        <div class="panel-body">
                            <div class="form-group form-group-lg">
                                <div class="col-sm-12">
                                    <div class="input-group">
                                        <input type="checkbox" id="start" checked data-toggle="toggle" data-size="large" data-onstyle="success" data-offstyle="danger" data-on="<i class='fa fa-play'></i> START" data-off="<i class='fa fa-pause'></i> STOP">
                                    </div>
                                </div>
                            </div>

                            <div class="form-group form-group-lg">                        
                                <div class="col-sm-12">
                                    <div class="input-group">
                                        <input type="checkbox" id="possession" checked data-toggle="toggle" data-size="large" data-onstyle="default" data-offstyle="default" data-on="<img src='images/green-arrow-right.png' width='50'/>" data-off="<img src='images/green-arrow-left.png' width='50'/>">
                                    </div>
                                </div>
                            </div>

                            <div class="form-group form-group-lg">                        
                                <div class="col-sm-12">
                                    <div class="input-group">
                                        <button type="button" id="btn-umpire" data-size="large" class="btn btn-warning btn-lg">Umpire</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-sm-5">
                    <div class="panel panel-success">
                        <div class="panel-heading">Team 2<strong><span id="team2NameLabel"></span></strong></div>
                        <div class="panel-body">
                            <div class="form-group form-group-lg">
                                <label class="col-sm-3 control-label">Score</label>
                                <div class="col-sm-9">

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
                            <div class="form-group form-group-lg">
                                <label class="col-sm-3 control-label">Player Timeouts</label>
                                <div class="col-sm-9">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number btn-lg" data-type="minus" data-field="team2Timeout[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="team2Timeout[]" id="team2Timeout" value="0" min="0" max="4">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-success btn-number btn-lg" disabled="disabled" data-type="plus" data-field="team2Timeout[]">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group form-group-lg">
                                <label class="col-sm-3 control-label">Coach Timeouts</label>
                                <div class="col-sm-9">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number btn-lg" data-type="minus" data-field="coach2Timeout[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="coach2Timeout[]" id="coach2Timeout" value="0" min="0" max="2">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-success btn-number btn-lg" disabled="disabled" data-type="plus" data-field="coach2Timeout[]">
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

            <!-- ************************************************************************************************** -->
            <!-- GAME CONTROLS -->
            <!-- ************************************************************************************************** -->
            <div class="row">
                <div class="col-sm-12">
                    <div class="panel panel-success">
                        <div class="panel-heading">Clock Controls</div>
                        <div class="panel-body">   
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="form-group form-group-lg" >
                                        <label class="col-sm-1 control-label" >Game clock</label>

                                        <div class="col-sm-3">
                                            <div class="input-group">
                                                <span class="input-group-btn">
                                                    <button id="gameClockMinsMinus" type="button" class="btn btn-danger btn-number btn-lg" data-type="minus" data-field="gameClockMins[]">
                                                    <span class="glyphicon glyphicon-minus"></span>
                                                    </button>
                                                </span>

                                                <input type=text class="form-control input-number input-lg" name="gameClockMins[]" id="gameClockMins" min="0" max="59">

                                                <span class="input-group-btn">
                                                     <button id="gameClockMinsPlus" type="button" class="btn btn-success btn-number btn-lg" data-type="plus" data-field="gameClockMins[]">
                                                    <span class="glyphicon glyphicon-plus"></span>
                                                    </button>
                                               </span>
                                            </div>
                                        </div>

                                        <div class="col-sm-3">
                                            <div class="input-group">
                                                <span class="input-group-btn">
                                                    <button id="gameClockSecsMinus" type="button" class="btn btn-danger btn-number btn-lg" data-type="minus" data-field="gameClockSecs[]">
                                                    <span class="glyphicon glyphicon-minus"></span>
                                                    </button>
                                                </span>

                                                <input type=text class="form-control input-number input-lg" id="gameClockSecs" name="gameClockSecs[]" min="0" max="59">
                                                
                                                <span class="input-group-btn">
                                                    <button id="gameClockSecsPlus" type="button" class="btn btn-success btn-number btn-lg" data-type="plus" data-field="gameClockSecs[]">
                                                    <span class="glyphicon glyphicon-plus"></span>
                                                    </button>
                                                </span>
                                            </div>
                                        </div>

                                        <div class="col-sm-3">
                                            <div class="input-group">
                                                <span class="input-group-btn">
                                                    <button id="gameClockTenthsMinus" type="button" class="btn btn-danger btn-number btn-lg" data-type="minus" data-field="gameClockTenths[]">
                                                    <span class="glyphicon glyphicon-minus"></span>
                                                     </button>
                                                </span>

                                                <input type=text class="form-control input-number input-lg" id="gameClockTenths" name="gameClockTenths[]" min="0" max="9">

                                                <span class="input-group-btn">
                                                    <button id="gameClockTenthsPlus" type="button" class="btn btn-success btn-number btn-lg" data-type="plus" data-field="gameClockTenths[]">
                                                    <span class="glyphicon glyphicon-plus"></span>
                                                    </button>
                                                </span>
                                            </div>

                                        </div>
                                        <div class="col-sm-1">
                                            <button type="button" id="bth-reset-qtr" class="btn btn-primary btn-lg">Reset Quarter</button>
                                        </div>
                                        
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="form-group form-group-lg" >
                                        <label class="col-sm-1 control-label">Shot clock</label>

                                        <div class="col-sm-3">
                                            <div class="input-group">
                                                <span class="input-group-btn">
                                                    <button id="shotClockSecsMinus" type="button" class="btn btn-danger btn-number btn-lg" data-type="minus" data-field="shotClockSecs[]">
                                                    <span class="glyphicon glyphicon-minus"></span>
                                                    </button>
                                                </span>

                                                <input type=text class="form-control input-number input-lg" id="shotClockSecs" name="shotClockSecs[]" min="0" max="59">

                                                <span class="input-group-btn">
                                                    <button id="shotClockSecsPlus" type="button" class="btn btn-success btn-number btn-lg" data-type="plus" data-field="shotClockSecs[]">
                                                    <span class="glyphicon glyphicon-plus"></span>
                                                    </button>
                                                </span>
                                            </div>
                                        </div>
                                            
                                        <div class="col-sm-3">
                                            <div class="input-group">
                                                <span class="input-group-btn">
                                                    <button id="shotClockTenthsMinus" type="button" class="btn btn-danger btn-number btn-lg" data-type="minus" data-field="shotClockTenths[]">
                                                    <span class="glyphicon glyphicon-minus"></span>
                                                    </button>
                                                </span>

                                                <input type=text class="form-control input-number input-lg" id="shotClockTenths" name="shotClockTenths[]" min="0" max="9">

                                                <span class="input-group-btn">
                                                    <button id="shotClockTenthsPlus" type="button" class="btn btn-success btn-number btn-lg" data-type="plus" data-field="shotClockTenths[]">
                                                    <span class="glyphicon glyphicon-plus"></span>
                                                    </button>
                                                </span>
                                            </div>
                                        </div>

                                        <div class="col-sm-3">
                                            <button type="button" id="bth-reset-40" class="btn btn-primary btn-lg">Reset</button>
                                        </div>
                                        <div class="col-sm-2" >
                                            <button type="button" id="bth-reset-15" class="btn btn-primary btn-lg">Reset 15</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="form-group form-group-lg" >
                                        <label class="col-sm-1 control-label">Quarter</label>
                                        <div class="col-sm-3">
                                            <div class="input-group">
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-danger btn-number btn-lg" disabled="disabled" data-type="minus" data-field="period[]">
                                                        <span class="glyphicon glyphicon-minus"></span>
                                                    </button>
                                                </span>
                                                <input type=text class="form-control input-number" name="period[]" id="period" value="1" min="1" max="4">
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-success btn-number btn-lg" data-type="plus" data-field="period[]">
                                                        <span class="glyphicon glyphicon-plus"></span>
                                                    </button>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="form-group form-group-lg" >
                                        <label class="col-sm-1 control-label">Message</label>
                                        <div class="col-sm-6">
                                            <input type=text class="form-control input-lg" id="gameMessage">
                                        </div>
                                        <div class="col-sm-3"  >
                                            <button type="button" id="btn-game-message" class="btn btn-primary btn-lg">Set Message</button>
                                        </div>
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

                <div class="row">
                    <div class="col-sm-6">
                        <div class="panel panel-success">
                            <div class="panel-heading"><strong>Team 1</strong></div>
                            <div class="panel-body">
                                <div class="form-group form-group-lg">
                                    <label class="col-sm-2 control-label">Name</label>
                                    <div class="col-sm-9">
                                        <input type=text class="form-control" id="team1Name" value="Home">
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
                                        <input type="text" class="form-control" id="team2Name" value="Away">
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
        </div><!-- end TAB PANE for "Team Setup"-->

        <div id="menu2" class="tab-pane fade">
            <form class="form-horizontal" id="configuration-manager">

                <div class="row">
                    <div class="col-sm-12">

                        <div class="panel panel-success">
                            <div class="panel-heading">Game setup</div>
                            <div class="panel-body">

                                <div class="form-group form-group-lg">
                                    <label class="col-sm-4 control-label">Seconds in a quarter</label>
                                    <div class="col-sm-2">
                                        <input type="text" class="form-control" id="secondsInQuarter">
                                    </div>
                                </div>
                                <div class="form-group form-group-lg">
                                    <label class="col-sm-4 control-label">Shot clock seconds</label>
                                    <div class="col-sm-2">
                                        <input type="text" class="form-control" id="shotClockSeconds">
                                    </div>
                                </div>
                                <div class="form-group form-group-lg">
                                    <label class="col-sm-4 control-label">Display shot clock</label>
                                    <div class="col-sm-2">
                                        <input type="checkbox" class="form-control" value="true" id="displayShotClock" checked>
                                    </div>
                                </div>
                                <div class="form-group form-group-lg">
                                    <label class="col-sm-4 control-label">Number of player timeouts</label>
                                    <div class="col-sm-2">
                                        <input type="text" class="form-control" id="numberOfTeamTimeouts" value="4">
                                    </div>
                                </div>
                                <div class="form-group form-group-lg">
                                    <label class="col-sm-4 control-label">Number of coach timeouts</label>
                                    <div class="col-sm-2">
                                        <input type="text" class="form-control" id="numberOfCoachTimeouts" value="2">
                                    </div>
                                </div>

                                <div class="form-group form-group-lg">
                                    <label class="col-sm-4 control-label">Background Colour</label>
                                    <div class="col-sm-8">
                                        <div class="radio colour-picker">
                                            <ul>
                                                <c:forTokens items="${teamColours}" delims="," var="colour">
                                                    <li><input type="radio" name="backgroundColour" value="${colour}"><div style="background:${colour};"></div></li>
                                                </c:forTokens>
                                            </ul>
                                        </div>
                                    </div>
                                </div>

                            </div>

                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-sm-offset-4 col-sm-10">
                        <button type="button" id="btn-applySettings" class="btn btn-primary btn-lg">Apply Settings</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

</div>

<nav class="navbar navbar-inverse navbar-fixed-bottom footer">
    <div class="container">
        <ul class="nav nav-pills">
            <li class="active"><a data-toggle="pill" href="#home">Game Controls</a></li>
            <li><a data-toggle="pill" href="#menu1">Scoreboard Setup</a></li>
            <li><a data-toggle="pill" href="#menu2">Game Settings</a></li>
        </ul>
    </div>
</nav>    

<script type="text/javascript">

    var stompClient = null;
    var gameClock = new Timer();
    var shotClock = new Timer();
    var showShotClock = true;

    //################## Adding Clock event listeners ############################
    shotClock.addEventListener('targetAchieved', function (e) {

        pauseClocks();
        shotClock.stop();
        $("#shotClockTenths").val(padDigits(0));
        stompIt("SHOT_CLOCK_END", "Shot clock timed out");
        var startSecs = getDefaultTotalShotClockSecTenths();
        startShotClock(startSecs);
        shotClock.pause();
        $('#start').off('change');
        $('#start').bootstrapToggle('on');
        $('#start').on('change', handleStartStop);

        $("#shotClockTenthsMinus").attr("disabled", true);
        $("#shotClockTenthsPlus").attr("disabled", false);
    });

    gameClock.addEventListener('targetAchieved', function (e) {

        stopClocks();
        $("#shotClockTenths").val(padDigits(0));
        $("#gameClockTenths").val(padDigits(0));
        $('#start').off('change');
        $('#start').bootstrapToggle('on');
        $('#start').on('change', handleStartStop);
        $('#period').val(+$("#period").val() + 1);
        showShotClock = true;
        startGameClock();
        pauseClocks();
        stompIt("QUARTER_END", "Quarter clock timed out");

        $("#gameClockTenthsMinus").attr("disabled", true);
        $("#gameClockTenthsPlus").attr("disabled", false);
    });

    gameClock.addEventListener('secondsUpdated', function (e) {

        //enable & disable controls according to time adjustments
        updateGameControlButtonsOnClockChange();
    });

    gameClock.addEventListener('secondTenthsUpdated', function (e) {

        var shotClockTenths = getDefaultTotalShotClockSecTenths();
        //console.log("GAME CLOCK",gameClock.getTimeValues().toString(), shotClockTenths);
        $("#gameClockMins").val(padDigits(gameClock.getTimeValues().minutes));
        $("#gameClockSecs").val(padDigits(gameClock.getTimeValues().seconds));
        $("#gameClockTenths").val(gameClock.getTimeValues().secondTenths);
        if (showShotClock && gameClock.getTimeValues().minutes === 0
                && gameClock.getTimeValues().seconds < (shotClockTenths / 10)) {
            sendHideShotClockCmd(shotClockTenths);
        }
    });

    shotClock.addEventListener('secondsUpdated', function (e) {
        //enable & disable controls according to time adjustments
        updateShotControlButtonsOnClockChange();
    });

    shotClock.addEventListener('secondTenthsUpdated', function (e) {
        //console.log("SHOT CLOCK", shotClock.getTimeValues());
        $("#shotClockSecs").val(padDigits(shotClock.getTimeValues().seconds));
        $("#shotClockTenths").val(shotClock.getTimeValues().secondTenths);
    });

    gameClock.addEventListener('paused', function (e) {
        //enable & disable tenth second controls
        updateTenthControls();
    });

    //################## END Clock event listeners ############################

    function init() {
        connect();
        initClocks();
        setTimeouts();
    }

    function initClocks() {
        startGameClock(4800, 400);
        pauseClocks();
        $("#secondsInQuarter").val(480);
        $("#shotClockSeconds").val(40);
        $("#bth-reset-40").html("Reset " + getDefaultTotalShotClockSecTenths() / 10);
    }

    function connect() {
        var socket = new SockJS('<c:url value="/stomp"/>');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function (frame) {
            console.log('Connected: ' + frame);
            stompClient.subscribe('/topic/score', function (score) {
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

    function setTimeouts() {
        $("#team1Timeout").val($("#numberOfTeamTimeouts").val());
        $("#team2Timeout").val($("#numberOfTeamTimeouts").val());
        $("#coach1Timeout").val($("#numberOfCoachTimeouts").val());
        $("#coach2Timeout").val($("#numberOfCoachTimeouts").val());
    }

    function getDefaultTotalGameClockSecTenths(){
        var quarterDefaultSecs = $("#secondsInQuarter").val();
        if(+quarterDefaultSecs === 0){
            return 0;
        }
        return (+quarterDefaultSecs || 480) * 10;
    }

    function getDefaultTotalShotClockSecTenths(){
        var shotDefaultSecs = $("#shotClockSeconds").val();
        return (+shotDefaultSecs || 40) * 10;
    }

    function startGameClock(gameTenthsSecs, shotClockTenthsSec) {

        //start quarter clock, default is 8 mins if not already running
        var gameClockStartTenths;
        if(gameTenthsSecs === 0){
            gameClockStartTenths = 0;
        }else{
            gameClockStartTenths = gameTenthsSecs || getDefaultTotalGameClockSecTenths();
        }

        gameClock.start({
            precision: 'secondTenths',
            countdown: true,
            startValues: {secondTenths: gameClockStartTenths}
        });
        $("#gameClockMins").val(padDigits(gameClock.getTimeValues().minutes));
        $("#gameClockSecs").val(padDigits(gameClock.getTimeValues().seconds));
        $("#gameClockTenths").val(gameClock.getTimeValues().secondTenths);
        //enable/disable controls on clock start
        updateGameControlButtonsOnClockChange();

        //starting quarter clock should always start shot clock, default 40 secs if time not supplied
        var shotClockTime = shotClockTenthsSec || getDefaultTotalShotClockSecTenths();
        startShotClock(shotClockTime);
    }

    function startShotClock(shotClockTenths) {

        if (showShotClock) {

            var shotClockStartTenths;
            if(shotClockTenths === 0){
                shotClockStartTenths = 0;
            }else{
                shotClockStartTenths = shotClockTenths || getDefaultTotalShotClockSecTenths;
            }
            shotClock.start({
                precision: 'secondTenths',
                countdown: true,
                startValues: {secondTenths: shotClockStartTenths}
            });
            $("#shotClockSecs").val(padDigits(shotClock.getTimeValues().seconds));
            $("#shotClockTenths").val(shotClock.getTimeValues().secondTenths);
            //enable/disable controls on clock start
            updateShotControlButtonsOnClockChange();
        }
    }

    function updateTenthControls() {
        $("#gameClockTenthsMinus").attr("disabled", gameClock.getTimeValues().secondTenths === 0);
        $("#gameClockTenthsPlus").attr("disabled", gameClock.getTimeValues().secondTenths > 8);
        $("#shotClockTenthsMinus").attr("disabled", shotClock.getTimeValues().secondTenths === 0);
        $("#shotClockTenthsPlus").attr("disabled", shotClock.getTimeValues().secondTenths > 8);
    }

    function updateGameControlButtonsOnClockChange() {
        $("#gameClockMinsPlus").attr("disabled", gameClock.getTimeValues().minutes > 58);
        $("#gameClockMinsMinus").attr("disabled", gameClock.getTimeValues().minutes === 0);
        $("#gameClockSecsPlus").attr("disabled", gameClock.getTimeValues().seconds > 58);
        $("#gameClockSecsMinus").attr("disabled", gameClock.getTimeValues().seconds === 0);
        $("#gameClockTenthsPlus").attr("disabled", false);
        $("#gameClockTenthsMinus").attr("disabled", false);
    }

    function updateShotControlButtonsOnClockChange() {
        $("#shotClockSecsPlus").attr("disabled", shotClock.getTimeValues().seconds > 58);
        $("#shotClockSecsMinus").attr("disabled", shotClock.getTimeValues().seconds === 0);
        $("#shotClockTenthsPlus").attr("disabled", false);
        $("#shotClockTenthsMinus").attr("disabled", false);
    }

    function sendHideShotClockCmd(shotClockTenths) {
        shotClock.stop();
        startShotClock(shotClockTenths);
        shotClock.pause();
        showShotClock = false;
        stompIt("HIDE_SHOT_CLOCK","Hiding shot clock, quarter clock time remaining is less than shot clock");
    }

    function handleStartStop() {
        if (!$("#start").is(':checked')) {
            stopClocks();
            startGameClock(gameClockInTenths(), shotClockInTenths());
            stompIt("START_CLOCK","'Start' button clicked");
        } else {
            pauseClocks();
            stompIt("STOP_CLOCK","'Stop' button clicked");
        }
    }

    function resetShotClock(event) {
        shotClock.stop();
        if (event.full) {
            var resetFull = getDefaultTotalShotClockSecTenths();
            startShotClock(resetFull);
            stompIt("START_CLOCK", event.actionMessage);
        } else {
            stopGameWithoutEventFire();
            startShotClock(150);
            pauseClocks();
            stompIt("STOP_CLOCK", event.actionMessage);
        }

    }

    function stopGameWithoutEventFire() {
        $('#start').off('change');
        if (!$("#start").is(':checked')) {
            $('#start').bootstrapToggle('on')
        }
        $('#start').on('change',handleStartStop);
    }

    function gameClockInTenths() {
        return ((+$("#gameClockMins").val() * 600)
            + (+$("#gameClockSecs").val() * 10)
            + parseInt($("#gameClockTenths").val(), 10));
    }

    function shotClockInTenths() {
        return ((+$("#shotClockSecs").val() * 10) + parseInt($("#shotClockTenths").val(), 10));
    }

    var clickClockTimes = function(event) {
        event.preventDefault();
        gameClock.pause();
        shotClock.pause();
        stopGameWithoutEventFire();
        stompIt("STOP_CLOCK",event.data.actionMessage);
    };

    var changeGameTimes = function (event) {
        event.preventDefault();
        if (gameClock.isRunning()) {
            gameClock.stop();
            shotClock.pause();
            stopGameWithoutEventFire();
            stompIt("STOP_CLOCK", "Changing " + event.data.actionMessage);
        } else {
            gameClock.stop();
        }
        var mins = $("#gameClockMins").val();
        var secs = $("#gameClockSecs").val();
        var tenths = $("#gameClockTenths").val();
        var totalTenths = ((+mins * 600) + (+secs * 10) + parseInt(tenths, 10));
        var shotTenths = ((+$("#shotClockSecs").val() * 10) + parseInt($("#shotClockTenths").val(), 10));
        startGameClock(totalTenths, shotTenths);
        pauseClocks();
        stompIt("STOP_CLOCK", "Changed " + event.data.actionMessage);
    };

    var changeShotTimes = function (event) {
        event.preventDefault();
        if (gameClock.isRunning()) {
            gameClock.pause();
            shotClock.stop();
            stopGameWithoutEventFire();
            stompIt("STOP_CLOCK", "Changing " + event.data.actionMessage);
        } else {
            shotClock.stop();
        }
        var secTenths = ((+$("#shotClockSecs").val() * 10) + parseInt($("#shotClockTenths").val(), 10));
        startShotClock(secTenths);
        pauseClocks();
        stompIt("STOP_CLOCK", "Changed " + event.data.actionMessage);
    };

    var handleTimeouts = function (event) {
        event.preventDefault();
        pauseClocks();
        stopGameWithoutEventFire();
        stompIt("TIMEOUT", event.data.actionMessage);
    };

    var handleScore = function (event) {
        event.preventDefault();
        stopGameWithoutEventFire();
        shotClock.stop();
        var resetFull = getDefaultTotalShotClockSecTenths();
        startShotClock(resetFull);
        pauseClocks();
        stompIt("SCORE", event.data.actionMessage);
    };

    jQuery(document).ready(function ($) {

        //GAME (QUARTER) CLOCK events
        //MINUTES
        $("#gameClockMins").on('click', {
            actionMessage: "Changing quarter clock minutes"
        },clickClockTimes);
        $("#gameClockMins").on('change', {
            actionMessage: "quarter clock minutes"
        },changeGameTimes);

        //SECONDS
        $("#gameClockSecs").on('click', {
            actionMessage: "Changing quarter clock seconds"
        },clickClockTimes);
        $("#gameClockSecs").on('change', {
            actionMessage: "quarter clock seconds"
        },changeGameTimes);

        //TENTHS
        $("#gameClockTenths").on('click', {
            actionMessage: "Changing quarter clock tenth of seconds"
        },clickClockTimes);
        $("#gameClockTenths").on('change', {
            actionMessage: "quarter clock tenth of seconds"
        },changeGameTimes);

        //SHOT CLOCK events
        //SECONDS
        $("#shotClockSecs").on('click', {
            actionMessage: "Changing shot clock seconds"
        },clickClockTimes);
        $("#shotClockSecs").on('change', {
            actionMessage: "shot clock seconds"
        },changeShotTimes);

        //TENTHS
        $("#shotClockTenths").on('click', {
            actionMessage: "Changing shot clock tenth of seconds"
        },clickClockTimes);
        $("#shotClockTenths").on('change', {
            actionMessage: "shot clock tenth of seconds"
        },changeShotTimes);

        //handle scores
        $("#team1Score").on('change', {
            actionMessage: "Team 1 scored"
        },handleScore);

        $("#team2Score").on('change', {
            actionMessage: "Team 2 scored"
        },handleScore);

        //handle timeouts
        $("#team1Timeout").on('change', {
            actionMessage: "Add team 1 player timeout"
        },handleTimeouts);

        $("#team2Timeout").on('change', {
            actionMessage: "Add team 2 player timeout"
        },handleTimeouts);

        $("#coach1Timeout").on('change', {
            actionMessage: "Add team 1 coach timeout"
        },handleTimeouts);

        $("#coach2Timeout").on('change', {
            actionMessage: "Add team 2 coach timeout"
        },handleTimeouts);

        $("#period").change(function (event) { stompIt("","Changed quarter period"); });
        $("#possession").change(function (event) { stompIt("","Changed team possession indicator"); });
        $("#start").change(handleStartStop);

        $("#bth-reset-qtr").click(function (event) {
            // Prevent the form from submitting via the browser.
            event.preventDefault();
            stopClocks();
            stopGameWithoutEventFire();
            startGameClock();
            pauseClocks();
            showShotClock = true;
            stompIt("STOP_CLOCK","'Reset Quarter' button clicked");
            $("#bth-reset-40").html("Reset " + getDefaultTotalShotClockSecTenths() / 10);
        });

        $("#bth-reset-40").click(function (event) {
            event.preventDefault();
            resetShotClock({
                            full: true,
                            actionMessage: "'Reset' Shot clock button clicked"
                            });
        });

        $("#bth-reset-15").click(function (event) {
            event.preventDefault();
            resetShotClock({
                            full: false,
                            actionMessage: "'Reset 15' Shot clock button clicked"
                            });
        });

        $("#btn-umpire").click(function (event) {
            // Prevent the form from submitting via the browser.
            event.preventDefault();
            stompIt("NOTIFY_UMPIRE","'Umpire' button clicked");
        });

        $("#btn-game-message").click(function (event) {
            // Prevent the form from submitting via the browser.
            event.preventDefault();
            stompIt("UPDATE_GAME_MESSAGE","'Set Game Message' button clicked");
        });

        //#score-manager
        $("#bth-save").click(function (event) {
            // Prevent the form from submitting via the browser.
            event.preventDefault();
            $("#team1NameLabel").text(" - " + $("#team1Name").val());
            $("#team2NameLabel").text(" - " + $("#team2Name").val());
            stompIt("SAVE_TEAM_SETUP", "Updating Team Setup");
        });

        $("#btn-applySettings").click(function (event) {
            // Prevent the form from submitting via the browser.
            event.preventDefault();
            stompIt("SAVE_TEAM_SETUP","Updating Configuration");
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

        bindRepeatClick($("#gameClockMinsMinus"));
        bindRepeatClick($("#gameClockMinsPlus"));
        bindRepeatClick($("#gameClockSecsMinus"));
        bindRepeatClick($("#gameClockSecsPlus"));
        bindRepeatClick($("#gameClockTenthsMinus"));
        bindRepeatClick($("#gameClockTenthsPlus"));
        bindRepeatClick($("#shotClockSecsMinus"));
        bindRepeatClick($("#shotClockSecsPlus"));
        bindRepeatClick($("#shotClockTenthsMinus"));
        bindRepeatClick($("#shotClockTenthsPlus"));
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
        score["displayShotClock"] = showShotClock && $('input[id=displayShotClock]:checked', '#configuration-manager').val() === 'true';
        score["teamTimeoutLimit"] = $("#numberOfTeamTimeouts").val();
        score["coachTimeoutLimit"] = $("#numberOfCoachTimeouts").val();
        $("#team1Timeout").attr("max", $("#numberOfTeamTimeouts").val());
        $("#team2Timeout").attr("max", $("#numberOfTeamTimeouts").val());
        $("#coach1Timeout").attr("max", $("#numberOfCoachTimeouts").val());
        $("#coach2Timeout").attr("max", $("#numberOfCoachTimeouts").val());

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
        score["backgroundColour"] = $('input[name=backgroundColour]:checked', '#configuration-manager').val();
        score["scrollerMessage"] = $("#gameMessage").val();
        
        console.log("SUCCESS: ", score);

        stompClient.send("/topic/score", {}, JSON.stringify(score));
    }

    function bindRepeatClick(element) {
        element.bind({
            mousedown: function() {
                repeatClick($(this));
            },
            mouseup: function() {
                stopRepeatClick($(this));
            },
            mouseout: function() {
                stopRepeatClick($(this));
            }
        });
    }

    var interval;

    function repeatClick(element) {
        clearInterval(interval);
        interval = setInterval(clickElement, 150, element);
    }

    function stopRepeatClick(element) {
        clearInterval(interval);
    }

    function clickElement(element) {
        if (element.is(':disabled')) {
            stopRepeatClick(element);
        } else {
            element.click();
        }
    }
</script>

</body>
</html>