<!DOCTYPE html>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html lang="en">
<head>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/bootstrap.min.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/jquery.countdown.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/scorer.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/bootstrap-toggle.min.css'/>"/>

    <script src="<c:url value='/scripts/jquery-2.1.4.js'/>"></script>
    <script src="<c:url value='/scripts/jquery.plugin.js'/>"></script>
    <script src="<c:url value='/scripts/jquery.countdown.js'/>"></script>
    <script src="<c:url value='/scripts/bootstrap.min.js'/>"></script>
    <script src="<c:url value='/scripts/bootstrap-toggle.min.js'/>"></script>
    <script src="<c:url value='/scripts/scorer-utils.js'/>"></script>
</head>

<nav class="navbar navbar-inverse">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Wheelchair Rugby Controller</a>
        </div>
    </div>
</nav>

<div class="container" style="min-height: 500px">

    <ul class="nav nav-pills">
        <li class="active"><a data-toggle="pill" href="#home">Game</a></li>
        <li><a data-toggle="pill" href="#menu1">Team Setup</a></li>
    </ul>
    <div class="tab-content">
        <div id="home" class="tab-pane fade in active">

            <form class="form-horizontal" id="game-manager">


            <div class="panel panel-primary">
                <div class="panel-body">
                    <!--style="text-align:center;"-->
                    <!--<div class="form-group form-group-lg">-->
                    <!--<label class="col-sm-2 control-label">Game Clock</label>-->

                    <!--<div class="col-sm-10">-->
                    <!--<span id="clock"></span>-->
                    <!--</div>-->
                    <!--</div>-->

                    <div class="row">
                        <div class="col-sm-8">
                            <div class="form-group form-group-lg" >
                                <label class="col-sm-4 control-label" >Game clock:</label>
                                <div class="col-sm-2" >
                                    <input type=text class="form-control input-lg" id="team1Score">
                                </div>
                                <div class="col-sm-4" >
                                    <button type="submit" id="bth-search" class="btn btn-primary btn-lg">Reset Quarter</button>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">
                            <div class="form-group">
                                <label class="col-sm-5 control-label">Period:</label>
                                <div class="col-sm-6">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number" disabled="disabled" data-type="minus" data-field="period[]">
                                            <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="period[]" value="1" min="1" max="4">
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
                                <label class="col-sm-4 control-label">Shot clock:</label>
                                <div class="col-sm-2" >
                                    <input type=text class="form-control input-lg" id="team1Score">
                                </div>
                                <div class="col-sm-2" >
                                    <button type="submit" id="bth-search" class="btn btn-primary btn-lg">Reset 40</button>
                                </div>
                                <div class="col-sm-2" >
                                    <button type="submit" id="bth-search" class="btn btn-primary btn-lg">Reset 15</button>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4">

                                <label class="col-sm-5 control-label">Posession:</label>
                                <div class="col-sm-5">

                                    <input type="checkbox" checked data-toggle="toggle" data-onstyle="info" data-offstyle="warning" data-on="<i class='fa fa-play'></i> ---&gt" data-off="<i class='fa fa-pause'></i> &lt---">

                                </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <div class="col-sm-12 align-cntr"">
                            <!-- http://www.bootstraptoggle.com/ -->
                            <!--<button type="submit" id="btn-start-stop" class="btn btn-success btn-lg btn-long">START</button>-->
                            <input type="checkbox" checked data-toggle="toggle" data-size="large" data-onstyle="success" data-offstyle="danger" data-on="<i class='fa fa-play'></i> START" data-off="<i class='fa fa-pause'></i> STOP">
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
                                <div class="col-sm-5">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number btn-lg" disabled="disabled" data-type="minus" data-field="team1Score[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="team1Score[]" id="team1Score" value="1" min="1" max="999">
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
                                <div class="col-sm-4">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number" disabled="disabled" data-type="minus" data-field="team1Timeout[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="team1Timeout[]" id="team1Timeout" value="1" min="1" max="4">
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
                                <div class="col-sm-4">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number" disabled="disabled" data-type="minus" data-field="coach1Timeout[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="coach1Timeout[]" id="coach1Timeout" value="1" min="1" max="2">
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
                                <div class="col-sm-5">

                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number btn-lg" disabled="disabled" data-type="minus" data-field="team2Score[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="team2Score[]" id="team2Score" value="1" min="1" max="999">
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
                                <div class="col-sm-4">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number" disabled="disabled" data-type="minus" data-field="team2Timeout[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="team2Timeout[]" id="team2Timeout" value="1" min="1" max="4">
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
                                <div class="col-sm-4">
                                    <div class="input-group">
                                        <span class="input-group-btn">
                                            <button type="button" class="btn btn-danger btn-number" disabled="disabled" data-type="minus" data-field="coach2Timeout[]">
                                                <span class="glyphicon glyphicon-minus"></span>
                                            </button>
                                        </span>
                                        <input type=text class="form-control input-number" name="coach2Timeout[]" id="coach2Timeout" value="1" min="1" max="2">
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
        <div id="menu1" class="tab-pane fade">
            <div class="panel panel-default">
                <!--<div class="panel-heading">Team Configuration</div>-->
                <div class="panel-body">

                    <form class="form-horizontal" id="score-manager">

                        <div class="row">
                            <div class="col-sm-6">

                                <div class="form-group form-group-lg">
                                    <label class="col-sm-4 control-label">Home Team Name</label>

                                    <div class="col-sm-6">
                                        <input type=text class="form-control" id="team1Name">
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group form-group-lg">
                                    <label class="col-sm-4 control-label">Team 1</label>

                                    <div class="col-sm-6">
                                        <input type="text" class="form-control" id="team2Name">
                                    </div>
                                </div>

                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-sm-offset-5 col-sm-10">
                                <button type="submit" id="bth-search" class="btn btn-primary btn-lg">Save</button>
                            </div>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>

    <!--<div class="panel-group">-->


    <!--</div>-->

    <!--
        <div class="starter-template">
            <h1>Score Controller</h1>
            <br>
        </div>
    -->

</div>

<div class="container">
    <footer>
        <p>
            Sponsored by <a href="http://http://auspost.com.au/">Australia Post</a>
        </p>
    </footer>
</div>

<script>
    var eightMinsLater = new Date();
    eightMinsLater.setMinutes(eightMinsLater.getMinutes() + 8);
    $('#clock').countdown({until: eightMinsLater, format: 'MS'});

    jQuery(document).ready(function ($) {

        $("#game-manager").submit(function (event) {
            if ($("#btn-start-stop").text() == "START") {
                $("#btn-start-stop").css( "background", "red" );
                $("#btn-start-stop").text("STOP");
            } else {
                $("#btn-start-stop").css( "background", "#5cb85c" );
                $("#btn-start-stop").text("START");
                //btn btn-success btn-lg btn-long
            }
        });

        $("#score-manager").submit(function (event) {
            // Prevent the form from submitting via the browser.
            event.preventDefault();

            submitViaAjax();

        });

    });

    function submitViaAjax() {

        var score = {}
        score["team1Name"] = $("#team1Name").val();
        score["team2Name"] = $("#team2Name").val();
        score["team1Score"] = $("#team1Score").val();
        score["team2Score"] = $("#team2Score").val();
// TODO we must change hardcoded URL/port... to get dynamically
        $.ajax({
            type: "POST",
            contentType: "application/json",
            url: "http://localhost:8090/score",
            data: JSON.stringify(score),
            dataType: 'json',
            timeout: 100000,
            success: function (data) {
                console.log("SUCCESS: ", data);
                display(data);
            },
            error: function (e) {
                console.log("ERROR: ", e);
                display(e);
            },

        });

    }

</script>

</body>
</html>